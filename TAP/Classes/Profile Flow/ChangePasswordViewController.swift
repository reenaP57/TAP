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
    
    var strPwd = String()
    var strNewPwd = String()
    var strConfirmPwd = String()

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
    
    @IBAction func focusOnTextfield(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            txtOldPwd.becomeFirstResponder()
        case 1:
            txtNewPwd.becomeFirstResponder()
        default:
            txtConfirmPwd.becomeFirstResponder()
        }
    }
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        
        if sender == txtOldPwd {
            strPwd = txtOldPwd.customPasswordPattern(textField: sender)
        } else if sender == txtNewPwd {
            strNewPwd = txtNewPwd.customPasswordPattern(textField: sender)
        } else {
            strConfirmPwd = txtConfirmPwd.customPasswordPattern(textField: sender)
        }
    }

    @IBAction func btnUpdateClicked(sender : UIButton) {
        
        if (txtOldPwd.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankOldPassword, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if (txtNewPwd.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankNewPassword, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if !(strNewPwd.isValidPassword) {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CInvalidPasswordMessage, btnOneTitle:COk , btnOneTapped: nil)

        } else if (txtConfirmPwd.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankConfirmPasswordMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if strNewPwd != strConfirmPwd {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMisMatchMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else {
            self.changePassword()
        }
    }
}


//MARK:-
//MARK:- API Method

extension ChangePasswordViewController {
    
    func changePassword() {
        
        APIRequest.shared().changePassword(oldPwd: strPwd, newPwd: strNewPwd) { (response, error) in
        
            if response != nil && error == nil {
                self.navigationController?.popViewController(animated: true)
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessaseChangePassword, btnOneTitle: COk, btnOneTapped: { (action) in
                })
            }
            
        }
    }
}
