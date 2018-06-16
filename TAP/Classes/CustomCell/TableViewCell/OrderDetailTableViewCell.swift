//
//  OrderDetailTableViewCell.swift
//  TAP
//
//  Created by mac-00017 on 14/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var lblQuantity : UILabel!
    @IBOutlet weak var lblTotalPrice : UILabel!
    @IBOutlet weak var lblDishName : UILabel!
    @IBOutlet weak var imgVDish : UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgVDish.layer.cornerRadius = 5
        imgVDish.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
