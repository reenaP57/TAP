//
//  RatingViewController.swift
//  TAP
//
//  Created by mac-00017 on 13/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class RatingViewController: ParentViewController {

    @IBOutlet weak var tblRating : UITableView!
    @IBOutlet weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet weak var lblNoData : UILabel!

    var restaurantID : Int?
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var arrRating = [[String : AnyObject]]()
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
        self.title = CRatings
        
        tblRating.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = CColorNavRed
        tblRating.pullToRefreshControl = refreshControl
        
        self.loadRatingList(isRefresh: false)
    }
    
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension RatingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRating.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell") as? RatingTableViewCell {
            
            let dict = arrRating[indexPath.row]
            cell.lblUserName.text = dict.valueForString(key: CName)
            cell.lblRating.text = "\(dict.valueForDouble(key: CRating) ?? 0.0)"
            cell.lblReview.text = dict.valueForString(key: CRating_note)
            cell.vwRating.rating = (dict.valueForDouble(key: CRating)) ?? 0.0

            cell.imgVProfile.sd_setShowActivityIndicatorView(true)
            cell.imgVProfile.sd_setImage(with: URL(string: (dict.valueForString(key: CImage))), placeholderImage: nil)
            
            if indexPath == tblRating.lastIndexPath() {
                
                //...Load More
                if currentPage < lastPage {
                    
                    if apiTask?.state == URLSessionTask.State.running {
                        self.loadRatingList(isRefresh: false)
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

extension RatingViewController {
    
    @objc func pullToRefresh() {
        currentPage = 1
        refreshControl.beginRefreshing()
        self.loadRatingList(isRefresh: true)
    }
    
    func loadRatingList (isRefresh : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if !isRefresh {
            tblRating.isHidden = true
            activityLoader.startAnimating()
        }
        
        apiTask = APIRequest.shared().restaurantRatingList(restaurant_id: restaurantID!, page: currentPage, completion: { (response, error) in
        
            self.apiTask?.cancel()
            self.refreshControl.endRefreshing()
            self.activityLoader.stopAnimating()
            
            
            if response != nil && error == nil {
                
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                
                if self.currentPage == 1 {
                    self.arrRating.removeAll()
                }
                
                if arrData.count > 0 {
                    for item in arrData {
                        self.arrRating.append(item)
                    }
                }
                
                self.lastPage = metaData.valueForInt(key: CLastPage)!
                
                if metaData.valueForInt(key: CCurrentPage)! < self.lastPage {
                    self.currentPage = metaData.valueForInt(key: CCurrentPage)! + 1
                }
                
                self.tblRating.isHidden = self.arrRating.count == 0
                self.lblNoData.isHidden = self.arrRating.count != 0
                self.tblRating.reloadData()
            }
            
        })
        
    }
}
