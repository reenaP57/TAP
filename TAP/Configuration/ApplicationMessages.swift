//
//  ApplicationMessages.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import Foundation

//General

var CRetry              : String { return CLocalize(text: "Retry")}
var CYes                : String { return CLocalize(text: "Yes")}
var CNo                 : String { return CLocalize(text: "No")}
var COk                 : String { return CLocalize(text: "Ok")}
var CCancel             : String { return CLocalize(text: "Cancel")}
var CClose              : String { return CLocalize(text: "CLOSE")}

//LRF

var CSelectLanguage      : String { return CLocalize(text: "Select Language")}
var CLogin               : String { return CLocalize(text: "Log In")}
var CSignUp              : String { return CLocalize(text: "Sign Up")}
var CForgotPassword      : String { return CLocalize(text: "Forgot Password")}
var CSearchYourLocation  : String { return CLocalize(text: "Search your location")}
var CDone                : String { return CLocalize(text: "Done")}
var CContinue            : String { return CLocalize(text: "Continue")}
var CCurrentLocation     : String { return CLocalize(text: "Current Location")}
var CDontHaveAnAccount   : String { return CLocalize(text: "Don't have an account?")}
var CAlreadyHaveAnAccount   : String { return CLocalize(text: "Already have an account?")}

//Home

var CMostPopular : String { return CLocalize(text:  "Most Popular") }
var CNearbyRestaurant   : String { return CLocalize(text: "Nearby Restaurants")}
var CNewArrival         : String { return  CLocalize(text: "New Arrival")}
var CRatings            : String { return CLocalize(text: "Ratings")}
var CPromotions         : String { return CLocalize(text: "Promotions")}
var CSearchRestaurant   : String { return CLocalize(text: "Search restaurant by name, cuisine or dish")}

var CSearchDish         : String { return CLocalize(text: "Search")}
var CClearCartAndAdd    : String { return CLocalize(text: "CLEAR CART & ADD")}

var CMessageNoSearchRest     : String { return CLocalize(text: "No restaurant,cuisine or dish available.")}
var CMessageNoDishAvailableForRest  : String { return CLocalize(text: "No dishes available for this restaurant.")}
var CMessageNoDishAvailable     : String { return CLocalize(text: "No dishes available.")}
var CMessageNoFoundPromotion : String { return CLocalize(text: "There are no promotions added for this restaurant.")}
var CMessageAlreadyCardAdded     : String { return CLocalize(text: "Adding dishes from this restaurant will clear your cart and will add new dishes from this restaurant. There are some dishes already added from other restaurant in your cart. Are you sure you want to clear cart and add new dishes from this restaurant ?")}


//Order

var CYourOrders         : String { return  CLocalize(text: "Your Orders")}
var COrderSummary       : String { return  CLocalize(text: "Order Summary")}
var COrderAccepted      : String { return  CLocalize(text: "ORDER ACCEPTED")}
var COrderRejected      : String { return  CLocalize(text: "ORDER REJECTED")}
var COrderReady         : String { return  CLocalize(text: "ORDER READY")}
var COrderPending       : String { return CLocalize(text: "ORDER PENDING")}

var CAddYourReview      : String { return  CLocalize(text: "Add your review...")}
var CToPay              : String { return CLocalize(text: "To pay (by cash)")}
var CPaid               : String { return CLocalize(text: "Paid (with stripe)")}
var CSubTotal           : String { return CLocalize(text: "Subtotal")}
var CTax                : String { return CLocalize(text: "Tax")}
var CMessageNoOrder     : String { return CLocalize(text: "Yet you have not given order.")}


//Cart

var CViewCart           : String { return  CLocalize(text: "View Cart")}
var CPaymentSuccess     : String { return  CLocalize(text: "Payment Success")}

var CMessageUpdatedRestCart     : String { return CLocalize(text: "Updated cart detail.")}
var CClosedRestaurant           : String { return CLocalize(text: "Restaurant is closed.")}
var CPaymentMessage1            : String { return CLocalize(text: "Your Payment of")}
var CPaymentMessage2            : String { return CLocalize(text: "has been successfully done. Here is your Order ID and Transaction ID.")}
var COrderPlaceDateTime         : String { return CLocalize(text: "The order was place on")}


//Profile

var CProfileSetting      : String { return  CLocalize(text: "Profile Setting")}
var CEditProfile         : String { return  CLocalize(text: "Edit Profile")}
var CChangePassword      : String { return  CLocalize(text: "Change Password")}
var CChangeLanguage      : String { return  CLocalize(text: "Change Language")}
var CMyFavourite         : String { return  CLocalize(text: "My Favourites")}
var CTermsConditions     : String { return  CLocalize(text: "Terms & Conditions")}
var CNotification        : String { return  CLocalize(text: "Notification")}
var CAboutUs             : String { return  CLocalize(text: "About Us")}
var CPrivacyPolicy       : String { return  CLocalize(text: "Privacy Policy")}
var CContactUs           : String { return  CLocalize(text: "Contact Us")}
var CLogOut              : String { return  CLocalize(text: "Log Out")}

var CMessageNoFavouriteRest  : String { return CLocalize(text: "You have not favourite any restaurant.")}


//Confirmation Message

var CDeleteOrderMessage     : String { return CLocalize(text: "Are you sure you want to delete this order?")}
var CLogOutMessage          : String { return CLocalize(text: "Are you sure you want to Log Out?")}


//Validaton Message

var CBlankEmailMessage           : String { return CLocalize(text:"Please enter your Email.")}
var CInvalidEmailMessage         : String { return CLocalize(text:"Please enter valid Email.")}
var CBlankPasswordMessage        : String { return CLocalize(text:"Please enter your Password.")}
var CBlankConfirmPasswordMessage : String { return CLocalize(text:"Please enter your Confirm Password.")}
var CMisMatchMessage             : String { return CLocalize(text:"Password and Confirm Password doesn’t match.")}
var CBlankFullNameMessage        : String { return CLocalize(text:"Please enter your Full Name.")}
var CInvalidPasswordMessage      : String { return CLocalize(text:"Please enter minimum 6 character alphanumeric Password.")}
var CBlankCountryCodeMessage     : String { return CLocalize(text:"Please select your Country Code.")}
var CValidMobileNo               : String { return  CLocalize(text:"Please enter valid Mobile Number.")}

var CSelectRating                : String { return CLocalize(text:"Please select ratings.")}
var CBlankReview                 : String { return CLocalize(text:"Please enter review.")}

var CBlankOldPassword            : String { return CLocalize(text:"Please enter your Old Password.")}
var CBlankNewPassword            : String { return CLocalize(text:"Please enter your New Password.")}

var CMessaseLoginPopup           : String { return CLocalize(text:"Please login to continue")}
var CMessaseOrderPopup           : String { return CLocalize(text:"Please login to get your cart history.")}


var CMessaseDeviceNotSupport     : String { return CLocalize(text:"Sorry, your device is not support mail")}

var CMessaseProfileUpdated       : String { return CLocalize(text:"Your profile updated successfully.")}
var CMessaseChangePassword       : String { return CLocalize(text:"Password updated successfully.")}


// General Message

var CError  = "ERROR!"
var CMessageRetry  = "An error has occured. Please check your network connection or try again."
