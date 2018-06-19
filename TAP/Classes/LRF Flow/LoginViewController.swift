//
//  LoginViewController.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

enum loginFromType {
    case FromSelectLangugae
    case FromProfileLogin
    
}


class LoginViewController: ParentViewController {

    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPassword : GenericTextField!
    
    var loginFrom = loginFromType.FromSelectLangugae
    var strPwd = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate?.hideTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

    //MARK:-
    //MARK:- General Method
    
    func initialize() {
    }

}

//MARK:-
//MARK:- Action

extension LoginViewController {
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        strPwd = txtPassword.customPasswordPattern(textField: sender)
    }
    
    @IBAction func focusOnTextfield(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            txtEmail.becomeFirstResponder()
        default:
            txtPassword.becomeFirstResponder()
        }
    }
    
    @IBAction func btnLoginClicked(sender : UIButton) {
      
        if (txtEmail.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankEmailMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if !(txtEmail.text?.isValidEmail)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CInvalidEmailMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if (txtPassword.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankPasswordMessage, btnOneTitle:COk , btnOneTapped: nil)

        } else {
 
            if (appDelegate?.isFromLoginPop)!
            {
                //...From Login popup
                if appDelegate?.objNavController != nil
                {
                    appDelegate?.isFromLoginPop = false
                    self.navigationController?.popToViewController((appDelegate?.objNavController)!, animated: false)
                }
                
            } else if loginFrom == .FromProfileLogin {
              //... When user signup from profile Login screen
                
                if appDelegate?.tabbarController?.selectedIndex == 4 {
                    appDelegate?.isGuestUser = false
                    appDelegate?.tabbarController = TabbarViewController.initWithNibName() as? TabbarViewController
                    appDelegate?.tabbarController?.selectedIndex = 4
                    appDelegate?.tabbar?.btnProfile.isSelected = true
                    appDelegate?.tabbar?.btnHome.isSelected = false
                    appDelegate?.window?.rootViewController = appDelegate?.tabbarController
                }

            } else {
                //... For Normal Login
                
                if let selectLocVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController {
                    self.navigationController?.pushViewController(selectLocVC, animated: false)
                }
            }
        }
    }
    
    @IBAction func btnGuestUserClicked(sender : UIButton) {
        
        appDelegate?.isGuestUser = true
        
        if let selectLocVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController {
            self.navigationController?.pushViewController(selectLocVC, animated: false)
        }
    }
    
    @IBAction func btnForgotPasswordClicked(sender : UIButton) {
        
        if let forgotPWDVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
            
            self.navigationController?.pushViewController(forgotPWDVC, animated: true)
        }
    }
    
    @IBAction func btnSingupClicked(sender : UIButton) {
        
        if let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            signUpVC.isFromProfileScreen = false
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
}
