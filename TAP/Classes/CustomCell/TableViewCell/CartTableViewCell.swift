//
//  CartTableViewCell.swift
//  TAP
//
//  Created by mac-00017 on 15/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDishName : UILabel!
    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var lblquantity : UILabel!
    @IBOutlet weak var imgVDish : UIImageView!
    @IBOutlet weak var btnMinus : UIButton!
    @IBOutlet weak var btnPlus : UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgVDish.layer.cornerRadius = 5
        imgVDish.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
