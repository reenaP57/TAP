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
    var arrCountry = [TblCountryList?]()

    
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
        
        self.countryList()
        self.prefilledUserDetail()
    }

    func countryList() {
        
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
                        
                        let countryCode = countryInfo?.country_code

                        if countryCode?.first == "+" {
                            self.txtCountryCode.text = countryCode
                        } else{
                            self.txtCountryCode.text = "+\(countryCode ?? "")"
                        }
                    }
                    
                }, defaultPlaceholder: "")
            }
        }
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
            
            if let img = imgVProfile.image {
                imgData = UIImageJPEGRepresentation(img, 0.5)!
            }
            
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
                self.imgVProfile.image = selectedImage
                self.imgData = UIImageJPEGRepresentation(selectedImage, 0.5)!
                self.isPicUpdated = true
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
