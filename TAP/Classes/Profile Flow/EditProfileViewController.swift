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
    @IBOutlet weak var txtCountryCode : UITextField!{
        didSet {
            txtCountryCode.setPickerData(arrPickerData: ["+91","+65","+79"], selectedPickerDataHandler: { (selecte, index, component) in
            }, defaultPlaceholder: "")
        }
    }
    
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
        
        vwImgProfile.layer.cornerRadius = vwImgProfile.CViewHeight / 2
        imgVProfile.layer.cornerRadius = imgVProfile.CViewHeight / 2
        
        vwImgProfile.layer.masksToBounds = true
        imgVProfile.layer.masksToBounds = true
    }
    
  
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = CEditProfile
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
               // self.imgData = UIImageJPEGRepresentation(selectedImage, 0.5)!
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
            self.navigationController?.popViewController(animated: true)
        }
    }
}
