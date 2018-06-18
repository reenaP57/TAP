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
    }
}

//MARK:-
//MARK:- Action

extension PaymentSuccessViewController {
    
    @IBAction func btnViewOrderDetailClicked(sender : UIButton) {
        
        if let detailVC = CMain_SB.instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}
