//
//  PaymentSuccessViewController.swift
//  TAP
//
//  Created by mac-00017 on 15/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class PaymentSuccessViewController: ParentViewController {

    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var lblOrderID : UILabel!
    @IBOutlet weak var lblTranscationID : UILabel!

    var dictPayment = [String :AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        appDelegate?.hideTabBar()
    }
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = CPaymentSuccess
        
        lblPrice.text = "\(CPaymentMessage1) $\(dictPayment.valueForDouble(key: COrder_total) ?? 0.0) \(CPaymentMessage2)"
        lblOrderID.text = "\(dictPayment.valueForInt(key: COrder_no) ?? 0)"
        lblTranscationID.text = "\(dictPayment.valueForString(key: CTranscation_id))"
    }
}

//MARK:-
//MARK:- Action

extension PaymentSuccessViewController {
    
    @IBAction func btnViewOrderDetailClicked(sender : UIButton) {
        
        if let detailVC = COrder_SB.instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController {
            
            detailVC.orderID = dictPayment.valueForInt(key: COrderID)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}
