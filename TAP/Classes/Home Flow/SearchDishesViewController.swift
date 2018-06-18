//
//  SearchDishesViewController.swift
//  TAP
//
//  Created by mac-00017 on 18/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SearchDishesViewController: ParentViewController {

    @IBOutlet weak var searchBar : UISearchBar!{
        
        didSet{
            
            searchBar.delegate = self
            
            searchBar.setImage(UIImage(named:"search_unselected"), for: .search, state: .normal)
            searchBar.tintColor = CColorLightGray
            searchBar.backgroundImage = UIImage()
            
            //...Get TextField From SearchBar
            //...Set Font and TextColor
            let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
            
            searchTextField?.font = (IS_iPhone_X) ? CFontSFUIText(size: 15, type: .Regular) : (IS_iPhone_6 || IS_iPhone_6_Plus) ? CFontSFUIText(size: 15, type: .Regular) :  CFontSFUIText(size: 14, type: .Regular)
            searchTextField?.textColor = CColorLightGray
            searchBar.layer.cornerRadius = 5.0
            searchBar.layer.masksToBounds = true
            
            //...Change Placeholder TextColor
            
            searchTextField?.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("Search", comment:""), attributes:[NSAttributedStringKey.foregroundColor: CRGB(r: 204, g: 204, b: 204)])
            
            searchTextField?.setValue(CRGB(r: 204, g: 204, b: 204), forKeyPath: "_placeholderLabel.textColor")
            
            //...Change BackGround Color and Corner Radius Of SearchFieldBackGroundView
            if let searchFieldBackground = searchTextField?.subviews.first{
                
                searchFieldBackground.backgroundColor = UIColor.white
                searchFieldBackground.layer.cornerRadius = 4
                searchFieldBackground.clipsToBounds = true
            }
        }
    }
   
    @IBOutlet weak var tblSearch : UITableView!

    var arrDishList  = [["dishname":"Maxican Crepe","desc":"Maxican style tomato salsa, spicy chill sauce cheese cream...","price":4],
                        ["dishname":"Cesar salad wrap","desc":"Maxican style tomato salsa, spicy chill sauce cheese creame tomato salsa, spicy chill sauce cheese crea","price":10],
                        ["dishname":"Country road chicken","desc":"Maxican style tomato salsa, spicy chill sauce cheese cream...","price":7],
                        ["dishname":"Maxican Crepe","desc":"Maxican style tomato salsa, spicy chill sauce cheese cream...","price":14]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialze()
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
    func initialze() {
    }
    
}


//MARK:-
//MARK:- UISearchBar delegate

extension SearchDishesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: false)
    }
    
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension SearchDishesViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDishList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailTableViewCell") as? DishDetailTableViewCell {
            
            let dict = arrDishList[indexPath.row]
            
            cell.lblDishName.text = dict.valueForString(key: "dishname")
            cell.lblCuisine.text = dict.valueForString(key: "desc")
            cell.lblPrice.text = "$\(dict.valueForString(key: "price"))"
            
            cell.btnPlus.touchUpInside { (sender) in
                
                let currentCount = (cell.txtQuantity.text?.toInt)! + 1
                cell.txtQuantity.text = "\(currentCount)"
            }
            
            cell.btnMinus.touchUpInside { (sender) in
                
                let currentCount = (cell.txtQuantity.text?.toInt)! - 1 > 0 ? (cell.txtQuantity.text?.toInt)! - 1 : 0
                cell.txtQuantity.text = "\(currentCount)"
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
 
}
