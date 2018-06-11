//
//  CAGradientLayerExtension.swift
//  Nerd
//
//  Created by Mac-00014 on 11/04/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
extension CAGradientLayer {
    
    func gradientImage(frame : CGRect, colors : [CGColor]) -> UIImage?
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
        return image
    }
}

