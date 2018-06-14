//
//  SearchRestaurantTableViewCell.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SearchRestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var lblRestName : UILabel!
    @IBOutlet weak var lblRating : UILabel!
    @IBOutlet weak var lblResLocation : UILabel!
    @IBOutlet weak var lblCuisines : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    
    @IBOutlet weak var lblClosed : UILabel!{
        didSet{
            lblClosed.layer.cornerRadius = lblClosed.CViewHeight/2
            lblClosed.layer.masksToBounds = true
        }
    }
    
    
    @IBOutlet weak var imgVRest : UIImageView!{
        didSet{
            imgVRest.layer.cornerRadius = 5
            imgVRest.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var vwRating : RatingView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
