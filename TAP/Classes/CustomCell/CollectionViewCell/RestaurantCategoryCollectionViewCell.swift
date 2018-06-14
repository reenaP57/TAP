//
//  RestaurantCategoryCollectionViewCell.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class RestaurantCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblCategory:GenericLabel!
    @IBOutlet weak var btnCategory: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.lblCategory.layer.cornerRadius = 15
        self.lblCategory.layer.masksToBounds = true
        
        self.lblCategory.layer.borderWidth = 1.0
        self.lblCategory.layer.borderColor = CColorCement.cgColor
    }

}
