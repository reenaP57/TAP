//
//  FavoritesViewController.swift
//  TAP
//
//  Created by mac-00017 on 16/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class FavoritesViewController:  ParentViewController {
    
    @IBOutlet weak var tblFavorite : UITableView!{
        didSet {
            tblFavorite.register(UINib(nibName: "SearchRestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchRestaurantTableViewCell")
        }
    }
    @IBOutlet weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet weak var lblNoData : UILabel!

   
    var refreshControl = UIRefreshControl()
    var arrRestData = [[String : AnyObject]]()
    var apiTask : URLSessionTask?
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
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = CMyFavourite
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = CColorNavRed
        tblFavorite.pullToRefreshControl = refreshControl
        
        self.loadFavouriteRestaurant(isRefresh: false)
    }
    
}

//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension FavoritesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRestData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((CScreenWidth  * 222)/375.0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRestaurantTableViewCell") as? SearchRestaurantTableViewCell {
            
            let dict = arrRestData[indexPath.row]
            
            cell.lblRestName.text = dict.valueForString(key: CName)
            cell.lblResLocation.text = dict.valueForString(key: CAddress)
            cell.lblRating.text = "\(dict.valueForDouble(key: CAvg_rating) ?? 0.0)"
            cell.vwRating.rating = (dict.valueForDouble(key: CAvg_rating))!
            
            cell.imgVRest.sd_setShowActivityIndicatorView(true)
            cell.imgVRest.sd_setImage(with: URL(string: (dict.valueForString(key: CImage))), placeholderImage: nil)
            
            let arrCuisine = dict.valueForJSON(key: CCuisine) as? [[String : AnyObject]]
            let arrCuisineName = arrCuisine?.compactMap({$0[CName]}) as? [String]
            cell.lblCuisines.text = arrCuisineName?.joined(separator: "-")
            
            
            if dict.valueForInt(key: COpen_Close_Status) == 0 {
                cell.lblClosed.hide(byWidth: false)
                cell.lblTime.text = "Open at \(dict.valueForString(key: COpen_time) )"
            } else {
                cell.lblClosed.hide(byWidth: true)
            }
            
            
            if dict.valueForInt(key: CFav_status) == 0 {
                cell.btnLike.isSelected = false
            } else{
                cell.btnLike.isSelected = true
            }
            
            
            cell.btnLike.touchUpInside { (sender) in
                
                //...Open login Popup If user is not logged In OtherWise Like
                
                if appDelegate?.loginUser?.user_id == nil{
                    appDelegate?.openLoginPopup(viewController: self.viewController!)
                } else{
                    
                    appDelegate?.updateFavouriteStatus(restaurant_id: dict.valueForInt(key: CId)!, sender: cell.btnLike, completionBlock: { (response) in
                        
                        self.arrRestData.remove(at: indexPath.row)
                        
                        if self.arrRestData.count == 0 {
                           self.tblFavorite.reloadRows(at: [indexPath], with: .none)
                        } else {
                            self.tblFavorite.reloadData()
                        }
                        
                    })
                    
                }
            }
            
            if indexPath == tblFavorite.lastIndexPath() {
                
                //...Load More
                if currentPage < lastPage {
                    
                    if apiTask?.state == URLSessionTask.State.running {
                        self.loadFavouriteRestaurant(isRefresh: false)
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
            self.navigationController?.pushViewController(resDetailVC, animated: true)
        }
    }
}


//MARK:-
//MARK:- API method

extension FavoritesViewController {
    
    @objc func pullToRefresh() {
     
        currentPage = 1
        refreshControl.beginRefreshing()
        self.loadFavouriteRestaurant(isRefresh: true)
    }
    
    func loadFavouriteRestaurant(isRefresh : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if !isRefresh{
            tblFavorite.isHidden = true
            activityLoader.startAnimating()
        }
        
        apiTask = APIRequest.shared().favouriteRestaurantList(page : currentPage, completion: { (response, error) in
        
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
                
                self.tblFavorite.isHidden = self.arrRestData.count == 0
                self.lblNoData.isHidden = self.arrRestData.count != 0
                self.tblFavorite.reloadData()
            }
            
        })
    }
}

