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
    @IBOutlet weak var btnCountiueGuest : UIButton?
    @IBOutlet weak var lblDontAccount : UILabel!
    @IBOutlet weak var btnBack : UIButton!

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
        
        if (appDelegate?.isFromLoginPop)!
        {
            //...From Login popup
            if appDelegate?.objNavController != nil {
                btnCountiueGuest?.hide(byHeight: true)
                btnBack.isHidden = false
            }
        }
        
        if  self.loginFrom == .FromProfileLogin {
            btnCountiueGuest?.hide(byHeight: true)
            btnBack.isHidden = false
        }
        
        
        if IS_iPhone_Simulator {
            txtEmail.text = "bhavika.mi@mailinator.com"
            //txtPassword.text = "abc1234"
        }
        self.setAtttibuteString()
    }
    
    func setAtttibuteString() {
        
        let textAttributesOne = [NSAttributedStringKey.foregroundColor: CColorLightGray, NSAttributedStringKey.font:CFontSFUIText(size: 14.0, type: .Regular)]
        let textAttributesTwo = [NSAttributedStringKey.foregroundColor: CColorNavRed, NSAttributedStringKey.font: CFontSFUIText(size: 14.0, type: .SemiBold)]
        
        let textPartOne = NSMutableAttributedString(string: CDontHaveAnAccount, attributes: textAttributesOne)
        let textPartTwo = NSMutableAttributedString(string: CSignUp, attributes: textAttributesTwo)
        
        let textCombination = NSMutableAttributedString()
        textCombination.append(textPartOne)
        textCombination.append(textPartTwo)
       
        self.lblDontAccount.attributedText = textCombination
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
            self.loginUser()
        }
    }
    
    @IBAction func btnGuestUserClicked(sender : UIButton) {
        
        TblRecentLocation.deleteAllObjects()
//        CUserDefaults.removeObject(forKey: UserDefaultCurrentLocation)
//        CUserDefaults.removeObject(forKey: CLatitude)
//        CUserDefaults.removeObject(forKey: CLongitude)

        
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
    
    @IBAction func btnBackClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK:-
//MARK:- API method

extension LoginViewController {
    
    func loginUser() {
        
        APIRequest.shared().login(_email: txtEmail.text, _password: strPwd) { (response, error) in
        
            if response != nil && error == nil {
                
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                let status = metaData.valueForInt(key: CJsonStatus)
                let message = metaData.valueForString(key: CJsonMessage)

                if status == CStatusFour {
                    
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: COk, btnOneTapped: { (action) in
                    })
                    
                } else {
                    
                    APIRequest.shared().saveUserDetailToLocal(response: response as! [String : AnyObject])
                    
                    MIOneSignal.shared().registerDeviceTokenForNotification()
                    
                    let dataRes = response?.value(forKey: CJsonData) as! [String : AnyObject]
                    
                    if dataRes.valueForString(key: CCart_id) != "" && CUserDefaults.object(forKey: UserDefaultCartID) != nil {
                        appDelegate?.loadCartDetail()
                    }
                  
                    
                    if (appDelegate?.isFromLoginPop)!
                    {
                        //...From Login popup
                        if appDelegate?.objNavController != nil
                        {
                            appDelegate?.isFromLoginPop = false
                           
                            NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationUpdateTabbar), object: nil)
                       
                            
                            if (appDelegate?.tabbar?.btnOrder.isSelected)! {
                                appDelegate?.tabbarController?.selectedIndex = 2
                                appDelegate?.tabbar?.btnOrder.isSelected = true
                                appDelegate?.tabbar?.btnHome.isSelected = false
                            } else {
                                appDelegate?.tabbarController?.selectedIndex = 0
                                appDelegate?.tabbar?.btnOrder.isSelected = false
                                appDelegate?.tabbar?.btnHome.isSelected = true
                            }
                            
                        self.navigationController?.popToViewController((appDelegate?.objNavController)!, animated: false)
                        }
                        
                    } else if self.loginFrom == .FromProfileLogin {
                        //... When user signup from profile Login screen
                        
                        if appDelegate?.tabbarController?.selectedIndex == 4 {
                            appDelegate?.tabbarController = TabbarViewController.initWithNibName() as? TabbarViewController
                            appDelegate?.tabbarController?.selectedIndex = 4
                            appDelegate?.tabbar?.btnProfile.isSelected = true
                            appDelegate?.tabbar?.btnHome.isSelected = false
                            appDelegate?.window?.rootViewController = appDelegate?.tabbarController
                        } else if appDelegate?.tabbarController?.selectedIndex == 2{
                            appDelegate?.tabbarController = TabbarViewController.initWithNibName() as? TabbarViewController
                            appDelegate?.tabbarController?.selectedIndex = 2
                            appDelegate?.tabbar?.btnProfile.isSelected = false
                            appDelegate?.tabbar?.btnHome.isSelected = false
                            appDelegate?.tabbar?.btnOrder.isSelected = true

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
        }
    }
}
