//
//  OrderDetailViewController.swift
//  TAP
//
//  Created by mac-00017 on 14/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class OrderDetailViewController: ParentViewController {
    
    @IBOutlet weak var imgVRest : UIImageView!{
        didSet {
            imgVRest.layer.cornerRadius = 5.0
            imgVRest.layer.masksToBounds = true
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
    
    @IBOutlet weak var vwRestDetail : UIView!
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

    
    var arrOrderList = [[String : AnyObject]]()
    var arrOrderPrice = [[String : AnyObject]]()
    var isCompleted : Bool = false
    var orderID : Int?
    var dictDetail = [String : AnyObject]()

  
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
        self.loadOrderDetail()
    }
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = COrderSummary
    }
    
    func setOrderDetail() {
        
        arrOrderList.removeAll()
        arrOrderPrice.removeAll()
        
        scrollVW.isHidden = false
        vwRateOrder.isHidden = false
        
        lblResName.text = dictDetail.valueForString(key: CRestaurant_name)
        lblResLocation.text = dictDetail.valueForString(key: CAddress)
        lblOrderID.text = dictDetail.valueForString(key: COrder_no)
      
        imgVRest.sd_setShowActivityIndicatorView(true)
        imgVRest.sd_setImage(with: URL(string: (dictDetail.valueForString(key: CRestaurant_image))), placeholderImage: nil)
        
        if dictDetail.valueForString(key: CNote) == "" {
            vwOrderNote.hide(byHeight: true)
            lblNote.text = ""
        } else {
            lblNote.text = dictDetail.valueForString(key: CNote)
        }
        
        
        if dictDetail.valueForInt(key: COrder_status) == COrderStatusComplete {
            //... If order is completed
            
            self.btnViewMap.hide(byHeight: true)
            self.imgVOrderStatus.hide(byHeight: true)
            self.vwOrderNote.hide(byHeight: true)
            _ = tblOrderPrice.setConstraintConstant(0, edge: .top, ancestor: true)

//            DispatchQueue.main.async {
//
//                self.vwRestDetail.layoutSubviews()
//                self.view.layoutIfNeeded()
//            }

            
            if (dictDetail.valueForString(key: "rating")) == "" {
                scrollVW.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
                vwRateOrder.isHidden = false
            } else {
                scrollVW.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
                vwRateOrder.isHidden = true
            }
            
           
            let dateFormat = DateFormatter()
            lblContact.text =  dateFormat.string(timestamp: dictDetail.valueForDouble(key: COrder_completed)!, dateFormat: "MMM dd, yyyy' at 'hh:mm a")
            lblOrderStatus.text = ""
            imgVContact.image = UIImage(named: "calender")

        } else {
           
            imgVContact.image = UIImage(named: "mobile")
            
            let contactNo = dictDetail.valueForJSON(key: CContact_number) as! [String]
            lblContact.text = contactNo.joined(separator: ",\n")
            
            switch (dictDetail.valueForInt(key: COrder_status)) {
                
            case COrderStatusPending :
                lblOrderStatus.text = COrderPending
            case COrderStatusAccept:
                lblOrderStatus.text = COrderAccepted
            case COrderStatusReject:
                lblOrderStatus.text = COrderRejected
            case COrderStatusReady:
                lblOrderStatus.text = COrderReady
            default:
                lblOrderStatus.text = ""
            }
            
            
            scrollVW.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
            vwRateOrder.isHidden = true
        }
        
       
        arrOrderList = dictDetail.valueForJSON(key: "dish") as! [[String : AnyObject]]
        let arrAD = dictDetail.valueForJSON(key: "additional_charge") as![[String : AnyObject]]
        
        arrOrderPrice.append(["title":"Subtotal" as AnyObject,"value": dictDetail.valueForDouble(key: CSubtotal) as AnyObject])
        arrOrderPrice.append(["title":"Tax(\(dictDetail.valueForDouble(key: CTax_percent) ?? 0.0)%)" as AnyObject,"value": dictDetail.valueForDouble(key: CTax_amount)  as AnyObject])

        for adCharge in arrAD {
            
            arrOrderPrice.append(["title":adCharge.valueForString(key: "tax_name") as AnyObject,"value": adCharge.valueForString(key: "order_tax_amount") as AnyObject])
        }

        arrOrderPrice.append(["title":"To Pay" as AnyObject,"value": dictDetail.valueForDouble(key: COrder_total) as AnyObject])

        
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
        
        UIApplication.shared.open(URL(string: "https://maps.google.com/?q=\(dictDetail.valueForDouble(key: CLatitude)!),\(dictDetail.valueForDouble(key: CLongitude)!)")!, options: [:], completionHandler: nil)
    }
   
    @IBAction func btnRateOrderClicked(sender:UIButton){
       
        if let rateVC = COrder_SB.instantiateViewController(withIdentifier: "RateOrderViewController") as? RateOrderViewController {
            
            rateVC.dict = [COrderID : self.orderID as Any,
                           CRestaurant_name : dictDetail.valueForString(key: CRestaurant_name) as Any,
                           COrder_completed : self.lblContact.text as Any,
                           CRestaurant_image : dictDetail.valueForString(key: CRestaurant_image)] as [String : AnyObject]
            
            self.navigationController?.pushViewController(rateVC, animated: true)
        }
    }
}



//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension OrderDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView .isEqual(tblOrderDetail) ? arrOrderList.count : arrOrderPrice.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView .isEqual(tblOrderDetail) ? 81 : ((CScreenWidth * 40) / 375.0)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.isEqual(tblOrderDetail) {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell") as? OrderDetailTableViewCell {
                
                let dict = arrOrderList[indexPath.row]
                cell.lblDishName.text = dict.valueForString(key: CDish_name)
                cell.lblQuantity.text = "\(dict.valueForInt(key: CQuantity) ?? 0)"
                cell.lblPrice.text = "$\(dict.valueForDouble(key: CDish_price) ?? 0.0)"
                cell.lblTotalPrice.text = "$\(dict.valueForDouble(key: CQuantity)! * dict.valueForDouble(key: CDish_price)!)"

                cell.imgVDish.sd_setShowActivityIndicatorView(true)
                cell.imgVDish.sd_setImage(with: URL(string: dict.valueForString(key: CDish_image)), placeholderImage: nil)
                
                return cell
            }
            
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPriceTableViewCell") as? OrderPriceTableViewCell {
                
                let dict = arrOrderPrice[indexPath.row]
                cell.lblTitle.text = dict.valueForString(key: "title")
                cell.lblValue.text = "$\(dict.valueForString(key: "value"))"

                return cell
            }
        }
        
        return UITableViewCell()
    }
}


//MARK:-
//MARK:- API Method

extension OrderDetailViewController {
    
    func loadOrderDetail() {
     
        scrollVW.isHidden = true
        vwRateOrder.isHidden = true
        
        APIRequest.shared().orderDetail(order_id: self.orderID) { (response, error) in
        
            if response != nil && error == nil {
                
                let dataRes = ((response?.value(forKey: CJsonData) as! [AnyObject])[0]) as! [String : AnyObject]
                self.dictDetail = dataRes
                self.setOrderDetail()
            }
        }
    }
}


