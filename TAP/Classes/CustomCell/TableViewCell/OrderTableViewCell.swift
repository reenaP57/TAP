//
//  OrderTableViewCell.swift
//  TAP
//
//  Created by mac-00017 on 14/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVDish : UIImageView!
    @IBOutlet weak var lblResName : UILabel!
    @IBOutlet weak var lblCuisineOrdered : UILabel!
    @IBOutlet weak var lblResLocation : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var lblAmount : UILabel!
    @IBOutlet weak var lblOrderStatus : UILabel!
    @IBOutlet weak var imgVOrderStatus : UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgVDish.layer.cornerRadius = 5
        imgVDish.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
