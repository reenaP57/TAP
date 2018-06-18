//
//  OrderDetailViewController.swift
//  TAP
//
//  Created by mac-00017 on 14/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class OrderDetailViewController: ParentViewController {
    
    @IBOutlet weak var imgVDish : UIImageView!{
        didSet {
            imgVDish.layer.cornerRadius = 5.0
            imgVDish.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var lblResName : UILabel!
    @IBOutlet weak var lblResLocation : UILabel!
    @IBOutlet weak var lblAmount : UILabel!
    @IBOutlet weak var lblContact : UILabel!
    @IBOutlet weak var lblOrderID : UILabel!
    @IBOutlet weak var lblOrderStatus : UILabel!
    @IBOutlet weak var imgVOrderStatus : UIImageView!
    @IBOutlet weak var imgVContact : UIImageView!
    @IBOutlet weak var btnViewMap : UIButton!
    
    @IBOutlet weak var vwRateOrder : UIView!
    @IBOutlet weak var vwOrderDetails : UIView!
    @IBOutlet weak var vwOrderNote : UIView!
    @IBOutlet weak var lblNote : UILabel!

    @IBOutlet weak var cnTblDetailHeight : NSLayoutConstraint!
    @IBOutlet weak var cnTblPriceHeight : NSLayoutConstraint!
    @IBOutlet weak var scrollVW : UIScrollView!
    @IBOutlet weak var tblOrderDetail : UITableView!{
        didSet{
            tblOrderDetail.layer.cornerRadius = 5.0
            tblOrderDetail.clipsToBounds = true
            tblOrderDetail.layer.masksToBounds = true
        }
    }

    @IBOutlet weak var tblOrderPrice : UITableView!{
        didSet{
            tblOrderPrice.layer.cornerRadius = 5.0
            tblOrderPrice.clipsToBounds = true
            tblOrderPrice.layer.masksToBounds = true
        }
    }

    
    var arrOrderDetail = [Any]()
    var arrOrderPrice = [Any]()
    var isCompleted : Bool = false
    
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
        self.title = COrderSummary
        self.setOrderDetail()
    }
    
    func setOrderDetail() {
        
        // If order is completed
        
        if isCompleted {
            
            imgVContact.image = UIImage(named: "calender")
            lblContact.text = "Nov 23, 2017 at 7:30 PM"
            btnViewMap.hide(byHeight: true)
            imgVOrderStatus.hide(byHeight: true)
            scrollVW.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
            vwOrderNote.hide(byHeight: true)
           _ = tblOrderPrice.setConstraintConstant(0, edge: .top, ancestor: true)
            
        } else {
            scrollVW.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
            vwRateOrder.isHidden = true
        }

        
        arrOrderDetail = [["dishname":"Maxican Crepe","price":"4","quantity":"1","total":"4"],
        ["dishname":"Cesar salad wrap","price":"15","quantity":"2","total":"30"],
        ["dishname":"Country road chicken","price":"25","quantity":"3","total":"75"]]
        
        arrOrderPrice = [["title":"Subtotal","value":"25"],["title":"Tax (15%)","value":"3"],["title":"Additional Charge","value":"2"],["title":"To Pay","value":"30"]]
        
        tblOrderDetail.reloadData()
        tblOrderPrice.reloadData()
        
        
        DispatchQueue.main.async {
           
            self.cnTblDetailHeight.constant = self.tblOrderDetail.contentSize.height
            self.cnTblPriceHeight.constant = self.tblOrderPrice.contentSize.height
            
            self.vwOrderDetails.layoutSubviews()
        }
        
    }
}

//MARK:-
//MARK:- Action

extension OrderDetailViewController {
    
    @IBAction func btnViewMapClicked(sender : UIButton) {
        
//        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
//            UIApplication.shared.openURL(URL(string:
//                "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic")!)
//        } else {
//            print("Can't use comgooglemaps://");
//         UIApplication.shared.open(URL(string: " https://maps.google.com/?q=@23.0524,72.5337")!, options: [:], completionHandler: nil)
//        }
        
       
        
//        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
//
//             UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/@42.585444,13.007813,6z")!)
//
//
//            UIApplication.shared.open(URL(string: "https://www.google.com/maps/@42.585444,13.007813,6z")!, options: [:], completionHandler: nil)
//        } else {
//            print("Can't use comgooglemaps://")
//            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:23.0524,72.5337&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
//        }
       //        "http://maps.apple.com/maps?saddr=23.0524,72.5337&daddr=\(to.latitude),\(to.longitude)"
//        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
//            //'openURL' was deprecated in iOS 10.0: Please use openURL:options:completionHandler: instead
//
//            UIApplication.shared.open(URL(string: "comgooglemaps://?center=23.0524,72.5337&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
//
//          //  UIApplication.shared.open(URL(string:"comgooglemaps://?center=23.0524,72.5337&zoom=14&views=traffic&q=23.0524,72.5337")!, options: [:], completionHandler: nil)
//        } else {
//            print("Can't use comgooglemaps://")
//        }
    }
   
    
    @IBAction func btnRateOrderClicked(sender:UIButton){
       
        if let rateVC = COrder_SB.instantiateViewController(withIdentifier: "RateOrderViewController") as? RateOrderViewController {
            self.navigationController?.pushViewController(rateVC, animated: true)
        }
    }
}



//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension OrderDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView .isEqual(tblOrderDetail) ? arrOrderDetail.count : arrOrderPrice.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView .isEqual(tblOrderDetail) ? 81 : ((CScreenWidth * 40) / 375.0)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.isEqual(tblOrderDetail) {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell") as? OrderDetailTableViewCell {
                
                let dict = arrOrderDetail[indexPath.row] as? [String:AnyObject]
                cell.lblDishName.text = dict?.valueForString(key: "dishname")
                cell.lblQuantity.text = dict?.valueForString(key: "quantity")
                cell.lblPrice.text = "$\(dict?.valueForString(key: "price") ?? "0")"
                cell.lblTotalPrice.text = "$\(dict?.valueForString(key: "total") ?? "0")"

                
                return cell
            }
            
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPriceTableViewCell") as? OrderPriceTableViewCell {
                
                let dict = arrOrderPrice[indexPath.row] as? [String:AnyObject]
                cell.lblTitle.text = dict?.valueForString(key: "title")
                cell.lblValue.text = "$\(dict?.valueForString(key: "value") ?? "")"

                return cell
            }
        }
        
        return UITableViewCell()
    }
}



