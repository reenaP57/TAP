//
//  SeeAllRestaurantViewController.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SeeAllRestaurantViewController: ParentViewController {
    
    @IBOutlet weak var tblRestList : UITableView!{
        didSet {
            tblRestList.register(UINib(nibName: "SearchRestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchRestaurantTableViewCell")
        }
    }
    @IBOutlet weak var activityLoader : UIActivityIndicatorView!
    
    var arrRestData = [[String : AnyObject]]()
    var strTitle = String()
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
   
    fileprivate var lastPage : Int = 0
    fileprivate var currentPage : Int = 1
    
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
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = strTitle
    
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavouriteStatus), name: NSNotification.Name(rawValue: kNotificationUpdateFavStatus), object: nil)
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = CColorNavRed
        tblRestList?.pullToRefreshControl = refreshControl
        
        self.loadRestaurantList(isRefresh: false)
    }
    
    @objc func updateFavouriteStatus(notification : Notification) {
        //...Update particular object when change favourite status
        
        let itemInfo = notification.object as? [String : AnyObject]
        
        if itemInfo != nil {
            
            var stop = false
            
            for (index, _) in arrRestData.enumerated() {
                let dict = arrRestData[index]
                
                if dict[CId] as? Int == itemInfo![CRestaurant_id] as? Int {
                    var updatedDict = dict
                    updatedDict[CFav_status] = itemInfo![CFav_status] as AnyObject
                    arrRestData[index] = updatedDict
                    stop = true
                }
            }
            
            if stop {
                tblRestList.reloadData()
            }
        }
    }
}

//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension SeeAllRestaurantViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRestData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((CScreenWidth  * 222)/375.0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRestaurantTableViewCell") as? SearchRestaurantTableViewCell {
      
            var dict = arrRestData[indexPath.row]
            
            cell.lblRestName.text = dict.valueForString(key: CName)
            cell.lblResLocation.text = dict.valueForString(key: CAddress)
            cell.lblRating.text = "\(dict.valueForDouble(key: CAvg_rating) ?? 0.0)"
            cell.vwRating.rating = (dict.valueForDouble(key: CAvg_rating))!
            
            cell.imgVRest.sd_setShowActivityIndicatorView(true)
            cell.imgVRest.sd_setImage(with: URL(string: (dict.valueForString(key: CImage))), placeholderImage: nil)
            
            let arrCuisine = dict.valueForJSON(key: CCuisine) as? [[String : AnyObject]]
            let arrCuisineName = arrCuisine?.compactMap({$0[CName]}) as? [String]
            cell.lblCuisines.text = arrCuisineName?.joined(separator: "-")
    
            var time = ""
            if dict.valueForString(key: COpen_time) != "" {
                time = (appDelegate?.UTCToLocalTime(openTime: (dict.valueForDouble(key: COpen_time))!))!
            }
            
            if dict.valueForInt(key: COpen_Close_Status) == 0 {
                cell.lblClosed.hide(byWidth: false)
                cell.lblTime.text = time != "" ? "Open at \(time)" : ""
            } else {
                cell.lblClosed.hide(byWidth: true)
                cell.lblTime.text = ""
            }
            
            
            if dict.valueForInt(key: CFav_status) == 0 {
                cell.btnLike.isSelected = false
            } else{
                cell.btnLike.isSelected = true
            }
            
            cell.btnLike.touchUpInside { (sender) in
             
                //...Open login Popup If user is not logged In OtherWise Like
                
                if appDelegate?.loginUser?.user_id == nil{
                    appDelegate?.openLoginPopup(viewController: self, fromOrder: false, completion: {
                    })
             
                } else{
                    
                    appDelegate?.updateFavouriteStatus(restaurant_id: (dict.valueForInt(key: CId))!, sender: cell.btnLike, completionBlock: { (response) in
                        
                        let data = response.value(forKey: CJsonData) as! [String : AnyObject]
                        
                        dict[CFav_status] = data.valueForInt(key: CIs_favourite) as AnyObject
                        self.arrRestData[indexPath.row] = dict
                        self.tblRestList.reloadRows(at: [indexPath], with: .none)
                        
                        let itemInfo = [CFav_status :data.valueForInt(key: CIs_favourite) as AnyObject,
                                        CRestaurant_id : dict[CId] as AnyObject,
                                        CType: self.strTitle] as [String : AnyObject]
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUpdateFavStatus), object: itemInfo)
                        
                    })
                }
            }
            
            if indexPath == tblRestList.lastIndexPath() {
                
                //...Load More
                if currentPage < lastPage {
                    
                    if apiTask?.state == URLSessionTask.State.running {
                         self.loadRestaurantList(isRefresh: false)
                    }
                }
            }
            
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = arrRestData[indexPath.row] 
        
        if let resDetailVC = CMain_SB.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as? RestaurantDetailViewController {
            resDetailVC.restaurantID = dict.valueForInt(key: CId)
            resDetailVC.strType = self.strTitle
            
            self.navigationController?.pushViewController(resDetailVC, animated: true)
        }
    }
}


//MARK:-
//MARK:- API method


extension SeeAllRestaurantViewController {
    
    @objc func pullToRefresh() {
        self.currentPage = 1
        refreshControl.beginRefreshing()
        self.loadRestaurantList(isRefresh: true)
    }
    
    func loadRestaurantList(isRefresh : Bool) {

        var type = 0
        if strTitle == CNearbyRestaurant {
            type = CNearBy
        } else if strTitle == CMostPopular {
            type = CPopular
        } else {
            type = CRecentlyAdded
        }
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if !isRefresh {
            activityLoader.startAnimating()
        }
        
        let dict = [CRestaurant_type : type,
                    CPage : currentPage] as [String : AnyObject]
        
        apiTask = APIRequest.shared().moreRestaurantList(param: dict, completion: { (response, error) in

            self.apiTask?.cancel()
            self.activityLoader.stopAnimating()
            self.refreshControl.endRefreshing()
            
            if response != nil && error == nil {
                
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                
                if self.currentPage == 1 {
                    self.arrRestData.removeAll()
                }
                
                if arrData.count > 0 {
                    for item in arrData {
                        self.arrRestData.append(item)
                    }
                }
                
                self.lastPage = metaData.valueForInt(key: CLastPage)!
                
                if metaData.valueForInt(key: CCurrentPage)! <= self.lastPage {
                    self.currentPage = metaData.valueForInt(key: CCurrentPage)! + 1
                }
                
                self.tblRestList.reloadData()
            }
        })
    }
}
