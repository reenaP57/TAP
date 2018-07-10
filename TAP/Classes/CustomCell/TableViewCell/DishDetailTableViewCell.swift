//
//  DishDetailTableViewCell.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class DishDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDishName : UILabel!
    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var txtQuantity : UITextField!
    @IBOutlet weak var lblCuisine : UILabel!
    @IBOutlet weak var imgVDish : UIImageView!
    @IBOutlet weak var btnMinus : UIButton!
    @IBOutlet weak var btnPlus : UIButton!
    @IBOutlet weak var vwAvailable : UIView!
    @IBOutlet weak var vwQuantity : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwAvailable.layer.cornerRadius = vwAvailable.CViewHeight / 2
        imgVDish.layer.cornerRadius = 5
        
        vwAvailable.layer.masksToBounds = true
        imgVDish.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
