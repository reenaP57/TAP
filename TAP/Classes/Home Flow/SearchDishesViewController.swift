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
        
        restaurantID = self.dictRestDetail.valueForInt(key: CRestaurant_id)
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
    
    
    //MARK:- Manage Cart and restuarnt in local
    
    func saveCart(dict : [String : AnyObject]) {
        
        let tblCart = TblCart.findOrCreate(dictionary: ["dish_id": Int64(dict.valueForInt(key: "dish_id")!)]) as! TblCart
        
        tblCart.restaurant_id = Int64(restaurantID!)
        tblCart.dish_category_ids = Int64(dict.valueForInt(key: CDish_category_id)!)
        tblCart.dish_name = dict.valueForString(key: CDish_name)
        tblCart.dish_image = dict.valueForString(key: CDish_image)
        tblCart.dish_price = dict.valueForDouble(key: CDish_price)!
        tblCart.quantity = Int16(dict.valueForInt(key: CQuantity)!)
        tblCart.dish_ingredients = dict.valueForString(key: CDish_ingredients)
        tblCart.is_available = dict.valueForBool(key: CIs_available)
        tblCart.popular_index = Int16(dict.valueForInt(key: CPopular_index)!)

        tblCart.status_id = Int16(CActive)
        
        CoreData.saveContext()
    }
    
    func saveRestaurantDetail() {
        
        let arr = TblCartRestaurant.fetchAllObjects()
        
        if arr?.count == 0 {
            
            let tblCartRest = TblCartRestaurant.findOrCreate(dictionary: ["restaurant_id" : dictRestDetail.valueForInt(key: CId)!]) as! TblCartRestaurant
            
            tblCartRest.restaurant_name = dictRestDetail.valueForString(key: CName)
            tblCartRest.restaurant_img = dictRestDetail.valueForString(key: CImage)
            tblCartRest.address = dictRestDetail.valueForString(key: CAddress)
            tblCartRest.latitude = dictRestDetail.valueForDouble(key: CLatitude)!
            tblCartRest.longitude = dictRestDetail.valueForDouble(key: CLongitude)!
            tblCartRest.contact_no = dictRestDetail.valueForString(key: CContact_no)
            tblCartRest.tax = dictRestDetail.valueForDouble(key: CTax_percent)!
            tblCartRest.additional_tax = dictRestDetail.valueForJSON(key: CAdditional_tax) as? NSObject
            
            CoreData.saveContext()
        }
        
    }
}


//MARK:-
//MARK:- UISearchBar delegate

extension SearchDishesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchText.count == 0 {
            isSearch = false
        } else {
            isSearch = true
            
            arrFilterDish = self.arrDishList.filter {
                ($0.valueForString(key: CDish_name)).range(of: searchText , options: [.caseInsensitive]) != nil
            }
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
            let arrCart = TblCart.fetch(predicate: NSPredicate(format: "%K == %@", "dish_id", "\(dict.valueForInt(key: "dish_id")!)"), orderBy: nil, ascending: false)
            
            
            if (arrCart?.count)! > 0 {
                cell.txtQuantity.text = "\((arrCart![0] as! TblCart).quantity)"
            } 
            
            
            cell.lblDishName.text = dict.valueForString(key: CDish_name)
            cell.lblCuisine.text = dict.valueForString(key: CDish_ingredients)
            cell.lblPrice.text = "$\(String(format: "%.2f", dict.valueForDouble(key: CDish_price)!))"
            
            cell.imgVDish.sd_setShowActivityIndicatorView(true)
            cell.imgVDish.sd_setImage(with: URL(string: (dict.valueForString(key: CDish_image))), placeholderImage: nil)
            
//            cell.txtQuantity.addTarget(self, action: #selector(txtQuantityDidBeginChange), for: .editingDidBegin)
//            cell.txtQuantity.addTarget(self, action: #selector(txtQuantityDidEndChange), for: .editingDidEnd)
            
            
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
                
                let isClearCart =  self.checkCartForThisRestaurant()
                
                if isClearCart {
                    
                    //...Cart will be add If Cart from same restaurant
                    
                    let currentCount = (cell.txtQuantity.text?.toInt)! + 1
                    cell.txtQuantity.text = "\(currentCount)"
                    
                    var updatedDict = dict
                    updatedDict[CQuantity] = cell.txtQuantity.text as AnyObject
                    arrDishList[indexPath.row] = updatedDict
                    tblSearch.reloadRows(at: [indexPath], with: .none)
                    
                    self.saveRestaurantDetail()
                    self.saveCart(dict: updatedDict)
                    
                } else {
                    
                    //... If cart from other restaurant than show popup with clear cart option
                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageAlreadyCardAdded, btnOneTitle: CClearCartAndAdd, btnOneTapped: { (action) in
                        TblCart.deleteAllObjects()
                        TblCartRestaurant.deleteAllObjects()
                        
                    }, btnTwoTitle: CClose, btnTwoTapped: { (actio) in
                    })
                }
            }
            
            cell.btnMinus.touchUpInside { (sender) in
                
                let isClearCart = self.checkCartForThisRestaurant()
                
                if isClearCart {
                    
                    //...Cart will be add If Cart from same restaurant
                    
                    let currentCount = (cell.txtQuantity.text?.toInt)! - 1 > 0 ? (cell.txtQuantity.text?.toInt)! - 1 : 0
                    cell.txtQuantity.text = "\(currentCount)"
                    
                    var updatedDict = dict
                    updatedDict[CQuantity] = cell.txtQuantity.text as AnyObject
                    arrDishList[indexPath.row] = updatedDict
                    tblSearch.reloadRows(at: [indexPath], with: .none)
                    
                    let arrCart = TblCart.fetch(predicate: NSPredicate(format: "%K == %@", "dish_id", "\(dict.valueForInt(key: "dish_id")!)"), orderBy: nil, ascending: false)
                    
                    if currentCount == 0  && (arrCart?.count)! > 0 {
                        
                        TblCart.deleteObjects(predicate: NSPredicate(format: "%K == %@", "dish_id", "\(dict.valueForInt(key: "dish_id")!)"))
                        
                    } else {
                        self.saveCart(dict: updatedDict)
                    }
                    
                } else {
                    
                    //... If cart from other restaurant than show popup with clear cart option
                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageAlreadyCardAdded, btnOneTitle: CClearCartAndAdd, btnOneTapped: { (action) in
                        TblCart.deleteAllObjects()
                        TblCartRestaurant.deleteAllObjects()
                        
                    }, btnTwoTitle: CClose, btnTwoTapped: { (actio) in
                    })
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
 
}
