//
//  RestaurantDetailTopView.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class RestaurantDetailTopView: UIView {

    @IBOutlet weak var lblRestName : UILabel!
    @IBOutlet weak var lblResLocation : UILabel!
    @IBOutlet weak var lblCuisines : UILabel!
    @IBOutlet weak var lblRating : UILabel!
    @IBOutlet weak var lblClosed : UILabel!{
        didSet{
            lblClosed.layer.cornerRadius = lblClosed.CViewHeight/2
            lblClosed.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var lblRatingCount : UILabel!
    @IBOutlet weak var imgVRest : UIImageView!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var vwRating : RatingView!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnContactNo : UIButton!
    @IBOutlet weak var btnPromotion : UIButton!
    @IBOutlet weak var btnViewRating : UIButton!
    @IBOutlet weak var txtSearch : UITextField!{
        didSet{
            txtSearch.placeholder = CSearchDish
        }
    }
    @IBOutlet weak var vwDetail : UIView!
    @IBOutlet weak var vwSearch : UIView!
    @IBOutlet weak var vwTop : UIView!

}
