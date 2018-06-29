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
    
    @IBAction func focusOnTextfield(_ sender: UIButton) {
        txtEmail.becomeFirstResponder()
    }
    
    @IBAction func btnSubmitClicked(sender : UIButton) {
        
        if (txtEmail.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankEmailMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if !(txtEmail.text?.isValidEmail)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CInvalidEmailMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else {
            
            APIRequest.shared().forgotPasswrd(_email: txtEmail.text!) { (response, error) in
            
                if response != nil && error == nil {
                    
                    let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                    let message = metaData.valueForString(key: CJsonMessage)
                    
                    self.navigationController?.popViewController(animated: true)
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: message)
                }
            }
        }
    }
}
