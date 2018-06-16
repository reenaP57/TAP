//
//  GenericTextView.swift
//  TAP
//
//  Created by mac-00017 on 14/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class GenericTextView : UITextView {
    
    override func awakeFromNib() {
        self.setupGenericTextView()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        if self.tag == 101 {
//            self.setCornerRadius(radius: 5)
//            self.layer.borderColor = CColorLightGrey.cgColor
//            self.layer.borderWidth = 1
//        }
    }
}


// MARK: -
// MARK: - Basic Setup For GenericTextView.
extension GenericTextView {
    
    fileprivate func setupGenericTextView() {
        self.font = self.font?.setUpAppropriateFont()
        self.placeholder = CLocalize(text: self.placeholder!)
    }
    
}
