//
//  ExtensionDouble.swift
//  Swifty_Master
//
//  Created by mind-0002 on 10/11/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    
    var toInt:Int? {
        return Int(self)
    }
    
    var toFloat:Float? {
        return Float(self)
    }
    
    var toString:String {
        return "\(self)"
    }
    
    func roundToPlaces(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
