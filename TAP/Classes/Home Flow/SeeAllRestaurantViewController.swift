//
//  SeeAllRestaurantViewController.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SeeAllRestaurantViewController: ParentViewController {
    
    @IBOutlet weak var tblRestList : UITableView!
    var strTitle = String()
    
    var arrRestData = [["res_name":"Cafe de perks", "res_location":"Alpha One Mall", "Cuisine":"Rolls - Desserts - Fast Food", "rating":"4.0", "time":"", "like_status":0],
                       ["res_name":"Dominoz", "res_location":"Alpha One Mall", "Cuisine":"Rolls - Desserts - Fast Food", "rating":"4.0", "time":"Opens at 7 PM", "like_status":1],
                       ["res_name":"Barbeque Nation", "res_location":"Alpha One Mall", "Cuisine":"Rolls - Desserts - Fast Food", "rating":"4.0", "time":"Opens at 7 PM", "like_status":1]]
    
    
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
    }

}

//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension SeeAllRestaurantViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRestData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((CScreenWidth  * 216)/375.0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRestaurantTableViewCell") as? SearchRestaurantTableViewCell {
      
            let dict = arrRestData[indexPath.row]
            
            cell.lblRestName.text = dict.valueForString(key: "res_name")
            cell.lblResLocation.text = dict.valueForString(key: "res_location")
            cell.lblCuisines.text = dict.valueForString(key: "Cuisine")
            cell.lblRating.text = dict.valueForString(key: "rating")
            cell.lblTime.text = dict.valueForString(key: "time")

            if dict.valueForInt(key: "like_status") == 0 {
                cell.btnLike.isSelected = false
            } else{
                 cell.btnLike.isSelected = true
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}
