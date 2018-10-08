//
//  ExtensionUIImageView.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 06/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

typealias touchUpInsideHandler<T> = ((T) -> ())

extension UIImageView {
    
    func loadGif(name: String) {
        
        DispatchQueue.global().async {
            
            if let image = UIImage.gif(name: name) {
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
    
}


// MARK: -
// MARK: - ImageViewTouchUpInSide

extension UIImageView {
    
    /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
    private struct AssociatedObjectKey {
        static var TouchUpInside = "genericTouchUpInsideHandler"
    }
    
    func touchUpInside(touchUpInside:@escaping touchUpInsideHandler<UIImageView>) {
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.TouchUpInside, touchUpInside, .OBJC_ASSOCIATION_RETAIN)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
    }
    
    //Action
    @objc func tapDetected(_ completion: ((Bool) -> Void)?) {
        
        print("Imageview Clicked")
        
        if let touchUpInsideHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.TouchUpInside) as?  touchUpInsideHandler<UIImageView> {
            
            touchUpInsideHandler(self)
        }
    }
}
