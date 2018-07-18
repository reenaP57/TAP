//
//  PromotionViewController.swift
//  TAP
//
//  Created by mac-00017 on 13/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class PromotionViewController: ParentViewController {

    @IBOutlet weak var tblPromotion : UITableView!
    @IBOutlet weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet weak var lblNoData : UILabel!

    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var arrPromotion = [[String : AnyObject]]()
    var restaurantID : Int?
    
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
        appDelegate?.hideTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = CPromotions
        
        tblPromotion.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)

        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = CColorNavRed
        tblPromotion.pullToRefreshControl = refreshControl
        
        self.loadPromotionList(isRefresh: false)
    }

}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension PromotionViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPromotion.count
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionTableViewCell") as? PromotionTableViewCell {
            
            let dict = arrPromotion[indexPath.row]
            cell.lblOffer.text = dict.valueForString(key: CName)
           
        
            cell.imgVOffer.sd_setShowActivityIndicatorView(true)
            cell.imgVOffer.sd_setImage(with: URL(string: (dict.valueForString(key: CImage))), placeholderImage: nil)
            
            if indexPath == tblPromotion.lastIndexPath() {
                
                //...Load More
                if currentPage < lastPage {
                    
                    if apiTask?.state == URLSessionTask.State.running {
                        self.loadPromotionList(isRefresh: false)
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}


//MARK:-
//MARK:- API Method

extension PromotionViewController {
    
    @objc func pullToRefresh(){
        
        currentPage = 1
        refreshControl.beginRefreshing()
        self.loadPromotionList(isRefresh: true)
    }
    
    func loadPromotionList(isRefresh : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if !isRefresh {
            activityLoader.startAnimating()
        }
        
        let dict = [CRestaurant_id : restaurantID,
                    CPage : currentPage,
                    CPerPage : CLimit] as [String : AnyObject]
        
        apiTask = APIRequest.shared().promotionList(param: dict, completion: { (response, error) in
        
            self.apiTask?.cancel()
            self.refreshControl.endRefreshing()
            self.activityLoader.stopAnimating()
            
            if response != nil && error == nil {
                                
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                
                if self.currentPage == 1 {
                    self.arrPromotion.removeAll()
                }
                
                if arrData.count > 0 {
                    for item in arrData {
                        self.arrPromotion.append(item)
                    }
                }
                
                self.lastPage = metaData.valueForInt(key: CLastPage)!
                
                if metaData.valueForInt(key: CCurrentPage)! < self.lastPage {
                    self.currentPage = metaData.valueForInt(key: CCurrentPage)!
                }
                
                self.lblNoData.isHidden = self.arrPromotion.count != 0
                self.tblPromotion.reloadData()
            }
        })
    }
}

