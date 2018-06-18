//
//  SearchViewController.swift
//  TAP
//
//  Created by mac-00017 on 16/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SearchViewController: ParentViewController {
    
    @IBOutlet weak var tblSearch : UITableView!
    @IBOutlet weak var lblResultCount : UILabel!
    @IBOutlet weak var cnTblBottom : NSLayoutConstraint!
    var vwCustomSearch : CustomSearchView?

    var isFromOther : Bool = false
    
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
        isFromOther ? appDelegate?.hideTabBar() : appDelegate?.showTabBar()
        
    }
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.setCustomSearchBar()
    }
    
    func setCustomSearchBar() {
        
        if let customeView = CustomSearchView.viewFromXib as? CustomSearchView
        {
            customeView.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: 44)
            customeView.searchBar.placeholder = CSearchRestaurant
            
            if isFromOther {
                cnTblBottom.constant = 0
                customeView.btnBack.hide(byWidth: false)
                customeView.layoutWidthSearchbar.constant = CScreenWidth - (self.vwCustomSearch?.btnBack.CViewWidth ?? 45.0) - 20.0
                customeView.layoutLeadingSearchBar.constant = 0
                
            } else {
                customeView.btnBack.hide(byWidth: true)
                customeView.layoutSearchBarTrailing.constant = 0
                customeView.layoutWidthSearchbar.constant = CScreenWidth - 20
            }
 
            
            self.navigationItem.titleView = customeView
            
            customeView.btnBack.touchUpInside { (sender) in
                self.navigationController?.popViewController(animated: true)
            }
        }

    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
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
            
            cell.btnLike.touchUpInside { (sender) in
                
                //...Open login Popup If user is not logged In OtherWise Like
                
           //     appDelegate?.openLoginPopup(viewController: self.viewController!)
                
                if cell.btnLike.isSelected {
                    cell.btnLike.isSelected = false
                } else {
                    cell.btnLike.isSelected = true
                }
            }
            return cell
        }
        
        return UITableViewCell()
    }
}
