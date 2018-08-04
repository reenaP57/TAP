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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(RefreshRestaurantDetail), name: Notification.Name(rawValue: kNotificationUpdateRestaurantDetail), object: nil)
  
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
        
        self.setRestaurantDetail(isRefresh : false)
    }

    func setCusotmNavigationBar()
    {
        self.navigationController?.navigationBar.backgroundColor = CColorWhite
        
        let colorImage = UIImage.imageFromColor(color: CColorNavRed)
        
        self.navigationController?.navigationBar.shadowImage = colorImage
        self.navigationController?.navigationBar.setBackgroundImage(colorImage, for: .default)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func RefreshRestaurantDetail(notification : Notification) {
     
        if let itemInfo = notification.object as? [String : AnyObject] {
            isUpdated = true
            var stop = false
            
            for (index, _) in arrDishList.enumerated() {
                
                let dict = arrDishList[index]
                
                if dict[CDish_id] as? Int == itemInfo[CDish_id] as? Int {
                    var updatedDict = dict
                    updatedDict[CQuantity] = itemInfo[CQuantity] as AnyObject
                    arrDishList[index] = updatedDict
                    stop = true
                }
            }
            
            if stop {
                
                if categoryID == 0 {
                    self.filterMostPopularDish()
                } else {
                    self.filterCategoryWithID(categoryID: "\(categoryID ?? 0)")
                }
            }
            
        }
        else {
            isUpdated = true
            tblRestDetail.reloadData()
        }
    }
    
    
    func setRestaurantDetail(isRefresh : Bool) {
        
        if !isRefresh {
            tblRestDetail.isHidden = true
            activityLoader.startAnimating()
        }
        
        
        APIRequest.shared().restaurantDetail(restaurant_id: restaurantID!) { (response, error) in
            
            self.activityLoader.stopAnimating()
            
            if response != nil && error == nil {
                
                self.tblRestDetail.isHidden = false
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                
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
                
                if self.dictRest.valueForInt(key: CNo_person_rated) != 0 {
                    self.restaurantTopView.lblRating.text = "\(self.dictRest.valueForDouble(key: CAvg_rating) ?? 0.0)"
                    self.restaurantTopView.lblRatingCount.text = "(\(self.dictRest.valueForString(key: CNo_person_rated)))"
                }
                
                
                self.restaurantTopView.btnContactNo.setTitle((self.dictRest.valueForString(key: CContact_no)), for: .normal)
                
                self.restaurantTopView.vwRating.rating = self.dictRest.valueForDouble(key: CAvg_rating)!
                
                if self.dictRest.valueForInt(key: CFav_status) == 0 {
                    self.restaurantTopView.btnLike.isSelected = false
                } else {
                    self.restaurantTopView.btnLike.isSelected = true
                }
                
                
                if self.dictRest.valueForInt(key: COpen_Close_Status) == 0 {
                    self.restaurantTopView.lblClosed.hide(byWidth: false)
                } else {
                    self.restaurantTopView.lblClosed.hide(byWidth: true)
                }
                
                //...Hide searchbar If dishes available for this restaurant
                
                if self.arrCategory.count == 0 {
                    self.restaurantTopView.vwSearch.hide(byHeight: true)
                } else {
                    self.restaurantTopView.vwSearch.hide(byHeight: false)
                }
                
                self.tblRestDetail.reloadData()
                
            } else {
                
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: error?.localizedDescription, btnOneTitle: CRetry , btnOneTapped: { (action) in
                    self.setRestaurantDetail(isRefresh: isRefresh)
                }, btnTwoTitle: CCancel, btnTwoTapped: { (action) in
                    
                })
            }
            
        }
        
        
        //MARK:- Restaurant Top View Action
        
        restaurantTopView.btnBack.touchUpInside { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
        restaurantTopView.btnLike.touchUpInside { (sender) in
            
            //...Open login Popup If user is not logged In OtherWise Like
            
            if appDelegate?.loginUser?.user_id == nil{
                
                appDelegate?.openLoginPopup(viewController: self, fromOrder: false, completion: {
                    self.isUpdated = true
                })
                
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
 
    func updateQuantity(cell : DishDetailTableViewCell, indexPath : IndexPath, isPlus : Bool) {
        
        
        let isClearCart =  self.checkCartForThisRestaurant()
        
        if isClearCart {
            
            isUpdated = true
            let dict = arrSelectedDishList[indexPath.row]
            
            //...Cart will be add If Cart from same restaurant
            
            let currentCount = Int(cell.txtQuantity.text!)
            
            var updatedDict = dict
            updatedDict[CQuantity] = cell.txtQuantity.text as AnyObject
            
            
            if cell.txtQuantity.text == "0" {
                TblCart.deleteObjects(predicate: NSPredicate(format: "%K == %@", CDish_id, "\(dict.valueForInt(key: CDish_id)!)"))
                
            } else {
                appDelegate?.saveRestaurantDetail(dictRest: dictRest)
                appDelegate?.saveCart(dict: updatedDict, rest_id: restaurantID!)
            }
            
            appDelegate?.setCartCountOnTab()
            
            arrSelectedDishList[indexPath.row] = updatedDict
            tblRestDetail.reloadRows(at: [indexPath], with: .none)
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
            
        } else {
            
            //... If cart from other restaurant than show popup with clear cart option
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageAlreadyCardAdded, btnOneTitle: CClearCartAndAdd, btnOneTapped: { (action) in
                TblCart.deleteAllObjects()
                TblCartRestaurant.deleteAllObjects()
                
                appDelegate?.setCartCountOnTab()
                
            }, btnTwoTitle: CClose, btnTwoTapped: { (actio) in
            })
        }
        
        isUpdated = false
    }
    
    
    //MARK:- Check cart in restaurant
    
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
    
    func checkDishAvailableForCategory() -> Bool {
        
        var arrData = [[String : AnyObject]]()
        
        let category_id = "\(categoryID ?? 0)"
        
        if categoryID == 0 {
            arrData = arrDishList.filter {( $0["popular_index"] as! Int != 0)}
        } else {
            arrData = arrDishList.filter {( $0["dish_category_ids"]!.contains(category_id))}
        }
        
        return arrData.count > 0
    }
    
   
    //MARK:- Category Header View delegate
    
    func selectCategory(categoryID: String) {
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            
            self.isUpdated = true
            
            if categoryID == "" {
                self.categoryID = 0
                self.filterMostPopularDish()
            } else {
                self.categoryID = Int(categoryID)
                self.filterCategoryWithID(categoryID: categoryID)
            }
            
            if self.tblRestDetail.contentSize.height < self.tblRestDetail.contentOffset.y - self.tblRestDetail.CViewHeight
            {
                self.tblRestDetail.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            self.tblRestDetail.setContentOffset(CGPoint(x: 0, y: 0) , animated: true)
            
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.isUpdated = false
//            self.view.layoutIfNeeded()
//            self.view.setNeedsLayout()
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
        
        let headerView = RestaurantDetailHeaderView.viewFromXib as? RestaurantDetailHeaderView
        headerView?.delegate = self
        
        headerView?.loadCategoryList(arrCategory: arrCategory, categoryId : categoryID == 0 ? "" : "\(categoryID ?? 0)")
        
        //...Check dish available for selected category
        headerView?.lblNoDishMsg.isHidden = self.checkDishAvailableForCategory()
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.checkDishAvailableForCategory() ? 66 : 150
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
            
            let dict = arrSelectedDishList[indexPath.row]
            
            //...Check cart is added for particular dish and category
//            let arrCart = TblCart.fetch(predicate: NSPredicate(format: "%K == %@ && %K == %@", "dish_id", "\(dict.valueForInt(key: "dish_id")!)","dish_category_id","\(self.categoryID ?? 0)"), orderBy: nil, ascending: false)
            let arrCart = TblCart.fetch(predicate: NSPredicate(format: "%K == %@", CDish_id, "\(dict.valueForInt(key: CDish_id)!)"), orderBy: nil, ascending: false)

           
            if (arrCart?.count)! > 0 {
                cell.txtQuantity.text = "\((arrCart![0] as! TblCart).quantity)"
            } else {
                cell.txtQuantity.text = "0"
            }
            
           
            cell.lblDishName.text = dict.valueForString(key: CDish_name)
            cell.lblCuisine.text = dict.valueForString(key: CDish_ingredients)
            cell.lblPrice.text = "$\(String(format: "%.2f", dict.valueForDouble(key: CDish_price)!))"
            
            cell.imgVDish.sd_setShowActivityIndicatorView(true)
            cell.imgVDish.sd_setImage(with: URL(string: (dict.valueForString(key: CDish_image))), placeholderImage: nil)
            
            
            cell.txtQuantity.addTarget(self, action: #selector(txtQuantityDidBeginChange(_:)), for: .editingDidBegin)
            cell.txtQuantity.addTarget(self, action: #selector(txtQuantityDidEndChange(_:)), for: .editingDidEnd)
            
            
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
    

    @objc func txtQuantityDidBeginChange(_ textField : UITextField) {
        isUpdated = true
    }
    
    @objc func txtQuantityDidEndChange(_ textField : UITextField) {
        isUpdated = false
        
        let isClearCart =  self.checkCartForThisRestaurant()
       
        if isClearCart {
            
                let point = textField.convert(CGPoint.zero, to: tblRestDetail)

                if let indexpath = tblRestDetail.indexPathForRow(at: point)
                {
                    if let cell = tblRestDetail.dequeueReusableCell(withIdentifier: "DishDetailTableViewCell", for: indexpath) as? DishDetailTableViewCell {
               
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
