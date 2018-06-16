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
    @IBOutlet weak var lblquantity : UILabel!
    @IBOutlet weak var lblCuisine : UILabel!
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
    }

}
