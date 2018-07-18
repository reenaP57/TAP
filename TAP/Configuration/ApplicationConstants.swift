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
let UserDefaultCurrentLocation      = "UserDefaultCurrentLocation"
let UserDefaultCartID               = "UserDefaultCartID"

let kNotificationUpdateFavStatus    = "UpdateFavouriteStatus"
let kNotificationRefreshOrderList   = "RefreshOrderList"
let kNotificationUpdateTabbar       = "UpdateTabbar"
let kNotificationUpdateRestaurantDetail   = "UpdateRestaurantDetail"


//MARK:-
//MARK:- Application Language

let CLanguagePortuguese         = "port"
let CLanguageEnglish            = "en"


//MARK:-
//MARK:- Type


let CNearBy = 1
let CPopular = 2
let CRecentlyAdded = 3

let CUnfavourite = "0"
let CFavourite   = "1"


let CPaymentStripe = "2"
let CPaymentCash   = "1"


let CActive = 1
let CDeleted = 3


let COrderStatusPending = 1
let COrderStatusAccept = 2
let COrderStatusReject = 3
let COrderStatusReady = 4
let COrderStatusComplete = 5


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
let COldPassword        = "old_password"
let CFav_status         = "fav_status"
let COpen_Close_Status  = "open_close_status"
let CAvg_rating         = "avg_rating"
let CAddress            = "address"
let CCuisine            = "cuisine"
let CClose_Status       = "close_status"
let CLatitude           = "latitude"
let CLongitude          = "longitude"
let COpen_time          = "open_time"
let CRestaurant_name    = "restaurant_name"
let CRestaurant_image   = "restaurant_image"
let CRestaurant_type    = "restaurant_type"
let CLastPage           = "last_page"
let CCurrentPage        = "current_page"
let CPage               = "page"
let CPerPage            = "per_page"
let CSearch             = "search"
let CRestaurant_id      = "restaurant_id"
let CIs_favourite       = "is_favourite"
let CNo_person_rated    = "no_person_rated"
let CContact_no         = "contact_no"
let CDish_name          = "dish_name"
let CDish_id            = "dish_id"
let CDish_image         = "dish_image"
let CDish_ingredients   = "dish_ingredients"
let CDish_price         = "dish_price"
let CQuantity           = "quantity"
let CDish_category_name = "dish_category_name"
let CDish_category_id   = "dish_category_id"
let CRating             = "rating"
let CRating_note        = "rating_note"
let CType               = "type"
let CTax_percent        = "tax_percent"
let CAdditional_tax     = "additional_tax"
let CIs_available       = "is_available"
let CNote               = "note"
let CSubtotal           = "subtotal"
let CTax_amount         = "tax_amount"
let COrder_total        = "order_total"
let CPayment_type       = "payment_type"
let CCart               = "cart"
let COrderID            = "order_id"
let CPopular_index      = "popular_index"
let CCreated_at         = "created_at"
let COrder_status       = "order_status"
let CTranscation_id     = "transaction_id"
let COrder_no           = "order_no"
let CContact_number     = "contact_number"
let COrder_completed    = "order_completed"
let CCart_id            = "cart_id"
