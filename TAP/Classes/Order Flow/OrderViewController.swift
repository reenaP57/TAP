//
//  OrderViewController.swift
//  TAP
//
//  Created by mac-00017 on 14/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class OrderViewController: ParentViewController {
    
    @IBOutlet weak var tblOrder : UITableView!
    @IBOutlet weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet weak var lblNoData : UILabel!

    var apiTask : URLSessionTask?
    var refreshControl = UIRefreshControl()
    var arrOrderList = [[String : AnyObject]]()
    var currentPage = 1
    var lastPage = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate?.showTabBar()
    }
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = CYourOrders
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = CColorNavRed
        self.tblOrder.pullToRefreshControl = refreshControl
        
        tblOrder.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)

        self.loadOrderList(isRefresh: false)
    }
    
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension OrderViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrderList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell") as? OrderTableViewCell {
            
            let dict = arrOrderList[indexPath.row]
            let dateFormat = DateFormatter()
            
            
            cell.lblResName.text = dict.valueForString(key: CName)
            cell.lblResLocation.text = dict.valueForString(key: CAddress)
            cell.lblTime.text =  dateFormat.string(timestamp: dict.valueForDouble(key: CCreated_at)!, dateFormat: "MMM dd, yyyy' at 'hh:mm a")
            cell.lblAmount.text = String(format: "$%.2f", (dict.valueForDouble(key: COrder_total) ?? 0.0))
            
            let arrCuisine = dict.valueForJSON(key: CCuisine) as? [[String : AnyObject]]
            let arrCuisineName = arrCuisine?.compactMap({$0[CName]}) as? [String]
            cell.lblCuisineOrdered.text = arrCuisineName?.joined(separator: "-")
            
            cell.imgVDish.sd_setShowActivityIndicatorView(true)
            cell.imgVDish.sd_setImage(with: URL(string: dict.valueForString(key: CImage)), placeholderImage: nil)
            
            
            if dict.valueForInt(key: COrder_status) == COrderStatusComplete {
                cell.imgVOrderStatus.hide(byHeight: true)
                cell.lblOrderStatus.hide(byHeight: true)
                cell.lblOrderStatus.text = ""
                
            } else {
                cell.imgVOrderStatus.hide(byHeight: false)
                cell.lblOrderStatus.hide(byHeight: false)
                
                switch (dict.valueForInt(key: COrder_status)) {
                
                case COrderStatusPending :
                     cell.lblOrderStatus.text = COrderPending
                case COrderStatusAccept:
                     cell.lblOrderStatus.text = COrderAccepted
                case COrderStatusReject:
                     cell.lblOrderStatus.text = COrderRejected
                case COrderStatusReady:
                     cell.lblOrderStatus.text = COrderReady
                default:
                    cell.lblOrderStatus.text = ""
                }
            }

        
            if indexPath == tblOrder.lastIndexPath() {
                
                //...Load More
                if currentPage < lastPage {
                    
                    if apiTask?.state == URLSessionTask.State.running {
                        self.loadOrderList(isRefresh: false)
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = arrOrderList[indexPath.row]
        
        if let orderDetailVC = COrder_SB.instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController {
            
            orderDetailVC.orderID = dict.valueForInt(key: COrderID)
            
            if indexPath.row == 2 {
                orderDetailVC.isCompleted = true
            }
            self.navigationController?.pushViewController(orderDetailVC, animated: true)
        }
    }
}


//MARK:-
//MARK:- API Method

extension OrderViewController {
    
    @objc func pullToRefresh() {
        currentPage = 1
        refreshControl.beginRefreshing()
        self.loadOrderList(isRefresh: true)
    }
    
    func loadOrderList (isRefresh : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if !isRefresh{
            tblOrder.isHidden = true
            activityLoader.startAnimating()
        }
        
        apiTask = APIRequest.shared().orderList(completion: { (response, error) in
        
            self.apiTask?.cancel()
            self.activityLoader.stopAnimating()
            self.refreshControl.endRefreshing()
            
            if response != nil && error == nil {
                
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                
                if self.currentPage == 1 {
                    self.arrOrderList.removeAll()
                }
                
                if arrData.count > 0 {
                    
                    for item in arrData {
                       self.arrOrderList.append(item)
                    }
                }
                
                self.lastPage = metaData.valueForInt(key: CLastPage)!
                
                if metaData.valueForInt(key: CCurrentPage)! < self.lastPage {
                    self.currentPage = metaData.valueForInt(key: CCurrentPage)! + 1
                }
                
                
                self.tblOrder.isHidden = self.arrOrderList.count == 0
                self.lblNoData.isHidden = !self.tblOrder.isHidden
                self.tblOrder.reloadData()
            }
        })
        
    }
}
