//
//  ExtensionString.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 01/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extension of String For Converting it TO Int AND URL.
extension String {
    
    /// A Computed Property (only getter) of Int For getting the Int? value from String.
    /// This Computed Property (only getter) returns Int? , it means this Computed Property (only getter) return nil value also , while using this Computed Property (only getter) please use if let. If you are not using if let and if this Computed Property (only getter) returns nil and when you are trying to unwrapped this value("Int!") then application will crash.
    var toInt:Int? {
        return Int(self)
    }
    
    var toDouble:Double? {
        return Double(self)
    }
    
    var toFloat:Float? {
        return Float(self)
    }
    
    
    /// A Computed Property (only getter) of URL For getting the URL from String.
    /// This Computed Property (only getter) returns URL? , it means this Computed Property (only getter) return nil value also , while using this Computed Property (only getter) please use if let. If you are not using if let and if this Computed Property (only getter) returns nil and when you are trying to unwrapped this value("URL!") then application will crash.
    var toURL:URL? {
        return URL(string: self)
    }
    
}

extension String {
    
    var trim:String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isBlank:Bool {
        return self.trim.isEmpty
    }
    
    var isAlphanumeric:Bool {
        
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    //  return !isBlank && rangeOfCharacter(from: .alphanumerics) != nil
    }
    
    var isValidEmail:Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with:self)
    }
    
    var isValidPassword:Bool {
        
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with:self)
    }
    
    var isValidPhoneNo:Bool {
        
        let phoneCharacters = CharacterSet(charactersIn: "+0123456789").inverted
        let arrCharacters = self.components(separatedBy: phoneCharacters)
        return self == arrCharacters.joined(separator: "")
    }
    
    var isValidProffesstion:Bool {
        return (self.isAlphanumeric || [" ",".","-","_"] .contains(self))
    }
    
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
            
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }}

extension String {
    
    var firstLetter: String{
        return self.prefix(1).uppercased()
    }
    
    var dateFromString : String {
        
        return self.dateFromString("yyyy-MM-dd HH:mm:ss", toDateFormate: "HH:mm/dd MMMM")
    }
    var accountDateFromString : String {
        
        return self.dateFromString("dd/MM/yyyy", toDateFormate: "yyyy/MM/dd")
    }
    
    var unsettledBatDateFromString : String {
        
        return self.dateFromString("yyyy-MM-dd HH:mm:ss", toDateFormate: "dd/MM/yyyy")
    }
    
    func dateFromString(_ fromDateFormate : String, toDateFormate : String) -> String {
        
        if let date =  DateFormatter.shared().date(fromString: self, dateFormat:fromDateFormate) {
            
            return DateFormatter.shared().string(fromDate: date, dateFormat: toDateFormate)
        }
        else {
             return self
        }
    }
}

extension String {
    
    func getSize(height:CGFloat , font:UIFont) -> CGFloat {
        
        let bounds = (self as NSString).boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: height), options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return bounds.size.width
    }
}

