//
//  PromotionTableViewCell.swift
//  TAP
//
//  Created by mac-00017 on 13/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class PromotionTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVOffer : UIImageView!
    @IBOutlet weak var lblOffer : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgVOffer.layer.cornerRadius = 5
        imgVOffer.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
