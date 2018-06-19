//
//  ProfileLoginViewController.swift
//  TAP
//
//  Created by mac-00017 on 13/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class ProfileLoginViewController: ParentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate?.showTabBar()
    }
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {

    }
}


//MARK:-
//MARK:- Action

extension ProfileLoginViewController {
    
    @IBAction func btnChangeLangugueClicked(sender : UIButton) {
        
        if let changeLangVC = CLRF_SB.instantiateViewController(withIdentifier: "SelectLanguageViewController") as? SelectLanguageViewController {
            changeLangVC.isFromProfile = true
            self.navigationController?.pushViewController(changeLangVC, animated: true)
        }
    }
    
    @IBAction func btnLoginClicked(sender : UIButton) {
       
        if let loginVC = CLRF_SB.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            loginVC.loginFrom = .FromProfileLogin
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    @IBAction func btnSignUpClicked(sender : UIButton) {
        
        if let signUpVC = CLRF_SB.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            signUpVC.isFromProfileScreen = true
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
}
