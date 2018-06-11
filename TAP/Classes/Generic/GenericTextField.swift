//
//  GenericTextField.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class GenericTextField: UITextField {

    var strPwd : String = ""
    var strAsterisks : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupGenericTextField()
    }
    
    func customPasswordPattern(textField : UITextField) -> (String,String) {
        
        if strPwd.count < (textField.text?.count)! {
            
            if let str = textField.text {
                strPwd.append(str.last!)
                strAsterisks.append("*")
            }
        }
        else
        {
            strPwd = String(strPwd.dropLast())
            strAsterisks =  String(strAsterisks.dropLast())
        }
        
        textField.text = strAsterisks
        
        return (strPwd, strAsterisks)
    }

}

// MARK: -
// MARK: - Basic Setup For GenericTextField.
extension GenericTextField {
    
    fileprivate func setupGenericTextField() {
       
        ///... Common Setup
        self.font = self.font?.setUpAppropriateFont()
    }
    
}
