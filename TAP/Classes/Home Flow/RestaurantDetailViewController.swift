//
//  RestaurantDetailViewController.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: ParentViewController {

    @IBOutlet weak var tblRestDetail : UITableView!
    
    var headerView : RestaurantDetailHeaderView!
    var headerTableTop : ParallaxHeaderView!
    var restaurantTopView : RestaurantDetailTopView!
    var footerView : RestaurantDetailFooterView!

    
    var arrDishList  = [["dishname":"Maxican Crepe","desc":"Maxican style tomato salsa, spicy chill sauce cheese cream...","price":4],
                        ["dishname":"Cesar salad wrap","desc":"Maxican style tomato salsa, spicy chill sauce cheese creame tomato salsa, spicy chill sauce cheese crea","price":10],
                        ["dishname":"Country road chicken","desc":"Maxican style tomato salsa, spicy chill sauce cheese cream...","price":7],
                        ["dishname":"Maxican Crepe","desc":"Maxican style tomato salsa, spicy chill sauce cheese cream...","price":14],["dishname":"Maxican Crepe","desc":"Maxican style tomato salsa, spicy chill sauce cheese cream...","price":4],
                        ["dishname":"Cesar salad wrap","desc":"Maxican style tomato salsa, spicy chill sauce cheese creame tomato salsa, spicy chill sauce cheese crea","price":10],
                        ["dishname":"Country road chicken","desc":"Maxican style tomato salsa, spicy chill sauce cheese cream...","price":7],
                        ["dishname":"Maxican Crepe","desc":"Maxican style tomato salsa, spicy chill sauce cheese cream...","price":14]]
    
    var dict  = ["res_name":"Cafe De Perks","res_location":"1066 Eastlawn Ave Sarnia ON (Sarnia ,Ontario)","cusuine":"Rolls - Desserts","country_code":"+91","contact_no":"9498785865","rated_count":"45","rating":3.0,"like_status":1] as [String : AnyObject]
    
    var isUpdated : Bool = false
    
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
        
        self.title = "Cafe De Perks"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
        
        if headerView == nil {
            headerView = RestaurantDetailHeaderView.viewFromXib as? RestaurantDetailHeaderView
    
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
        
        restaurantTopView.lblRestName.text = dict.valueForString(key: "res_name")
        restaurantTopView.lblResLocation.text = dict.valueForString(key: "res_location")
        restaurantTopView.lblCuisines.text = dict.valueForString(key: "cusuine")

        restaurantTopView.lblRating.text = "\(dict.valueForDouble(key: "rating") ?? 0.0)"
        restaurantTopView.lblRatingCount.text = "(\(dict.valueForString(key: "rated_count")))"
        restaurantTopView.btnContactNo.setTitle("\(dict.valueForString(key: "country_code"))-\(dict.valueForString(key: "contact_no"))", for: .normal)
        
        restaurantTopView.vwRating.rating = dict.valueForDouble(key: "rating")!
        
        if dict.valueForInt(key: "like_status") == 0 {
           restaurantTopView.btnLike.isSelected = false
        } else {
            restaurantTopView.btnLike.isSelected = true
        }
        
      
        //MARK:- Restaurant Top View Action
        
        restaurantTopView.btnBack.touchUpInside { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
        restaurantTopView.btnLike.touchUpInside { (sender) in
            
            appDelegate?.openLoginPopup(viewController: self)
            
//            if restaurantTopView.btnLike.isSelected {
//                restaurantTopView.btnLike.isSelected = false
//            } else {
//                restaurantTopView.btnLike.isSelected = true
//            }
        }
        
        restaurantTopView.btnPromotion.touchUpInside { (sender) in
            
            isUpdated = true
            if let promotionVC = CMain_SB.instantiateViewController(withIdentifier: "PromotionViewController") as? PromotionViewController {
                self.navigationController?.pushViewController(promotionVC, animated: true)
            }
        }
        
        restaurantTopView.btnViewRating.touchUpInside { (sender) in
            
            isUpdated = true
            
            if let ratingVC = CMain_SB.instantiateViewController(withIdentifier: "RatingViewController") as? RatingViewController {
                self.navigationController?.pushViewController(ratingVC, animated: true)
            }
        }
        
        restaurantTopView.btnContactNo.touchUpInside { (sender) in
        
            if dict.valueForString(key: "contact_no") != "" {
                self.dialPhoneNumber(phoneNumber: dict.valueForString(key: "contact_no"))
            }
        }
    }
    
    @objc func btnSearchClicked() {
        
        self.tblRestDetail.setContentOffset(CGPoint.zero, animated: false)
        showSearchScreen()
    }
    
    func showSearchScreen()
    {
        if let searchVC = CMain_SB.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            searchVC.isFromOther = true
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension RestaurantDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDishList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.CViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        footerView.btnViewCart.touchUpInside { (sender) in
            
            appDelegate?.tabbar?.btnTabClicked(sender: (appDelegate?.tabbar?.btnCart)!)
        }
        
        return footerView
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

            cell.txtQuantity.addTarget(self, action: #selector(txtQuantityDidBeginChange), for: .editingDidBegin)
            cell.txtQuantity.addTarget(self, action: #selector(txtQuantityDidEndChange), for: .editingDidEnd)
            
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
