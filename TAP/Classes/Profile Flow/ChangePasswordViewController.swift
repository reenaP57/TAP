//
//  ChangePasswordViewController.swift
//  TAP
//
//  Created by mac-00017 on 16/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class ChangePasswordViewController: ParentViewController {
    
    @IBOutlet weak var txtOldPwd : GenericTextField!
    @IBOutlet weak var txtNewPwd : GenericTextField!
    @IBOutlet weak var txtConfirmPwd : GenericTextField!
    
    
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
        self.title = CChangePassword
    }
    
}


//MARK:-
//MARK:- General Method


extension ChangePasswordViewController {
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        
        if sender == txtOldPwd {
           _ = txtOldPwd.customPasswordPattern(textField: sender)
        } else if sender == txtNewPwd {
          _ = txtNewPwd.customPasswordPattern(textField: sender)
        } else {
           _ = txtConfirmPwd.customPasswordPattern(textField: sender)
        }
    }

    @IBAction func btnUpdateClicked(sender : UIButton) {
        
        if (txtOldPwd.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankOldPassword, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if (txtNewPwd.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankNewPassword, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if (txtNewPwd.text?.count)! < 6 || (txtNewPwd.text?.isAlphanumeric)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CInvalidPasswordMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if (txtConfirmPwd.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankConfirmPasswordMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if txtNewPwd.text != txtConfirmPwd.text {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMisMatchMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
