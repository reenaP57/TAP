//
//  SignUpViewController.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

let USAID = 840
let BrazilID = 76

class SignUpViewController: ParentViewController {

    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtFullName : UITextField!
    @IBOutlet weak var txtMobileNo : UITextField!
    @IBOutlet weak var txtCountryCode : UITextField!
    @IBOutlet weak var txtPassword : GenericTextField!
    @IBOutlet weak var txtConfirmPassword : GenericTextField!
    @IBOutlet weak var imgVProfile : UIImageView!
    @IBOutlet weak var lblLogin : UILabel!
    @IBOutlet weak var lblTermsCondition : UILabel!
   
    var arrCountry = [TblCountryList?]()
    fileprivate var imgData = Data()
    var strPwd = String()
    var strConfirmPwd = String()
    var isFromProfileScreen : Bool?
    var countryID = 0
    
    
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
        
        self.setAtttibuteString()
        self.setTermsConditionString()
        
       let arrUSA = TblCountryList.fetch(predicate: NSPredicate(format: "%K == %d",CCountry_id, USAID), orderBy: CCountry_name, ascending: true) as? [TblCountryList]
        let arrBrazil = TblCountryList.fetch(predicate: NSPredicate(format: "%K == %d",CCountry_id, BrazilID), orderBy: CCountry_name, ascending: true) as? [TblCountryList]
        
        arrCountry = (TblCountryList.fetchAllObjects() as! [TblCountryList?]).sorted(by: {($0?.country_with_code)! < ($1?.country_with_code)!})
        
        if let index = arrCountry.index(where: {$0?.country_id == 840}){
          arrCountry.remove(at: index)
        }
        
        if let index = arrCountry.index(where: {$0?.country_id == 76}){
            arrCountry.remove(at: index)
        }
        
        if var arrTemp = (arrCountry.map({$0?.country_with_code}) as? [String])?.sorted(by: {$0 < $1}){
            
            if (arrUSA?.count)! > 0{
                let usaInfo = arrUSA?[0]
                arrCountry.insert(usaInfo, at: 0)
                arrTemp.insert((usaInfo?.country_with_code)!, at: 0)
            }
            
            if (arrBrazil?.count)! > 0{
                let brazilInfo = arrBrazil?[0]
                arrCountry.insert(brazilInfo, at: 1)
                arrTemp.insert((brazilInfo?.country_with_code)!, at: 1)
                
            }
            
            if (arrTemp.count) > 0 {
                txtCountryCode.setPickerData(arrPickerData: arrTemp, selectedPickerDataHandler: { (select, index, component) in
                    
                    print(self.arrCountry.count)
                    if self.arrCountry.count > 0{
                        let countryInfo = self.arrCountry[index]
                        let countryId: Int16 = (countryInfo?.country_id)!
                        self.countryID = Int(countryId)
                        self.txtCountryCode.text = countryInfo?.country_code
                    }
                    
                }, defaultPlaceholder: "")
            }
        }

    }

    func setAtttibuteString() {
        
       let textAttributesOne = [NSAttributedStringKey.foregroundColor: CColorLightGray, NSAttributedStringKey.font:CFontSFUIText(size: 14.0, type: .Regular)]
        let textAttributesTwo = [NSAttributedStringKey.foregroundColor: CColorNavRed, NSAttributedStringKey.font: CFontSFUIText(size: 14.0, type: .SemiBold)]
        
        let textPartOne = NSMutableAttributedString(string: CAlreadyHaveAnAccount, attributes: textAttributesOne)
        let textPartTwo = NSMutableAttributedString(string: CLogin, attributes: textAttributesTwo)
        
        let textCombination = NSMutableAttributedString()
        textCombination.append(textPartOne)
        textCombination.append(textPartTwo)
        
        self.lblLogin.attributedText = textCombination
    }
    
    func setTermsConditionString() {
        
        let textAttributesOne = [NSAttributedStringKey.foregroundColor: CColorLightGray, NSAttributedStringKey.font:CFontSFUIText(size: 14.0, type: .Regular)]
        let textAttributesTwo = [NSAttributedStringKey.foregroundColor: CColorNavRed, NSAttributedStringKey.font: CFontSFUIText(size: 14.0, type: .SemiBold)]
        let textAttributesThree = [NSAttributedStringKey.foregroundColor: CColorLightGray, NSAttributedStringKey.font:CFontSFUIText(size: 14.0, type: .Regular)]

        let textPartOne = NSMutableAttributedString(string: CSignupTermsConditionMsg, attributes: textAttributesOne)
        let textPartTwo = NSMutableAttributedString(string:CTermsConditions , attributes: textAttributesTwo)
        let textPartThree = NSMutableAttributedString(string: CSignupTermsConditionMsg2, attributes: textAttributesThree)

        let textCombination = NSMutableAttributedString()
        textCombination.append(textPartOne)
        textCombination.append(textPartTwo)
        textCombination.append(textPartThree)

        self.lblTermsCondition.attributedText = textCombination
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
                self.imgVProfile.image = selectedImage
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
