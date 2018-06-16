//
//  SignUpViewController.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

enum signUpFromType {
    case FromPopup
    case FromLogin
}

class SignUpViewController: ParentViewController {

    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtFullName : UITextField!
    @IBOutlet weak var txtMobileNo : UITextField!
    @IBOutlet weak var txtCountryCode : UITextField!{
        didSet {
            txtCountryCode.setPickerData(arrPickerData: ["+91","+65","+79"], selectedPickerDataHandler: { (selecte, index, component) in
            }, defaultPlaceholder: "")
        }
    }
    
    @IBOutlet weak var txtPassword : GenericTextField!
    @IBOutlet weak var txtConfirmPassword : GenericTextField!
    @IBOutlet weak var imgVProfile : UIImageView!

    fileprivate var imgData = Data()
    var signupFrom = signUpFromType.FromLogin

   
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
    }

}

//MARK:-
//MARK:- Action

extension SignUpViewController {
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        
        if sender == txtPassword {
           _ = txtPassword.customPasswordPattern(textField: sender)
        } else {
           _ = txtConfirmPassword.customPasswordPattern(textField: sender)
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
      /*
        if (txtFullName.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankFullNameMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if (txtEmail.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankEmailMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if !(txtEmail.text?.isValidEmail)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CInvalidEmailMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if !(txtMobileNo.text?.isBlank)! && (txtCountryCode.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankCountryCodeMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if (txtPassword.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankPasswordMessage, btnOneTitle:COk , btnOneTapped: nil)
        
        } else if (txtPassword.text?.count)! < 6 || (txtPassword.text?.isAlphanumeric)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CInvalidPasswordMessage, btnOneTitle:COk , btnOneTapped: nil)
       
        } else if txtPassword.text != txtConfirmPassword.text {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMisMatchMessage, btnOneTitle:COk , btnOneTapped: nil)
       
        } else {
            */
            if signupFrom == .FromPopup {
                self.navigationController?.popViewController(animated: true)
                
            } else {
                if let selectLocVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController {
                    
                    self.navigationController?.pushViewController(selectLocVC, animated: false)
                }
            }
       // }
    }
    
    @IBAction func btnTermsAndConditionClicked(sender : UIButton) {
        
        if let cmsVC = CProfile_SB.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
            
            cmsVC.cmsEnum = .TermsCondition
            self.navigationController?.pushViewController(cmsVC, animated: true)
        }
    }
}
