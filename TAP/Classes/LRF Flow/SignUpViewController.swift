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
    @IBOutlet weak var txtCountryCode : UITextField!{
        didSet {
            txtCountryCode.setPickerData(arrPickerData: ["+91","+65","+79"], selectedPickerDataHandler: { (selecte, index, component) in
            }, defaultPlaceholder: "")
        }
    }
    
    @IBOutlet weak var txtPassword : GenericTextField!
    @IBOutlet weak var txtConfirmPassword : GenericTextField!
    @IBOutlet weak var imgVProfile : UIImageView!

    var isFromProfileLogin : Bool = false
    
    fileprivate var imgData = Data()

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
        
        
        txtPassword.addTarget(self, action: #selector(self.textFieldEditingChange(_:)),
                              for: UIControlEvents.editingChanged)
        txtConfirmPassword.addTarget(self, action: #selector(self.textFieldEditingChange(_:)),
                              for: UIControlEvents.editingChanged)
    }

}

//MARK:-
//MARK:- Action

extension SignUpViewController {
    
    @objc func textFieldEditingChange(_ textField: UITextField) {
        
        if textField == txtPassword {
            txtPassword.customPasswordPattern(textField: textField)
        } else {
            txtConfirmPassword.customPasswordPattern(textField: textField)
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
        
        if isFromProfileLogin {
            self.navigationController?.popViewController(animated: true)
            
        } else {
            if let selectLocVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController {
                
                self.navigationController?.pushViewController(selectLocVC, animated: false)
            }
        }
  
    }
    
    @IBAction func btnTermsAndConditionClicked(sender : UIButton) {
        
    }
}
