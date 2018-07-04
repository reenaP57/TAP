//
//  HomeViewController.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class HomeViewController: ParentViewController {

    @IBOutlet weak var tblHome : UITableView!
    @IBOutlet weak var lblLocation : UILabel!
    @IBOutlet weak var activityLoader : UIActivityIndicatorView!

    var arrNearByData = [[String : AnyObject]]()
    var arrPopularData = [[String : AnyObject]]()
    var arrArrivalData = [[String : AnyObject]]()
    var arrSection = [String]()
    
    var arrival_count = 0
    var nearby_count = 0
    var popular_count = 0
    
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavouriteStatus), name: NSNotification.Name(rawValue: kNotificationUpdateFavStatus), object: nil)
        
        self.loadRestaurantList()
    }
    
    @objc func updateFavouriteStatus(notification : Notification) {
        
        let itemInfo = notification.object as? [String : AnyObject]
        
        if itemInfo != nil {
            
            var stop = false
            
            if itemInfo![CType] as? String == CNearbyRestaurant {
                
                for (index, _) in arrNearByData.enumerated() {
                    let dict = arrNearByData[index]
                    
                    if dict[CId] as? Int == itemInfo![CRestaurant_id] as? Int {
                        var updatedDict = dict
                        updatedDict[CFav_status] = itemInfo![CFav_status] as AnyObject
                        arrNearByData[index] = updatedDict
                        stop = true
                    }
                }
                
            } else if itemInfo![CType] as? String == CMostPopular {
                
                for (index, _) in arrPopularData.enumerated() {
                    let dict = arrPopularData[index]
                    
                    if dict[CId] as? Int == itemInfo![CRestaurant_id] as? Int {
                        var updatedDict = dict
                        updatedDict[CFav_status] = itemInfo![CFav_status] as AnyObject
                        arrPopularData[index] = updatedDict
                        stop = true
                    }
                
                }
                
            } else {
             
                for (index, _) in arrArrivalData.enumerated() {
                    let dict = arrArrivalData[index]
                    
                    if dict[CId] as? Int == itemInfo![CRestaurant_id] as? Int {
                        var updatedDict = dict
                        updatedDict[CFav_status] = itemInfo![CFav_status] as AnyObject
                        arrArrivalData[index] = updatedDict
                        stop = true
                    }
                }
            }
            
            if stop {
                tblHome.reloadData()
            }
        }
        
    }
    
}


//MARK:-
//MARK:- Action

extension HomeViewController {
    
    @IBAction func btnLocationClicked(sender : UIButton) {
        if let selectLocVC = CLRF_SB.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController {
            selectLocVC.type = .FromHome
            self.navigationController?.pushViewController(selectLocVC, animated: true)
        }
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
   
    public func numberOfSections(in tableView: UITableView) -> Int  {
        return arrSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((CScreenWidth  * 291)/375.0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell") as? RestaurantTableViewCell {
            
            if arrSection[indexPath.section] == CNearbyRestaurant {
                cell.lblTitle.text = CNearbyRestaurant
                cell.loadRestaurantDetail(arrDetail: arrNearByData, type : CNearbyRestaurant)
               // cell.btnSeeAll.isHidden = self.nearby_count < 5
                
            } else if arrSection[indexPath.section] == CMostPopular {
                cell.lblTitle.text = CMostPopular
                cell.loadRestaurantDetail(arrDetail: arrPopularData, type : CMostPopular)
                //cell.btnSeeAll.isHidden = self.popular_count < 5
                
            } else {
                cell.lblTitle.text = CNewArrival
                cell.loadRestaurantDetail(arrDetail: arrArrivalData, type : CNewArrival)
               // cell.btnSeeAll.isHidden = self.arrival_count < 5
            }
            
            
            
            cell.btnSeeAll.touchUpInside { (sender) in
            
                if let seeAllVC = CMain_SB.instantiateViewController(withIdentifier: "SeeAllRestaurantViewController") as? SeeAllRestaurantViewController {
                    
                    seeAllVC.strTitle = cell.lblTitle.text!
                    self.navigationController?.pushViewController(seeAllVC, animated: true)
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }

}

//MARK:-
//MARK:- API Method

extension HomeViewController {
    
    func loadRestaurantList() {
        
        activityLoader.startAnimating()
        
        APIRequest.shared().restaurantList { (response, error) in
        
            if response != nil && error == nil {
                self.activityLoader.stopAnimating()
                
                let data = response?.value(forKey: CJsonData) as? [String : AnyObject]
                let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject]
                
                let arrNear = data?.valueForJSON(key: "nearby") as! [[String : AnyObject]]
                let arrPopular = data?.valueForJSON(key: "popular") as! [[String : AnyObject]]
                let arrArrival = data?.valueForJSON(key: "arrival") as! [[String : AnyObject]]

                self.arrival_count = (metaData?.valueForInt(key: "arrival_count"))!
                self.nearby_count = (metaData?.valueForInt(key: "nearby_count"))!
                self.popular_count = (metaData?.valueForInt(key: "popular_count"))!
                self.arrSection.removeAll()
                
                if (arrNear.count) > 0 {
                    self.arrNearByData.removeAll()
                    self.arrNearByData = arrNear
                    self.arrSection.append(CNearbyRestaurant)
                }
                
                if (arrPopular.count) > 0 {
                    self.arrPopularData.removeAll()
                    self.arrPopularData = arrPopular
                    self.arrSection.append(CMostPopular)
                }
                
                if arrArrival.count > 0 {
                    self.arrArrivalData.removeAll()
                    self.arrArrivalData = arrArrival
                    self.arrSection.append(CNewArrival)
                }
                
                self.tblHome.isHidden = false
                self.tblHome.reloadData()
            }
        }
        
    }
}
