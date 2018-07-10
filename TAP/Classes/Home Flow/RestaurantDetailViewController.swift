//
//  RestaurantDetailViewController.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: ParentViewController, selectCategoryProtocol {


    @IBOutlet weak var tblRestDetail : UITableView!
    @IBOutlet weak var activityLoader  : UIActivityIndicatorView!

    
    var headerView : RestaurantDetailHeaderView!
    var headerTableTop : ParallaxHeaderView!
    var restaurantTopView : RestaurantDetailTopView!
    var footerView : RestaurantDetailFooterView!

  
    var arrDishList  = [[String : AnyObject]]()
    var arrCategory  = [[String : Any]]()
    var arrSelectedDishList  = [[String : AnyObject]]()
    var dictRest = [String : AnyObject]()
    
    var strType = ""

    var isUpdated : Bool = false
    var restaurantID : Int?
    var categoryID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isUpdated = false
        appDelegate?.hideTabBar()
        self.setCusotmNavigationBar()
    }
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
        
        if headerView == nil {
            headerView = RestaurantDetailHeaderView.viewFromXib as? RestaurantDetailHeaderView
            headerView.delegate = self
        }
        
        if footerView == nil {
            footerView = RestaurantDetailFooterView.viewFromXib as? RestaurantDetailFooterView
        }
        
        if restaurantTopView == nil {
            restaurantTopView = (Bundle.main.loadNibNamed("RestaurantDetailTopView", owner: self, options: nil)?[0] as? RestaurantDetailTopView)!
        }
        
        restaurantTopView.txtSearch.delegate = self
        restaurantTopView.frame.size.width = CScreenWidth
        headerTableTop = ParallaxHeaderView.parallaxHeaderView(withSubView: restaurantTopView)
        self.tblRestDetail.tableHeaderView = headerTableTop
        
        self.setRestaurantDetail()
    }

    func setCusotmNavigationBar()
    {
        self.navigationController?.navigationBar.backgroundColor = CColorWhite
        
        let colorImage = UIImage.imageFromColor(color: CColorNavRed)
        
        self.navigationController?.navigationBar.shadowImage = colorImage
        self.navigationController?.navigationBar.setBackgroundImage(colorImage, for: .default)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setRestaurantDetail() {
        
        tblRestDetail.isHidden = true
        activityLoader.startAnimating()
        
        APIRequest.shared().restaurantDetail(restaurant_id: restaurantID!) { (response, error) in
            
            self.activityLoader.stopAnimating()
            self.tblRestDetail.isHidden = false
            
            if response != nil && error == nil {
                
                self.dictRest = response?.value(forKey: CJsonData) as! [String : AnyObject]
                
                self.arrDishList = self.dictRest.valueForJSON(key: "dishes") as! [[String : AnyObject]]
               
                self.arrCategory = self.dictRest.valueForJSON(key: "dish_categories") as! [[String : AnyObject]]
                
                if self.arrCategory.count > 0 {
                    self.categoryID = 0
                    self.filterMostPopularDish()
                   // self.filterCategoryWithID(categoryID: self.arrCategory[0].valueForString(key: CDish_category_id))
                }
               
                
                self.title = self.dictRest.valueForString(key: CName)
                self.restaurantTopView.lblRestName.text = self.dictRest.valueForString(key: CName)
                self.restaurantTopView.lblResLocation.text = self.dictRest.valueForString(key: CAddress)
                
                self.restaurantTopView.imgVRest.sd_setShowActivityIndicatorView(true)
                self.restaurantTopView.imgVRest.sd_setImage(with: URL(string: (self.dictRest.valueForString(key: CImage))), placeholderImage: nil)
                
                let arrCuisine = self.dictRest.valueForJSON(key: CCuisine) as? [[String : AnyObject]]
                let arrCuisineName = arrCuisine?.compactMap({$0[CName]}) as? [String]
                self.restaurantTopView.lblCuisines.text = arrCuisineName?.joined(separator: "-")
                
                self.restaurantTopView.lblRating.text = "\(self.dictRest.valueForDouble(key: CAvg_rating) ?? 0.0)"
                self.restaurantTopView.lblRatingCount.text = "(\(self.dictRest.valueForString(key: CNo_person_rated)))"
                
                self.restaurantTopView.btnContactNo.setTitle((self.dictRest.valueForString(key: CContact_no)), for: .normal)
            
                self.restaurantTopView.vwRating.rating = self.dictRest.valueForDouble(key: CAvg_rating)!
                
                if self.dictRest.valueForInt(key: CFav_status) == 0 {
                    self.restaurantTopView.btnLike.isSelected = false
                } else {
                    self.restaurantTopView.btnLike.isSelected = true
                }
                
                self.tblRestDetail.reloadData()
            }
            
        }
        
        
        //MARK:- Restaurant Top View Action
        
        restaurantTopView.btnBack.touchUpInside { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
        restaurantTopView.btnLike.touchUpInside { (sender) in
            
            //...Open login Popup If user is not logged In OtherWise Like
            
            if appDelegate?.loginUser?.user_id == nil{
                appDelegate?.openLoginPopup(viewController: self)
            } else{
                
                appDelegate?.updateFavouriteStatus(restaurant_id: restaurantID!, sender: restaurantTopView.btnLike, completionBlock: { (response) in
                    
                    let data = response.value(forKey: CJsonData) as! [String : AnyObject]
                    
                    let itemInfo = [CFav_status :data.valueForInt(key: CIs_favourite) as AnyObject,
                                    CRestaurant_id : self.restaurantID as AnyObject,
                                    CType: self.strType] as [String : AnyObject]
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUpdateFavStatus), object: itemInfo)
                })
            }
        }
        
        restaurantTopView.btnPromotion.touchUpInside { (sender) in
            
            isUpdated = true
            if let promotionVC = CMain_SB.instantiateViewController(withIdentifier: "PromotionViewController") as? PromotionViewController {
                promotionVC.restaurantID = self.restaurantID
                self.navigationController?.pushViewController(promotionVC, animated: true)
            }
        }
        
        restaurantTopView.btnViewRating.touchUpInside { (sender) in
            
            isUpdated = true
            
            if let ratingVC = CMain_SB.instantiateViewController(withIdentifier: "RatingViewController") as? RatingViewController {
                ratingVC.restaurantID = self.restaurantID
                self.navigationController?.pushViewController(ratingVC, animated: true)
            }
        }
        
        restaurantTopView.btnContactNo.touchUpInside { (sender) in
        
            if self.dictRest.valueForString(key: CContact_no) != "" {
                self.dialPhoneNumber(phoneNumber: self.dictRest.valueForString(key: CContact_no))
            }
        }
    }
    
    func filterCategoryWithID(categoryID : String) {
       
        arrSelectedDishList.removeAll()
        arrSelectedDishList = arrDishList.filter {( $0["dish_category_ids"]!.contains(categoryID) )}
        tblRestDetail.reloadData()
        
    }
    
    func filterMostPopularDish() {
       
        arrSelectedDishList.removeAll()
        arrSelectedDishList = arrDishList.filter {( $0["popular_index"] as! Int != 0)}
        tblRestDetail.reloadData()
    }
    
    
    @objc func btnSearchClicked() {
        
        self.tblRestDetail.setContentOffset(CGPoint.zero, animated: false)
        
        if let searchVC = CMain_SB.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            searchVC.isFromOther = true
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
 
    //MARK:- Manage Cart and restuarnt in local
    
    func saveCart(dict : [String : AnyObject]) {
        
        let tblCart = TblCart.findOrCreate(dictionary: ["dish_id": Int64(dict.valueForInt(key: "dish_id")!)]) as! TblCart

        tblCart.restaurant_id = Int64(restaurantID!)
        tblCart.dish_category_ids = Int64(categoryID!)
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
            
            let tblCartRest = TblCartRestaurant.findOrCreate(dictionary: ["restaurant_id" : dictRest.valueForInt(key: CId)!]) as! TblCartRestaurant
            
            tblCartRest.restaurant_name = dictRest.valueForString(key: CName)
            tblCartRest.restaurant_img = dictRest.valueForString(key: CImage)
            tblCartRest.address = dictRest.valueForString(key: CAddress)
            tblCartRest.latitude = dictRest.valueForDouble(key: CLatitude)!
            tblCartRest.longitude = dictRest.valueForDouble(key: CLongitude)!
            tblCartRest.contact_no = dictRest.valueForString(key: CContact_no)
            tblCartRest.tax = dictRest.valueForDouble(key: CTax_percent)!
            tblCartRest.additional_tax = dictRest.valueForJSON(key: CAdditional_tax) as? NSObject
            
            CoreData.saveContext()
        }
        
    }
    
    func checkCartIsAvailable() -> Bool {
        
        let arrCart = TblCart.fetch(predicate: NSPredicate(format: "%K == %@",CRestaurant_id, "\(self.restaurantID ?? 0)"), orderBy: nil, ascending: false)
        
        return (arrCart?.count)! > 0 ? true : false
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
    
    
    //MARK:- Category Header View delegate
    
    func selectCategory(categoryID: String) {
        
        if categoryID == "" {
            self.categoryID = 0
            self.filterMostPopularDish()
        } else {
            self.categoryID = Int(categoryID)
            self.filterCategoryWithID(categoryID: categoryID)
        }
    }

}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension RestaurantDetailViewController :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedDishList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.loadCategoryList(arrCategory: arrCategory, categoryId : categoryID == 0 ? "" : "\(categoryID ?? 0)")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.CViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.checkCartIsAvailable() ? 94 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        footerView.btnViewCart.touchUpInside { (sender) in
            
            appDelegate?.tabbar?.btnTabClicked(sender: (appDelegate?.tabbar?.btnCart)!)
        }
        
        return self.checkCartIsAvailable() ? footerView : nil
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
            
            //...Check cart is added for particular dish and category
//            let arrCart = TblCart.fetch(predicate: NSPredicate(format: "%K == %@ && %K == %@", "dish_id", "\(dict.valueForInt(key: "dish_id")!)","dish_category_id","\(self.categoryID ?? 0)"), orderBy: nil, ascending: false)
            let arrCart = TblCart.fetch(predicate: NSPredicate(format: "%K == %@", "dish_id", "\(dict.valueForInt(key: "dish_id")!)"), orderBy: nil, ascending: false)

           
            if (arrCart?.count)! > 0 {
                cell.txtQuantity.text = "\((arrCart![0] as! TblCart).quantity)"
            } else {
                cell.txtQuantity.text = "0" //dict.valueForString(key: CQuantity)
            }
            
           
            cell.lblDishName.text = dict.valueForString(key: CDish_name)
            cell.lblCuisine.text = dict.valueForString(key: CDish_ingredients)
            cell.lblPrice.text = "$\(String(format: "%.2f", dict.valueForDouble(key: CDish_price)!))"
            
            cell.imgVDish.sd_setShowActivityIndicatorView(true)
            cell.imgVDish.sd_setImage(with: URL(string: (dict.valueForString(key: CDish_image))), placeholderImage: nil)
            
            cell.txtQuantity.addTarget(self, action: #selector(txtQuantityDidBeginChange), for: .editingDidBegin)
            cell.txtQuantity.addTarget(self, action: #selector(txtQuantityDidEndChange), for: .editingDidEnd)
            
            
            if dict.valueForInt(key: CIs_available) == 0 {
                //...UnAvailable
                cell.vwAvailable.isHidden = false
                cell.vwQuantity.isHidden = true
                
            } else {
                //...Available
                cell.vwAvailable.isHidden = true
                cell.vwQuantity.isHidden = false
            }
            
            
            cell.btnPlus.touchUpInside { (sender) in
                
             let isClearCart =  self.checkCartForThisRestaurant()
                
                if isClearCart {
                    
                    //...Cart will be add If Cart from same restaurant
                    
                    let currentCount = (cell.txtQuantity.text?.toInt)! + 1
                    cell.txtQuantity.text = "\(currentCount)"
                    
                    var updatedDict = dict
                    updatedDict[CQuantity] = cell.txtQuantity.text as AnyObject
                    arrSelectedDishList[indexPath.row] = updatedDict
                    tblRestDetail.reloadRows(at: [indexPath], with: .none)
                    
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
                    arrSelectedDishList[indexPath.row] = updatedDict
                    tblRestDetail.reloadRows(at: [indexPath], with: .none)
                    
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
    
    @objc func txtQuantityDidBeginChange() {
        isUpdated = true
    }
    
    @objc func txtQuantityDidEndChange() {
        isUpdated = false
    }
    
}

//MARK:-
//MARK:- TextField Delegate

extension RestaurantDetailViewController : UITextFieldDelegate {
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        restaurantTopView.txtSearch.resignFirstResponder()
        
        if let searchVC = CMain_SB.instantiateViewController(withIdentifier: "SearchDishesViewController") as? SearchDishesViewController {
            searchVC.arrDishList = arrDishList
            searchVC.dictRestDetail = self.dictRest
            self.navigationController?.pushViewController(searchVC, animated: false)
        }
    }
}



// MARK: -
// MARK: - UIScrollViewDelegate Methods.

extension RestaurantDetailViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isUpdated{
            headerTableTop.layoutHeadeForScrollViewOffset(offset: scrollView.contentOffset)
            
            return
        }
        
        if headerTableTop != nil
        {
            if scrollView.contentOffset.y > 200 {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            } else {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }

            headerTableTop.layoutHeadeForScrollViewOffset(offset: scrollView.contentOffset)
        }
    }
}
