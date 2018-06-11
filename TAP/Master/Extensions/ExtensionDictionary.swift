//
//  ExtensionDictionary.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 01/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation

// MARK: - Extension of Dictionary For getting the different types of values from it.
extension Dictionary {
    
    /// This method is used to get the string value from the dictionary.
    ///
    /// - Parameter key: Pass the key for which you want to get the value.
    /// - Returns: return String value according to passed key.
    func valueForString(key:String) -> String {
        
        if let dictionary = self as? [String:Any] {
            
            return "\(dictionary[key] ?? "")"
            
        } else {
            return ""
        }
    }
    
    /// This method is used to get the Int value from the dictionary.
    ///
    /// - Parameter key: Pass the key for which you want to get the value.
    /// - Returns: This Method returns Int? , it means this method return nil value also , while using this method please use if let. If you are not using if let and if this method returns nil and when you are trying to unwrapped this value("Int!") then application will crash.
    func valueForInt(key:String) -> Int? {
        return self.valueForString(key: key).toInt
    }
    
    func valueForDouble(key:String) -> Double? {
        return self.valueForString(key: key).toDouble
    }
    
    func valueForFloat(key:String) -> Float? {
        return self.valueForString(key: key).toFloat
    }
    
    /// This method is used to get the Any value from the dictionary.
    ///
    /// - Parameter key: Pass the key for which you want to get the value.
    /// - Returns: This Method returns Any? , it means this method return nil value also , while using this method please use if let. If you are not using if let and if this method returns nil and when you are trying to unwrapped this value("Any!") then application will crash.
    func valueForJSON(key:String) -> Any? {
        
        if let dictionary = self as? [String:Any] {
            
            return dictionary[key] ?? nil
            
        } else {
            return nil
        }
    }
    
    func valueForBool(key:String) -> Bool {
        
        if let dictionary = self as? [String:Any] {
            
            switch dictionary[key] {
            case let string as String:
                if string == "1" || string.lowercased() == "true" {
                    return true
                }
            case let int as Int:
                if int > 0  {
                    return true
                }
            case let bool as Bool:
                return bool
            default:
                return false
            }
            
        }
        
        return false
    }
}




extension Dictionary  {
    
     func updateJSON(_ json : Any) -> [String : Any] {
        
        if let dictData = json as? [String : Any] {
            
            let arrKeys = dictData.keys.sorted()
            
            if var dict = self as? [String : Any] {
                for (_, keys) in arrKeys.enumerated() {
                    
                    if let arrData = dictData[keys] as? [[String : Any]], var arrSelf = dict[keys] as? [[String : Any]] {
                        
                        var arrRunner = [Any]()
                        for item in arrData {
                            
                            if let rIndex = arrSelf.index(where: {$0.valueForString(key: "id") == item.valueForString(key: "id")}) {
                                //.. item exist in arrSelf than update value
                                var itemTemp = arrSelf[rIndex]
                                for (_, itemKey) in item.keys.sorted().enumerated() {
                                     itemTemp[itemKey] = item[itemKey]
                                }
                                arrRunner.append(itemTemp)
                            } else {
                                //.. if item not exist in arrSelf than add in arrSelf
                                arrRunner.append(item)
                            }
                        }
                        
                        
                        dict[keys] = arrRunner
                        
                    } else {
                        
                        dict[keys] = dictData[keys]
                    }
                  
                }
                
                return dict
            }
        }
        return self as! [String : Any]
    }
}
