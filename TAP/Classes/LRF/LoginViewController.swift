//
//  LoginViewController.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class LoginViewController: ParentViewController {

    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPassword : GenericTextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()

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
        
        txtPassword.addTarget(self, action: #selector(self.textFieldEditingChange(_:)),
                                 for: UIControlEvents.editingChanged)
    }

}

//MARK:-
//MARK:- Action

extension LoginViewController {
    
    @objc func textFieldEditingChange(_ textField: UITextField) {
        txtPassword.customPasswordPattern(textField: textField)
    }
    
    @IBAction func btnLoginClicked(sender : UIButton) {
        
    }
    
    @IBAction func btnGuestUserClicked(sender : UIButton) {
        
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
