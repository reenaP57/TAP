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
    @IBOutlet weak var imgVProfile : UIImageView!
    @IBOutlet weak var vwImgProfile : UIView!

    
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
    
    @IBAction func btnUploadProfileClicked(sender : UIButton) {
        
    }
    
    @IBAction func btnUpdateClicked(sender : UIButton) {
        
    }
}
