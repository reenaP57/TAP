//
//  ForgotPasswordViewController.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: ParentViewController {

    @IBOutlet weak var txtEmail : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = CForgotPassword
    }
}


//MARK:-
//MARK:- Action

extension ForgotPasswordViewController {
    
    @IBAction func btnSubmitClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
