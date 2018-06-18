//
//  ProfileHeaderView.swift
//  TAP
//
//  Created by mac-00017 on 13/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    @IBOutlet weak var vwProfile : UIView!
    @IBOutlet weak var imgVProfile : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblEmail : UILabel!
    @IBOutlet weak var lblMobileNo : UILabel!
    
    override func layoutSubviews() {
        
        super.layoutSubviews()

        vwProfile.layoutIfNeeded()
        imgVProfile.layoutIfNeeded()
        vwProfile.layer.cornerRadius = vwProfile.CViewHeight/2
        vwProfile.layer.masksToBounds = true
        
        imgVProfile.layer.cornerRadius = imgVProfile.CViewHeight/2
        imgVProfile.layer.masksToBounds = true
    }
}
