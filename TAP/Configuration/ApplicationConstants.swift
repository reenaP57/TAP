//
//  ApplicationConstants.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import Foundation
import UIKit


//.. Different Storyboard Instances.
let CMain_SB        = UIStoryboard(name: "Main", bundle:  nil)
let CLRF_SB         = UIStoryboard(name: "LRF", bundle: nil)
let COrder_SB       = UIStoryboard(name: "Order", bundle: nil)
let CCart_SB        = UIStoryboard(name: "Cart", bundle: nil)
let CProfile_SB     = UIStoryboard(name: "Profile", bundle: nil)


//MARK:-
//MARK:- Fonts

enum CFontType {
    case Regular
    case Light
    case Medium
    case Bold
    case SemiBold
    case Thin
    case Heavy
}

func CFontSFUIText(size: CGFloat, type: CFontType) -> UIFont
{
    switch type
    {
    case .Heavy:
        return UIFont.init(name: "SFUIText-Heavy", size: size)!
    case .Bold:
        return UIFont.init(name: "SFUIText-Bold", size: size)!
    case .Light:
        return UIFont.init(name: "SFUIText-Light", size: size)!
    case .Medium:
        return UIFont.init(name: "SFUIText-Medium", size: size)!
    case .SemiBold:
        return UIFont.init(name: "SFUIText-Semibold", size: size)!
        
    default:
        return UIFont.init(name: "SFUIText-Regular", size: size)!
    }
}



let CColorWhite              =  CRGB(r: 255.0, g: 255.0, b: 255.0)
let CColorShadow             =  CRGB(r: 240.0, g: 240.0, b: 240.0)
let CColorBlack              =  CRGB(r: 0, g: 0, b: 0)
let CColorLightBlack         =  CRGB(r: 51, g: 51, b: 51)
let CColorNavRed             =  CRGB(r: 191, g: 0, b: 0)
let CColorNavRedShadow       =  CRGBA(r: 191, g: 0, b: 0, a: 0.7)
let CColorCement             =  CRGB(r: 212.0, g: 212.0, b: 212.0)
let CColorLightGray          =  CRGB(r: 172.0, g: 172.0, b: 172.0)

//MARK:-
//MARK:- UserDefaults Keys

let UserDefaultLoginUserToken       = "UserDefaultLoginUserToken"
let UserDefaultLoginUserID          = "UserDefaultLoginUserID"
let UserDefaultTimestamp            = "UserDefaultTimestamp"

//MARK:-
//MARK:- Application Language

let CLanguagePortuguese         = "port"
let CLanguageEnglish            = "en"


//MARK:-
//MARK:- API Parameter

let CId                 = "id"
let CName               = "name"
let CEmail              = "email"
let CMobile_no          = "mobile_no"
let CPassword           = "password"
let CImage              = "image"
let CIs_notify          = "is_notify"
let CCountry_id         = "country_id"
let CCountry_code       = "country_code"
let CCountry_name       = "country_name"
let CStatus_id          = "status_id"
let CTimestamp          = "timestamp"
