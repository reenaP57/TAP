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
    
    var arrOrderList = [Any]()
    
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
        
        tblOrder.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        
        arrOrderList = [["res_name":"Cafe De Perks", "res_loc":"Alpha One Mall","amount":"20","cuisine":"Margarita Pizza","time":"Nov 23, 2017 at 7:30 PM","status":COrderAccepted],
        ["res_name":"Cafe De Perks", "res_loc":"Alpha One Mall","amount":"6","cuisine":"Chocolate Cake","time":"Nov 23, 2017 at 7:30 PM","status":COrderReady],
        ["res_name":"Cafe De Perks", "res_loc":"Alpha One Mall","amount":"9","cuisine":"Chocolate Cake","time":"Nov 23, 2017 at 7:30 PM","status":""]]
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
            
            let dict = arrOrderList[indexPath.row] as? [String : AnyObject]
            
            cell.lblResName.text = dict?.valueForString(key: "res_name")
            cell.lblResLocation.text = dict?.valueForString(key: "res_loc")
            cell.lblCuisineOrdered.text = dict?.valueForString(key: "cuisine")
            cell.lblTime.text = dict?.valueForString(key: "time")
            cell.lblAmount.text = "$\(dict?.valueForString(key: "amount") ?? "")"
            
            if dict?.valueForString(key: "status") == "" {
                cell.imgVOrderStatus.hide(byHeight: true)
                cell.lblOrderStatus.hide(byHeight: true)

                cell.lblOrderStatus.text = ""
            } else{
                cell.imgVOrderStatus.hide(byHeight: false)
                cell.lblOrderStatus.hide(byHeight: false)

                cell.lblOrderStatus.text = dict?.valueForString(key: "status")
            }

            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let orderDetailVC = COrder_SB.instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController {
            self.navigationController?.pushViewController(orderDetailVC, animated: true)
        }
    }
}

