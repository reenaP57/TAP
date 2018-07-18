//
//  SignUpViewController.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SignUpViewController: ParentViewController {

    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtFullName : UITextField!
    @IBOutlet weak var txtMobileNo : UITextField!
    @IBOutlet weak var txtCountryCode : UITextField!
    @IBOutlet weak var txtPassword : GenericTextField!
    @IBOutlet weak var txtConfirmPassword : GenericTextField!
    @IBOutlet weak var imgVProfile : UIImageView!

    fileprivate var imgData = Data()
    var strPwd = String()
    var strConfirmPwd = String()
    var isFromProfileScreen : Bool?
    var countryID = Int()
    
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        self.view.layoutIfNeeded()
        imgVProfile.layer.cornerRadius = imgVProfile.CViewHeight/2
        imgVProfile.layer.masksToBounds = true
    }
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = CSignUp
        
        let arrCountry = TblCountryList.fetch(predicate: nil, orderBy: CCountry_name, ascending: true)
        let arrCountryCode = arrCountry?.value(forKeyPath: "country_with_code") as? [Any]
        
        if (arrCountryCode?.count)! > 0 {

            txtCountryCode.setPickerData(arrPickerData: arrCountryCode!, selectedPickerDataHandler: { (select, index, component) in

                 let dict = arrCountry![index] as AnyObject
                 countryID = dict.value(forKey: CCountry_id) as! Int
                txtCountryCode.text = dict.value(forKey: CCountry_code) as? String
            }, defaultPlaceholder: "")
        }
    }

}

//MARK:-
//MARK:- Action

extension SignUpViewController {
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        
        if sender == txtPassword {
           strPwd = txtPassword.customPasswordPattern(textField: sender)
        } else {
           strConfirmPwd = txtConfirmPassword.customPasswordPattern(textField: sender)
        }
    }
    
    @IBAction func focusOnTextfield(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            txtFullName.becomeFirstResponder()
        case 1:
            txtEmail.becomeFirstResponder()
        case 2:
            txtMobileNo.becomeFirstResponder()
        case 3:
            txtPassword.becomeFirstResponder()
        default:
            txtConfirmPassword.becomeFirstResponder()
        }
    }
    
    @IBAction func btnLoginClicked(sender : UIButton) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUploadProfileClicked(sender : UIButton) {
        
        self.presentImagePickerController(allowEditing: true) { (image, info) in
            
            if let selectedImage = image {
                imgVProfile.image = selectedImage
                self.imgData = UIImageJPEGRepresentation(selectedImage, 0.5)!
            }
        }
    }
    
    @IBAction func btnSingupClicked(sender : UIButton) {
      
        if (txtFullName.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankFullNameMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if (txtEmail.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankEmailMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if !(txtEmail.text?.isValidEmail)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CInvalidEmailMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if !(txtMobileNo.text?.isBlank)! &&
            ((txtMobileNo.text?.count)! > 10 || (txtMobileNo.text?.count)! < 10)  {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CValidMobileNo, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if !(txtMobileNo.text?.isBlank)! && (txtCountryCode.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankCountryCodeMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if (txtPassword.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankPasswordMessage, btnOneTitle:COk , btnOneTapped: nil)
        
        } else if !(strPwd.isValidPassword) {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CInvalidPasswordMessage, btnOneTitle:COk , btnOneTapped: nil)
       
        } else if (txtConfirmPassword.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankConfirmPasswordMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if strPwd != strConfirmPwd {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMisMatchMessage, btnOneTitle:COk , btnOneTapped: nil)
       
        } else {
            self.signUp()
        }
    }
    
    @IBAction func btnTermsAndConditionClicked(sender : UIButton) {
        
        if let cmsVC = CProfile_SB.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
            
            cmsVC.cmsEnum = .TermsCondition
            self.navigationController?.pushViewController(cmsVC, animated: true)
        }
    }
}


//MARK:-
//MARK:- API methods

extension SignUpViewController {
    
    func signUp() {
        
        var dict = [String : AnyObject]()
        
        dict[CName] = txtFullName.text as AnyObject
        dict[CEmail] = txtEmail.text as AnyObject
        dict[CPassword] = strPwd as AnyObject
            
        if txtMobileNo.text != "" {
            dict[CMobile_no] = (txtMobileNo.text ?? "") as AnyObject
            dict[CCountry_id] = countryID as AnyObject
        }
        
        
        APIRequest.shared().signUp(dict, _imgData: imgData) { (response, error) in
            
            if response != nil && error == nil {
                
                print("Response : ",response as Any)
                
                APIRequest.shared().saveUserDetailToLocal(response: response as! [String : AnyObject])
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                let message  = metaData.valueForString(key: CJsonMessage)
                let status = metaData.valueForInt(key: CJsonStatus)
                
                if status == CStatusFour {
                    
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: COk, btnOneTapped: { (action) in
                        self.navigateScreen()
                    })
    
                } else {
                    self.navigateScreen()
                }
            }
        }
    }
    
    func navigateScreen() {
     
        if (appDelegate?.isFromLoginPop)! || self.isFromProfileScreen!
        {
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                
                if self.isFromProfileScreen! {
                    loginVC.loginFrom = .FromProfileLogin
                }
                self.navigationController?.pushViewController(loginVC, animated: false)
            }
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
