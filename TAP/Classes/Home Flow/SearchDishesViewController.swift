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
    @IBOutlet weak var lblNoData : UILabel!
    
    var arrDishList  = [[String : AnyObject]]()
    var arrFilterDish = [[String : AnyObject]]()
    var dictRestDetail = [String : AnyObject]()
    var restaurantID : Int?
    var isSearch = false
    
    
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
        restaurantID = self.dictRestDetail.valueForInt(key: CId)
    }
    
    func checkCartForThisRestaurant() -> Bool {
        
        //...Check cart added for this restaurant
        let arrData = TblCart.fetch(predicate: nil, orderBy: "dish_name", ascending: true)
        let arrResID = arrData?.value(forKeyPath: CRestaurant_id) as? [Int]
        
        if ((arrResID as AnyObject).count)! > 0 {
            
            if (arrResID?.contains(where: { $0 == self.restaurantID}))! {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    func updateQuantity(cell : DishDetailTableViewCell, indexPath : IndexPath, isPlus : Bool) {
        
        let isClearCart =  self.checkCartForThisRestaurant()
        
        if isClearCart {
            
            let dict = isSearch ? arrFilterDish[indexPath.row] : arrDishList[indexPath.row]
            
            //...Cart will be add If Cart from same restaurant
            
            let currentCount = Int(cell.txtQuantity.text!)
            
            var updatedDict = dict
            updatedDict[CQuantity] = cell.txtQuantity.text as AnyObject
            
            if cell.txtQuantity.text == "0" {
                TblCart.deleteObjects(predicate: NSPredicate(format: "%K == %@", CDish_id, "\(dict.valueForInt(key: CDish_id)!)"))
                
            } else {
                appDelegate?.saveRestaurantDetail(dictRest: dictRestDetail)
                appDelegate?.saveCart(dict: updatedDict, rest_id: restaurantID!)
            }
            
            
            if isSearch {
                arrFilterDish[indexPath.row] = updatedDict
            } else {
                arrDishList[indexPath.row] = updatedDict
            }
            
            appDelegate?.setCartCountOnTab()
            
            tblSearch.reloadRows(at: [indexPath], with: .none)
            self.view.layoutIfNeeded()
            
            
//            if !isPlus {
//
//                let arrCart = TblCart.fetch(predicate: NSPredicate(format: "%K == %@", CDish_id, "\(dict.valueForInt(key: CDish_id)!)"), orderBy: nil, ascending: false)
//
//                if currentCount == 0  && (arrCart?.count)! > 0 {
//                    TblCart.deleteObjects(predicate: NSPredicate(format: "%K == %@", CDish_id, "\(dict.valueForInt(key: CDish_id)!)"))
//                } else {
//                    appDelegate?.saveCart(dict: updatedDict, rest_id: restaurantID!)
//                }
//            }
            
            let dic =  [CQuantity : cell.txtQuantity.text as Any,
                        CDish_id : dict.valueForInt(key: CDish_id) as Any]
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationUpdateRestaurantDetail), object: dic)
            
        } else {
            
            //... If cart from other restaurant than show popup with clear cart option
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageAlreadyCardAdded, btnOneTitle: CClearCartAndAdd, btnOneTapped: { (action) in
                TblCart.deleteAllObjects()
                TblCartRestaurant.deleteAllObjects()
                appDelegate?.setCartCountOnTab()
                
            }, btnTwoTitle: CCLOSE, btnTwoTapped: { (actio) in
            })
        }
        
    }
}


//MARK:-
//MARK:- UISearchBar delegate

extension SearchDishesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchText.count == 0 {
            isSearch = false
            lblNoData.isHidden = true
        } else {
            isSearch = true
            
            arrFilterDish = self.arrDishList.filter {
                ($0.valueForString(key: CDish_name)).range(of: searchText , options: [.caseInsensitive]) != nil
            }
            
            lblNoData.isHidden = arrFilterDish.count != 0
        }
        
        tblSearch.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        self.navigationController?.popViewController(animated: false)
    }
    
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension SearchDishesViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch ? arrFilterDish.count : arrDishList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailTableViewCell") as? DishDetailTableViewCell {
      
            let dict = isSearch ? arrFilterDish[indexPath.row] : arrDishList[indexPath.row]
            
            //...Check cart is added for particular dish and category
            let arrCart = TblCart.fetch(predicate: NSPredicate(format: "%K == %@", CDish_id, "\(dict.valueForInt(key: CDish_id)!)"), orderBy: nil, ascending: false)
            
            
            if (arrCart?.count)! > 0 {
                cell.txtQuantity.text = "\((arrCart![0] as! TblCart).quantity)"
            } 
            
            
            cell.lblDishName.text = dict.valueForString(key: CDish_name)
            cell.lblCuisine.text = dict.valueForString(key: CDish_ingredients)
            cell.lblPrice.text = "$\(String(format: "%.2f", dict.valueForDouble(key: CDish_price)!))"
            
            cell.imgVDish.sd_setShowActivityIndicatorView(true)
            cell.imgVDish.sd_setImage(with: URL(string: (dict.valueForString(key: CDish_image))), placeholderImage: nil)
            
            cell.txtQuantity.addTarget(self, action: #selector(txtQuantityDidEndChange), for: .editingDidEnd)
            
            
            if dict.valueForInt(key: CIs_available) == 0 {
                //...UnAvailable
                
                cell.vwQuantity.isHidden = true
                cell.vwAvailable.isHidden = false
          
            } else {
                //...Available
                
                cell.vwQuantity.isHidden = false
                cell.vwAvailable.isHidden = true
            }
            
            
            cell.btnPlus.touchUpInside { (sender) in
                
                let currentCount = (cell.txtQuantity.text?.toInt)! + 1
                
                if currentCount.toString.count <= 3 {
                    
                    let isClearCart =  self.checkCartForThisRestaurant()
                    
                    if isClearCart {
                        cell.txtQuantity.text = "\(currentCount)"
                    }
                    
                    self.updateQuantity(cell: cell, indexPath: indexPath, isPlus: true)
                }
            }
            
            cell.btnMinus.touchUpInside { (sender) in
                
                let isClearCart =  self.checkCartForThisRestaurant()
                if isClearCart {
                    
                    let currentCount = (cell.txtQuantity.text?.toInt)! - 1 > 0 ? (cell.txtQuantity.text?.toInt)! - 1 : 0
                    cell.txtQuantity.text = "\(currentCount)"
                }
                
                self.updateQuantity(cell: cell, indexPath: indexPath, isPlus: false)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
 
    
    @objc func txtQuantityDidEndChange(_ textField : UITextField) {
        
        let isClearCart =  self.checkCartForThisRestaurant()
        
        if isClearCart {
            
            let point = textField.convert(CGPoint.zero, to: tblSearch)
            
            if let indexpath = tblSearch.indexPathForRow(at: point)
            {
                if let cell = tblSearch.dequeueReusableCell(withIdentifier: "DishDetailTableViewCell", for: indexpath) as? DishDetailTableViewCell {
                    
                    if textField.text == "" {
                        cell.txtQuantity.text = "0"
                    } else {
                        cell.txtQuantity.text = textField.text
                    }
                    
                    self.updateQuantity(cell: cell, indexPath: indexpath, isPlus: true)
                }
            }
        }
    }
}
