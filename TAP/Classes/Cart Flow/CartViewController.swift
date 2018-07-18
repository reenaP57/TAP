//
//  CartViewController.swift
//  TAP
//
//  Created by mac-00017 on 15/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit
import Stripe


class CartViewController: ParentViewController {
   
    
    @IBOutlet weak var scrollVW : UIScrollView!
    @IBOutlet weak var imgVDish : UIImageView!{
        didSet {
            imgVDish.layer.cornerRadius = 5.0
            imgVDish.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var lblResName : UILabel!
    @IBOutlet weak var lblResLocation : UILabel!
    @IBOutlet weak var lblContact : UILabel!
    @IBOutlet weak var btnViewMap : UIButton!
    @IBOutlet weak var vwEmptyCart : UIView!
    @IBOutlet weak var vwFooter : UIView!
    
    
    @IBOutlet weak var txtVNote : UITextView!{
        didSet {
            txtVNote.placeholderColor = CColorLightGray
            txtVNote.placeholderFont = CFontSFUIText(size: 13, type: .Regular)
        }
    }

    @IBOutlet weak var cnTblOrderListHeight : NSLayoutConstraint!
    @IBOutlet weak var cnTblPriceHeight : NSLayoutConstraint!
    
    @IBOutlet weak var tblOrderList : UITableView!{
        didSet{
            tblOrderList.layer.cornerRadius = 5.0
            tblOrderList.clipsToBounds = true
            tblOrderList.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var tblOrderPrice : UITableView!{
        didSet{
            tblOrderPrice.layer.cornerRadius = 5.0
            tblOrderPrice.clipsToBounds = true
            tblOrderPrice.layer.masksToBounds = true
        }
    }
    
    
    var arrCartList = [TblCart]()
    var arrPrice = [[String : AnyObject]]()
    var resDetail = TblCartRestaurant()
    
    var additionalCharge = 0.0
    var subTotal = 0.0
    var orderID : Int?
    
    
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
        
        DispatchQueue.main.async {
          self.setOrderDetail()
        }
    }
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = CViewCart
    }
    
    func setOrderDetail() {
        
        arrPrice.removeAll()
        arrCartList.removeAll()
        scrollVW.contentInset = UIEdgeInsetsMake(0, 0, 175, 0)

        arrCartList =  TblCart.fetchAllObjects() as! [TblCart]
        
        if arrCartList.count > 0 {
            
            vwEmptyCart.isHidden = true
            vwFooter.isHidden = false
            scrollVW.isHidden = false
            
            let arrRes = TblCartRestaurant.fetchAllObjects() as! [TblCartRestaurant]
            resDetail = arrRes[0]
            
            lblResName.text =  resDetail.restaurant_name
            lblContact.text =  resDetail.contact_no
            lblResLocation.text =  resDetail.address
        
            imgVDish.sd_setShowActivityIndicatorView(true)
            imgVDish.sd_setImage(with: URL(string: resDetail.restaurant_img!), placeholderImage: nil)
            
            
            self.createPriceArray()
            
            tblOrderList.reloadData()
            self.updateOrderTableHeight()
            
            
        } else {
            
            vwEmptyCart.isHidden = false
            vwFooter.isHidden = true
            scrollVW.isHidden = true
        }
        
    }
    
    func createPriceArray() {
      
        subTotal = 0.0
        additionalCharge = 0.0
        
        for cart in arrCartList {
            let total = cart.dish_price * Double(cart.quantity)
            subTotal = subTotal + total
        }
        
        let arrAD = resDetail.additional_tax as? [[String : AnyObject]]
        let taxPrice = subTotal * resDetail.tax / 100
        
        
        arrPrice.append(["title":"Subtotal" as AnyObject,"value": String(format: "%.2f", subTotal) as AnyObject])
        arrPrice.append(["title":"Tax(\(resDetail.tax)%)" as AnyObject,"value": String(format: "%.2f", taxPrice) as AnyObject])
        
        
        for cart in arrAD! {
            
            var amount = 0.0
            
            if cart.valueForString(key: "tax_type") == "1" {
                amount = subTotal * cart.valueForDouble(key: "tax_amount")! / 100
            } else {
                amount = cart.valueForDouble(key: "tax_amount")!
            }
            
            arrPrice.append(["title":cart.valueForString(key: "tax_name") as AnyObject,"value": String(format: "%.2f", amount) as AnyObject])
            
            additionalCharge = additionalCharge + amount
        }
        
        arrPrice.append(["title":"To Pay" as AnyObject,"value": 0.0 as AnyObject])
        
        self.updatePrice(tax: taxPrice, additional_charge: additionalCharge)
    }
    
    
    func updatePrice (tax : Double, additional_charge : Double) {
        
        let toPay = subTotal + tax + additional_charge
        
        var index = 0
        
        for item in arrPrice {
            
            var dict = item
            
            if dict.valueForString(key: "title") == "Subtotal" {
                dict["value"] = subTotal as AnyObject
            }
            
            if dict.valueForString(key: "title") == "Tax(\(resDetail.tax)%)" {
                dict["value"] = tax as AnyObject
            }
            
            if dict.valueForString(key: "title") == "To Pay" {
                dict["value"] = toPay as AnyObject
            }
            
            arrPrice[index] = dict
            index = index + 1
        }
        
        tblOrderPrice.reloadData()
        self.updateOrderTableHeight()

    }
    
    func updateOrderTableHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.cnTblOrderListHeight.constant = self.tblOrderList.contentSize.height
            self.cnTblPriceHeight.constant = self.tblOrderPrice.contentSize.height
        }
    }
    
    func updateCart(dish_id : Int64, qauntity : Int16) {
        
        let tblCart = TblCart.findOrCreate(dictionary: [CDish_id : dish_id]) as! TblCart
        tblCart.quantity = qauntity
        CoreData.saveContext()
    }
    
    func updateQuantity(cell : CartTableViewCell, dict : TblCart, index : IndexPath, isIncrease : Bool)
    {
        
        var currentCount = 0
        
        if isIncrease {
            currentCount = (cell.lblquantity.text?.toInt)! + 1
        } else {
            currentCount = (cell.lblquantity.text?.toInt)! - 1 > 0 ? (cell.lblquantity.text?.toInt)! - 1 : 0
        }
        
        cell.lblquantity.text = "\(currentCount)"
        
        dict.quantity = Int16(currentCount)
        arrCartList[index.row] = dict
        tblOrderList.reloadRows(at: [index], with: .none)
        
        //... Update cart and price
        
        self.subTotal = 0.0
        
        for cart in arrCartList {
            let total = cart.dish_price * Double(cart.quantity)
            self.subTotal = subTotal + total
        }
        
        let taxPrice = self.subTotal * resDetail.tax / 100
        
        self.updateCart(dish_id: dict.dish_id, qauntity: dict.quantity)
        
        if cell.lblquantity.text == "0" {
            TblCart.deleteObjects(predicate: NSPredicate(format: "%K == %d", CDish_id, dict.dish_id))
            arrCartList.removeAll()
            arrCartList =  TblCart.fetchAllObjects() as! [TblCart]
            tblOrderList.reloadData()
            self.updateOrderTableHeight()
            
            if self.arrCartList.count == 0 {
                self.vwEmptyCart.isHidden = false
                self.vwFooter.isHidden = true
                self.scrollVW.isHidden = true
            }
        }
        
        self.updatePrice(tax: taxPrice, additional_charge: additionalCharge)
        
        let dic =  [CQuantity : cell.lblquantity.text as Any,
                    CDish_id : dict.dish_id as Any]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationUpdateRestaurantDetail), object: dic)
    }
    
    func openPaymentPopup() {
        
        if let vwPayment = PaymentPopupView.viewFromXib as? PaymentPopupView {
            
            vwPayment.CViewSetSize(width: CScreenWidth, height: CScreenHeight)
            
            vwPayment.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.1) {
                vwPayment.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            appDelegate?.window?.addSubview(vwPayment)
            
            
            //...Action
            vwPayment.btnWithStripe.touchUpInside { (sender) in
                
                //...Stripe Payment
                vwPayment.removeFromSuperview()
                self.addOrder(paymentType: CPaymentStripe)
           }
            
            vwPayment.btnViaCash.touchUpInside { (sender) in
                //...Cash Payment
                
                vwPayment.removeFromSuperview()
                self.addOrder(paymentType: CPaymentCash)
            }
            
            vwPayment.btnClose.touchUpInside { (sender) in
                vwPayment.removeFromSuperview()
            }
        }
    }
    
}


//MARK:-
//MARK:- Action

extension CartViewController {
    
    @IBAction func btnViewMapClicked(sender : UIButton) {
        
        let strUrl = "https://maps.google.com/?q=\(resDetail.latitude),\(resDetail.longitude)"
        UIApplication.shared.open(URL(string: strUrl)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func btnProceedToPayClicked(sender:UIButton){
        
        if appDelegate?.loginUser?.user_id == nil {
            
            appDelegate?.openLoginPopup(viewController: self, fromOrder: false, completion: {
            })
            
        } else {
            
            let arrID = arrCartList.compactMap{$0.dish_id}
            
            let dict = [CRestaurant_id : resDetail.restaurant_id,
                        "dish_ids" : arrID] as [String : AnyObject]
            
            APIRequest.shared().updateRestaurantDetail(param: dict) { (response, error) in
                
                if response != nil && error == nil {
                    
                    let dataResponse = response?.value(forKey: CJsonData) as! [String : AnyObject]
                    let arrDishes = dataResponse.valueForJSON(key: "dishes") as! [[String : AnyObject]]
                    
                    var arrDishesUpdate = [String]()
                    var arrADTaxUpdate = [String]()
                    var isTaxUpdated = false
                    
                    for cart in self.arrCartList {
                        
                        let tblCart = TblCart.findOrCreate(dictionary: [CDish_id : cart.dish_id]) as! TblCart
                        
                        for dishes in arrDishes {
                            
                            if Int(cart.dish_id) == dishes.valueForInt(key: CDish_id) &&
                                (cart.dish_name != dishes.valueForString(key: CDish_name) ||
                                    cart.dish_price != dishes.valueForDouble(key: CDish_price) ||
                                    dishes.valueForInt(key: "status_id") == 3) {
                                
                                tblCart.dish_name = dishes.valueForString(key: CDish_name)
                                tblCart.dish_price = dishes.valueForDouble(key: CDish_price)!
                                tblCart.is_available = dishes.valueForBool(key: CIs_available)
                                tblCart.status_id = Int16(dishes.valueForInt(key: "status_id")!)
                                
                                arrDishesUpdate.append("")
                            }
                        }
                        
                        CoreData.saveContext()
                    }
                    
                    self.arrCartList.removeAll()
                    self.arrCartList = TblCart.fetchAllObjects() as! [TblCart]
                    self.tblOrderList.reloadData()
                    
                    let tblCartRest = TblCartRestaurant.findOrCreate(dictionary: ["restaurant_id" : self.resDetail.restaurant_id]) as! TblCartRestaurant
                    
                    let arrDishAD = dataResponse.valueForJSON(key: CAdditional_tax) as! [[String : AnyObject]]
                    let arrAd = self.resDetail.additional_tax as? [[String : AnyObject]]
                    
                    var arrADCharge = [[String : AnyObject]]()
                    
                    
                    if arrDishAD.count != arrAd?.count {
                        
                        for item in arrDishAD {
                            arrADCharge.append(item)
                            arrADTaxUpdate.append("")
                        }
                        
                        tblCartRest.additional_tax = arrADCharge as NSObject
                        
                    } else {
                        
                        for item in arrDishAD {
                            
                            for item2 in arrAd!  {
                                
                                if item.valueForInt(key: "tax_id") == item2.valueForInt(key: "tax_id") &&  item.valueForInt(key: "tax_amount") != item2.valueForInt(key: "tax_amount")
                                {
                                    arrADTaxUpdate.append("")
                                }
                            }
                        }
                        
                        if arrADTaxUpdate.count > 0 {
                            tblCartRest.additional_tax = arrDishAD as NSObject
                        }
                    }
                    
                    
                    if self.resDetail.tax != dataResponse.valueForDouble(key: CTax_percent){
                        tblCartRest.tax = dataResponse.valueForDouble(key: CTax_percent)!
                        isTaxUpdated = true
                    }
                    
                    CoreData.saveContext()
                    self.arrPrice.removeAll()
                    self.createPriceArray()
                    
                    
                    if dataResponse.valueForInt(key: COpen_Close_Status) == 0 {
                        //Closed restaurant
                       
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CClosedRestaurant, btnOneTitle: "Ok", btnOneTapped: { (action) in
                            
                            self.scrollVW.contentInset = UIEdgeInsetsMake(0, 0, 59, 0)
                            self.vwFooter.isHidden = true
                        })
                        
                    } else if arrDishesUpdate.count > 0 || arrADTaxUpdate.count > 0 || isTaxUpdated {
                        
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageUpdatedRestCart, btnOneTitle: "Ok", btnOneTapped: { (action) in
                        })
                        
                    } else {
                        self.openPaymentPopup()
                    }
                }
            }
        }
    }
}


//MARK:-
//MARK:- TextView Delegate Method

extension CartViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count > 0 {
            textView.placeholderColor = UIColor.clear
        } else {
            textView.placeholderColor = CColorLightGray
        }
    
        if textView.text.count > CharacterLimit {
            let currentText = textView.text as NSString
            txtVNote.text = currentText.substring(to: currentText.length - 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            return false
        }
        
        return true
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension CartViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView .isEqual(tblOrderList) ? arrCartList.count : arrPrice.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView .isEqual(tblOrderList) ? 81 : ((CScreenWidth * 40) / 375.0)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.isEqual(tblOrderList) {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as? CartTableViewCell {
                
                let dict = arrCartList[indexPath.row]
                cell.lblDishName.text = dict.dish_name
                cell.lblPrice.text = "$\(dict.dish_price)"
                cell.lblquantity.text = "\(dict.quantity)"
                
                cell.imgVDish.sd_setShowActivityIndicatorView(true)
                cell.imgVDish.sd_setImage(with: URL(string: dict.dish_image!), placeholderImage: nil)
                
                cell.btnPlus.touchUpInside { (sender) in
                    
                    let currentCount = (cell.lblquantity.text?.toInt)! + 1
                    if currentCount.toString.count <= 3 {
                        self.updateQuantity(cell: cell, dict: dict, index: indexPath, isIncrease: true)
                    }
                }
                
                cell.btnMinus.touchUpInside { (sender) in
                    self.updateQuantity(cell: cell, dict: dict, index: indexPath, isIncrease: false)
                }
                
                return cell
            }
            
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPriceTableViewCell") as? OrderPriceTableViewCell {
                
                let dict = arrPrice[indexPath.row]
                
                cell.lblTitle.text = dict.valueForString(key: "title")
                cell.lblValue.text = String(format: "$%.2f",(dict.valueForDouble(key: "value"))!)
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if tableView.isEqual(tblOrderList) {
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            if tableView.isEqual(tblOrderList) {
                
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CDeleteOrderMessage, btnOneTitle: CYes, btnOneTapped: { (action) in
                    
                    let dict = self.arrCartList[indexPath.row]
                    TblCart.deleteObjects(predicate: NSPredicate(format: "%K == %@", CDish_id, "\(dict.dish_id)"))
                    
                    self.arrCartList.remove(at: indexPath.row)
                    self.tblOrderList.reloadData()
                    
                    
                    //... Update cart and price
                   
                    self.subTotal = 0.0
                    
                    for cart in self.arrCartList {
                        let total = cart.dish_price * Double(cart.quantity)
                        self.subTotal = self.subTotal + total
                    }
                    
                    let taxPrice = self.subTotal * self.resDetail.tax / 100
                    self.updatePrice(tax: taxPrice, additional_charge: self.additionalCharge)
                    
                    
                    if self.arrCartList.count == 0 {
                        self.vwEmptyCart.isHidden = false
                        self.vwFooter.isHidden = true
                        self.scrollVW.isHidden = true
                    }
                    
                    self.updateOrderTableHeight()
                    self.view.layoutIfNeeded()
                    
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationUpdateRestaurantDetail), object: nil)
                    
                }, btnTwoTitle: CNo) { (action) in
                }
            }
       }
    }
}


//MARK:-
//MARK:- Stripe Payment Delegate

extension CartViewController : STPAddCardViewControllerDelegate {
   
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        if token.tokenId != "" {
            self.stripePayment(token: token.tokenId)
        }
    }

}


//MARK:-
//MARK:- API Method

extension CartViewController {
    
    func stripePayment(token : String) {
        
        APIRequest.shared().stripePayment(order_id: self.orderID, stripe_token: token) { (response, error) in
            
            if response != nil && error == nil {
                
                let dataRes = response?.value(forKey: CJsonData) as! [String : AnyObject]
                
                TblCart.deleteAllObjects()
                TblCartRestaurant.deleteAllObjects()
                CUserDefaults.removeObject(forKey: UserDefaultCartID)

                NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationUpdateRestaurantDetail), object: nil)

                
                //...After Payment Success redirect
                
                self.dismiss(animated: true, completion: nil)
                
                
                if let paymentVC = CCart_SB.instantiateViewController(withIdentifier: "PaymentSuccessViewController") as? PaymentSuccessViewController {
                    
                    paymentVC.dictPayment = [COrder_no : dataRes.valueForInt(key: COrder_no) as Any,
                                             COrder_total : self.arrPrice.last?.valueForDouble(key: "value")! as Any,
                                             CTranscation_id : dataRes.valueForString(key: CTranscation_id),
                                             COrderID : dataRes.valueForInt(key: COrderID) as Any ] as [String : AnyObject]
                    
                    self.navigationController?.pushViewController(paymentVC, animated: true)
                }
            }
        }
    }
    
    
    func addOrder(paymentType : String) {
        
        let totalToPay = arrPrice.last?.valueForDouble(key: "value")
 
        var arrCart = [[String : AnyObject]]()
        var arrADPrice = [[String : AnyObject]]()
        let arrAD = resDetail.additional_tax as? [[String : AnyObject]]
        
        for cart in arrCartList {
            
            let keys = cart.entity.attributesByName.keys
            var dicTest : Dictionary = cart.dictionaryWithValues(forKeys: Array(keys))
            
            dicTest.removeValue(forKey: CRestaurant_id)
//            dicTest.removeValue(forKey: CStatus_id)
//            dicTest.removeValue(forKey: CIs_available)

            arrCart.append(dicTest as [String : AnyObject])
        }

        
        for item in arrAD! {
            
            var dict = item
            var amount = ""
 
            if dict.valueForString(key: "tax_type") == "1" {
                amount = "\((subTotal * dict.valueForDouble(key: "tax_amount")! / 100).roundToPlaces(places: 2))"

            } else {
                amount = "\(dict.valueForDouble(key: "tax_amount")!)"
            }
            
            dict.removeValue(forKey: "tax_id")
            dict["order_tax_amount"] = amount as AnyObject
            
            arrADPrice.append(dict)
        }
        
        
        let dict = [CRestaurant_id : self.resDetail.restaurant_id as AnyObject,
                    CNote : self.txtVNote.text,
                    CSubtotal : subTotal ,
                    CTax_percent : self.resDetail.tax,
                    CTax_amount : subTotal * resDetail.tax / 100 ,
                    COrder_total : totalToPay as Any,
                    CPayment_type : paymentType,
                    CCart : arrCart,
                    CAdditional_tax : arrADPrice] as [String : AnyObject]
        
        
        APIRequest.shared().addOrder(param: dict) { (response, error) in
            
            if response != nil && error == nil {
                
                let dataResponse = response?.value(forKey: CJsonData) as! [String : AnyObject]
                
                self.orderID = dataResponse.valueForInt(key: COrderID)
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationRefreshOrderList), object: nil)
                
                if paymentType == CPaymentStripe {
                    
                    let stripeVW = STPAddCardViewController()
                    stripeVW.delegate = self
                    
                    let navigationController = UINavigationController(rootViewController: stripeVW)
                    self.present(navigationController, animated: true)
                
                } else {
                    
                    TblCart.deleteAllObjects()
                    TblCartRestaurant.deleteAllObjects()
                    CUserDefaults.removeObject(forKey: UserDefaultCartID)
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationUpdateRestaurantDetail), object: nil)
                    
                    if let orderDetailVC = COrder_SB.instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController {
                        orderDetailVC.orderID = self.orderID
                        self.navigationController?.pushViewController(orderDetailVC, animated: true)
                    }
                }
            }
        }
    }
}
