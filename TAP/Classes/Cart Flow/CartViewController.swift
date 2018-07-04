//
//  CartViewController.swift
//  TAP
//
//  Created by mac-00017 on 15/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class CartViewController: ParentViewController {
   
    
    @IBOutlet weak var scrollVW : UIScrollView! {
        didSet {
             scrollVW.contentInset = UIEdgeInsetsMake(0, 0, 175, 0)
        }
    }
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
        self.title = CViewCart
        self.setOrderDetail()
    }
    
    func setOrderDetail() {
        
        arrCartList =  TblCart.fetchAllObjects() as! [TblCart]
        
        if arrCartList.count > 0 {
            
            vwEmptyCart.isHidden = true
            scrollVW.isHidden = false
            
            let arrRes = TblCartRestaurant.fetchAllObjects() as! [TblCartRestaurant]
            let resDetail = arrRes[0]
            
            lblResName.text = resDetail.restaurant_name
            lblContact.text = resDetail.contact_no
            lblResLocation.text = resDetail.address
        
            imgVDish.sd_setShowActivityIndicatorView(true)
            imgVDish.sd_setImage(with: URL(string: resDetail.restaurant_img!), placeholderImage: nil)
            
            var subTotal = 0.0
            
            for cart in arrCartList {
                
                let total = cart.dish_price * Double(cart.qauntity)
                subTotal = subTotal + total
            }
            
            
            arrPrice = [["title":"Subtotal","value": ""],
                        ["title":"Tax\(resDetail.tax)","value": resDetail.tax],
                        ["title":"Additional Charge","value": resDetail.additional_tax as Any],
                        ["title":"To Pay","value": subTotal]] as [[String : AnyObject]]
            
            
            
            tblOrderList.reloadData()
            tblOrderPrice.reloadData()
            self.updateOrderTableHeight()
            
        } else {
            
            vwEmptyCart.isHidden = false
            scrollVW.isHidden = true
        }
        
    }
    
    func updateOrderTableHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.cnTblOrderListHeight.constant = self.tblOrderList.contentSize.height
            self.cnTblPriceHeight.constant = self.tblOrderPrice.contentSize.height
        }
    }
    
    func updateCart(dish_id : Int64, qauntity : Int16) {
        
        let tblCart = TblCart.findOrCreate(dictionary: ["dish_id" : dish_id]) as! TblCart
        
        tblCart.qauntity = qauntity
        
        CoreData.saveContext()
    }
}

//MARK:-
//MARK:- Action

extension CartViewController {
    
    @IBAction func btnViewMapClicked(sender : UIButton) {
        
        UIApplication.shared.open(URL(string: "https://maps.google.com/?q=@23.0524,72.5337")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func btnProceedToPayClicked(sender:UIButton){
        
        if let vwPayment = PaymentPopupView.viewFromXib as? PaymentPopupView {
           
            vwPayment.CViewSetSize(width: CScreenWidth, height: CScreenHeight)
            
            vwPayment.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.1) {
                vwPayment.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            appDelegate?.window?.addSubview(vwPayment)

            
            //...Action
            vwPayment.btnWithStripe.touchUpInside { (sender) in
                
                //...After Payment Success redirect
              
                vwPayment.removeFromSuperview()

                if let paymentVC = CCart_SB.instantiateViewController(withIdentifier: "PaymentSuccessViewController") as? PaymentSuccessViewController {
                    self.navigationController?.pushViewController(paymentVC, animated: true)
                }
            }
            
            vwPayment.btnViaCash.touchUpInside { (sender) in
                
                vwPayment.removeFromSuperview()
                
                if let orderDetailVC = COrder_SB.instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController {
                    self.navigationController?.pushViewController(orderDetailVC, animated: true)
                }
            }
            
            vwPayment.btnClose.touchUpInside { (sender) in
                vwPayment.removeFromSuperview()
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
                cell.lblquantity.text = "\(dict.qauntity)"
                
                cell.btnPlus.touchUpInside { (sender) in
                    
                    let currentCount = (cell.lblquantity.text?.toInt)! + 1
                    cell.lblquantity.text = "\(currentCount)"
                    
                    dict.qauntity = Int16(currentCount)
                    arrCartList[indexPath.row] = dict
                    tblOrderList.reloadRows(at: [indexPath], with: .none)
                    
                    self.updateCart(dish_id: dict.dish_id, qauntity: dict.qauntity)
                }
                
                cell.btnMinus.touchUpInside { (sender) in
                    
                    let currentCount = (cell.lblquantity.text?.toInt)! - 1 > 0 ? (cell.lblquantity.text?.toInt)! - 1 : 0
                    cell.lblquantity.text = "\(currentCount)"
                    
                    dict.qauntity = Int16(currentCount)
                    arrCartList[indexPath.row] = dict
                    tblOrderList.reloadRows(at: [indexPath], with: .none)

                    self.updateCart(dish_id: dict.dish_id, qauntity: dict.qauntity)
                }
                
                
                return cell
            }
            
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPriceTableViewCell") as? OrderPriceTableViewCell {
                
                let dict = arrPrice[indexPath.row]
//                cell.lblTitle.text = dict?.valueForString(key: "title")
//                cell.lblValue.text = "$\(dict?.valueForString(key: "value") ?? "")"
                
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
                    TblCart.deleteObjects(predicate: NSPredicate(format: "%K == %@", "dish_id", "\(dict.dish_id)"))
                    
                    self.arrCartList.remove(at: indexPath.row)
                    self.tblOrderList.reloadData()
                    self.updateOrderTableHeight()
                    self.view.layoutIfNeeded()
                    
                }, btnTwoTitle: CNo) { (action) in
                }
            }
       }
    }
}

