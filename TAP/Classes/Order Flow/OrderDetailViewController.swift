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
    @IBOutlet weak var btnViewMap : UIButton!
    
    @IBOutlet weak var vwRateOrder : UIView!
    @IBOutlet weak var vwOrderDetails : UIView!
    @IBOutlet weak var cnTblDetailHeight : NSLayoutConstraint!
    @IBOutlet weak var cnTblPriceHeight : NSLayoutConstraint!

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
                cell.lblPrice.text = dict?.valueForString(key: "price")
                cell.lblTotalPrice.text = dict?.valueForString(key: "total")

                
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



