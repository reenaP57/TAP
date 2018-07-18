//
//  EditProfileViewController.swift
//  TAP
//
//  Created by mac-00017 on 15/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class EditProfileViewController: ParentViewController {

    @IBOutlet weak var txtName : UITextField!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtMobileNo : UITextField!
    @IBOutlet weak var txtCountryCode : UITextField!

    @IBOutlet weak var imgVProfile : UIImageView!{
        didSet {
            imgVProfile.layer.cornerRadius = imgVProfile.CViewHeight/2
            imgVProfile.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var vwImgProfile : UIView!{
        didSet {
            vwImgProfile.layer.cornerRadius = vwImgProfile.CViewHeight/2
            vwImgProfile.layer.masksToBounds = true
        }
    }

    fileprivate var imgData = Data()
    var isPicUpdated : Bool = false
    var countryID = Int()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.layoutIfNeeded()
        vwImgProfile.layer.cornerRadius = vwImgProfile.CViewHeight / 2
        imgVProfile.layer.cornerRadius = imgVProfile.CViewHeight / 2
        
        vwImgProfile.layer.masksToBounds = true
        imgVProfile.layer.masksToBounds = true
    }
    
  
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = CEditProfile
        
        let arrCountry = TblCountryList.fetch(predicate: nil, orderBy: "country_name", ascending: false)
        let arrCountryCode = arrCountry?.value(forKeyPath: "country_with_code") as? [Any]
        
        if (arrCountryCode?.count)! > 0 {
            
            txtCountryCode.setPickerData(arrPickerData: arrCountryCode!, selectedPickerDataHandler: { (select, index, component) in
                
                let dict = arrCountry![index] as AnyObject
                countryID = dict.value(forKey: "country_id") as! Int
                
                let countryCode = dict.value(forKey: "country_code") as? String
                
                if countryCode?.first == "+" {
                    txtCountryCode.text = countryCode
                } else{
                    txtCountryCode.text = "+\(countryCode ?? "")"
                }
                
            }, defaultPlaceholder: "")
        }
        
        self.prefilledUserDetail()
    }

    func getCountryCodeFromId() -> String
    {
        var countryCode = ""
        
        let arrCountry = TblCountryList.fetch(predicate: NSPredicate(format: "%K == %d", "country_id", (appDelegate?.loginUser?.country_id)!), orderBy: "country_name", ascending: true)
        if (arrCountry?.count)! > 0
        {
            let objCountry = arrCountry![0] as? TblCountryList
            countryCode = (objCountry?.country_code!)!
        }
      
        return countryCode
    }
    
    func prefilledUserDetail() {
        
        txtName.text = appDelegate?.loginUser?.name
        txtEmail.text = appDelegate?.loginUser?.email
        
        if appDelegate?.loginUser?.mobile_no != "" {
            
            let firstLetter = self.getCountryCodeFromId().first
            
            if firstLetter == "+" {
                txtCountryCode.text = self.getCountryCodeFromId()
            } else{
                txtCountryCode.text = "+\(self.getCountryCodeFromId())"
            }
            
            countryID = Int((appDelegate?.loginUser?.country_id)!)
            txtMobileNo.text = appDelegate?.loginUser?.mobile_no
        }
        
        if appDelegate?.loginUser?.profile_image != nil {
            imgVProfile.sd_setImage(with: URL(string: (appDelegate?.loginUser?.profile_image)!), placeholderImage: nil)
            imgData = UIImageJPEGRepresentation(imgVProfile.image!, 0.5)!
        }
        
    }
}


//MARK:-
//MARK:- General Method


extension EditProfileViewController {
    
    @IBAction func focusOnTextfield(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            txtName.becomeFirstResponder()
        case 1:
            txtEmail.becomeFirstResponder()
        default:
            txtMobileNo.becomeFirstResponder()
        }
    }
    
    
    @IBAction func btnUploadProfileClicked(sender : UIButton) {
        
        self.presentImagePickerController(allowEditing: true) { (image, info) in
            
            if let selectedImage = image {
                imgVProfile.image = selectedImage
                self.imgData = UIImageJPEGRepresentation(selectedImage, 0.5)!
                isPicUpdated = true
            }
        }
    }
    
    @IBAction func btnUpdateClicked(sender : UIButton) {
        
        if (txtName.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankFullNameMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if !(txtMobileNo.text?.isBlank)! &&
            ((txtMobileNo.text?.count)! > 10 || (txtMobileNo.text?.count)! < 10)  {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CValidMobileNo, btnOneTitle:COk , btnOneTapped: nil)
            
        } else if !(txtMobileNo.text?.isBlank)! && (txtCountryCode.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankCountryCodeMessage, btnOneTitle:COk , btnOneTapped: nil)
            
        } else {
            self.editProfile()
        }
    }
}


//MARK:-
//MARK:-  API Method

extension EditProfileViewController {
    
    func editProfile() {
        
        var dict = [String : AnyObject]()
        
        dict[CName] = txtName.text as AnyObject
        
        if txtMobileNo.text != "" {
            dict[CMobile_no] = txtMobileNo.text as AnyObject
            dict[CCountry_id] = countryID as AnyObject
        }
        
        APIRequest.shared().editProfile(_param: dict, _imgData: imgData) { (response, error) in
        
            if response != nil && error == nil {
                
                print(response as Any)
                
                APIRequest.shared().saveUserDetailToLocal(response: response as! [String : AnyObject])
                
                self.navigationController?.popViewController(animated: true)
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessaseProfileUpdated, btnOneTitle: COk, btnOneTapped: { (action) in
                })
            }
        }
    }
}
