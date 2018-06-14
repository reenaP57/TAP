//
//  RatingView.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class RatingView: FloatRatingView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRatingView()
    }
    
}

// MARK: -
// MARK: - Basic Setup For RatingView.
extension RatingView {
    
    fileprivate func setupRatingView() {
        
        self.type = .wholeRatings
        self.minRating = 0
        self.maxRating = 5
        
        self.emptyImage = UIImage (named: "star")
        self.fullImage = UIImage (named: "star_selected")
    }
}
