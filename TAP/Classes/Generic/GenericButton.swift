//
//  GenericButton.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class GenericButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupGenericButton()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if self.tag == 101 {
            
            ///... A Button that will in CornerRadius shape AND in shadow shape.
            
            self.backgroundColor = CColorNavRed
            self.shadow(color: CColorNavRedShadow, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 5.0, shadowOpacity: 0.9)
            self.layer.cornerRadius = self.CViewHeight/2.0
            
        } else if self.tag == 102 {
            
            ///... A Button that will in CornerRadius shape AND Border.
            self.roundView()
            self.layer.borderColor = CColorNavRed.cgColor
            self.layer.borderWidth = 1.0
            
        } else if self.tag == 103 {
            
            ///... A Button that will in CornerRadius shape AND Shadow.
            
            self.shadow(color: CColorShadow, shadowOffset: CGSize(width: 0, height: 10), shadowRadius: 5.0, shadowOpacity: 0.9)
            self.layer.cornerRadius = 5.0
            
        } else if self.tag == 104 {
            
            //...For Purple Button
            
            self.backgroundColor = CRGB(r: 103, g: 114, b: 229)
            self.shadow(color: CRGBA(r: 103, g: 114, b: 229, a: 0.7), shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 5.0, shadowOpacity: 0.9)
            self.layer.cornerRadius = self.CViewHeight/2.0
        }
        
    }
}


// MARK: -
// MARK: - Basic Setup For GenericButton.
extension GenericButton {
    
    fileprivate func setupGenericButton() {
        
        ///... Common Setup
        self.titleLabel?.font = self.titleLabel?.font.setUpAppropriateFont()
        self.setNormalTitle(normalTitle: CLocalize(text: self.currentTitle ?? ""))
    }
}
