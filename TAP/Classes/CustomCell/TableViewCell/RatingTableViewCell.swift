//
//  RatingTableViewCell.swift
//  TAP
//
//  Created by mac-00017 on 13/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class RatingTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVProfile : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblReview : UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var vwRating: RatingView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgVProfile.layoutIfNeeded()
        imgVProfile.layer.cornerRadius = imgVProfile.CViewHeight/2
        imgVProfile.layer.masksToBounds = true
    }

}
