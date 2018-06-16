//
//  LoginViewController.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

enum loginFromType {
    case FromPopup
    case FromSelectLangugae
}


class LoginViewController: ParentViewController {

    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPassword : GenericTextField!
    
    var loginFrom = loginFromType.FromSelectLangugae
    
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
        
        _ = txtPassword.customPasswordPattern(textField: sender)
    }
    
    @IBAction func btnLoginClicked(sender : UIButton) {
      /*
        if (txtEmail.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankEmailMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if (txtPassword.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankPasswordMessage, btnOneTitle:COk , btnOneTapped: nil)

        } else {
          */
            if loginFrom == .FromPopup {
                self.navigationController?.popViewController(animated: true)
                
            } else {
                
                if let selectLocVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController {
                    self.navigationController?.pushViewController(selectLocVC, animated: false)
                }
            }
       // }
    }
    
    @IBAction func btnGuestUserClicked(sender : UIButton) {
        
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
            
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
}
