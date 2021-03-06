//
//  APIRequest.swift
//  StudyBuddy
//
//  Created by mac-0007 on 06/04/18.
//  Copyright © 2018 mac-0007. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire
import SDWebImage


//MARK:- ---------BASEURL __ TAG
var BASEURL:String        =  "http://www.itrainacademy.in/tap/api/v1/" //"http://192.168.1.29/noq/api/v1/"



let CAPITagSignUp                      = "sign-up"
let CAPITagLogin                       = "login"
let CAPITagForgotPassword              = "forgot-password"
let CAPITagEditProfile                 = "edit-profile"
let CAPITagCountry                     = "country"
let CAPITagChangePassword              = "change-password"
let CAPITagNotificationStatus          = "notification-on-off"
let CAPITagCMS                         = "cms"
let CAPITagRestaurantMainList          = "restaurant-main-list"
let CAPITagRestaurantList              = "restaurant-list"
let CAPITagSearchRestaurant            = "search-restaurant"
let CAPITagAddFavouriteRestaurant      = "add-favourite-restaurant"
let CAPITagFavouriteRestaurantList     = "favourite-restaurant-list"
let CAPITagPromotionList               = "promotion-list"
let CAPITagRestaurantDetails           = "restaurant-details"
let CAPITagRestaurantRating            = "restaurant-rating"
let CAPITagRestaurantUpdateDetail      = "restaurant-update-detail"
let CAPITagStripePayment               = "stripe-payment"
let CAPITagAddOrder                    = "add-order"
let CAPITagOrderList                   = "order-list"
let CAPITagOrderDetail                 = "order-detail"
let CAPITagAddRating                   = "add-rating"
let CAPITagAddCart                     = "add-cart"
let CAPITagCartDetail                  = "cart-detail"
let CAPITagDeviceToken                 = "device-token"
let CAPITagRemoveDeviceToken           = "delete-device-token"
let CAPITagCuisineList                 = "cuisine-list"



let CJsonResponse           = "response"
let CJsonMessage            = "message"
let CJsonStatus             = "status"
let CStatusCode             = "status_code"
let CJsonTitle              = "title"
let CJsonData               = "data"
let CJsonMeta               = "meta"

let CLimit                  = 20

let CStatusZero             = 0
let CStatusOne              = 1
let CStatusTwo              = 2
let CStatusThree            = 3
let CStatusFour             = 4
let CStatusFive             = 5
let CStatusEight            = 8
let CStatusNine             = 9
let CStatusTen              = 10
let CStatusEleven           = 11

let CStatus200              = 200 // Success
let CStatus400              = 400
let CStatus401              = 401 // Unauthorized
let CStatus405              = 405 // User Deleted
let CStatus500              = 500
let CStatus550              = 550 // Inactive/Delete user
let CStatus555              = 555 // Invalid request
let CStatus556              = 556 // Invalid request
let CStatus1009             = -1009 // No Internet
let CStatus1005             = -1005 //Network connection lost

//MARK:- ---------Networking
typealias ClosureSuccess = (_ task:URLSessionTask, _ response:AnyObject?) -> Void
typealias ClosureError   = (_ task:URLSessionTask, _ message:String?, _ error:NSError?) -> Void


class Networking: NSObject
{
    var BASEURL:String?
    
    var headers:[String: String] {
        if UserDefaults.standard.value(forKey: UserDefaultLoginUserToken) != nil {
            return ["Authorization" : "Bearer \((CUserDefaults.value(forKey: UserDefaultLoginUserToken)) as? String ?? "")","Accept-Language" : Localization.sharedInstance.getLanguage(),"Accept" : "application/json"]
        } else {
            return ["Accept" : "application/json","Accept-Language" : Localization.sharedInstance.getLanguage()]
        }
    }
    
    var loggingEnabled = true
    var activityCount = 0
    
    
    /// Networking Singleton
    static let sharedInstance = Networking.init()
    override init() {
        super.init()
    }
    
    fileprivate func logging(request req:Request?) -> Void
    {
        if (loggingEnabled && req != nil)
        {
            var body:String = ""
            var length = 0
            
            if (req?.request?.httpBody != nil) {
                body = String.init(data: (req!.request!.httpBody)!, encoding: String.Encoding.utf8)!
                length = req!.request!.httpBody!.count
            }
            
            let printableString = "\(req!.request!.httpMethod!) '\(req!.request!.url!.absoluteString)': \(String(describing: req!.request!.allHTTPHeaderFields)) \(body) [\(length) bytes]"
            
            print("API Request: \(printableString)")
        }
    }
    
    fileprivate func logging(response res:DataResponse<Any>?) -> Void
    {
        if (loggingEnabled && (res != nil))
        {
            if (res?.result.error != nil) {
                print("API Response: (\(String(describing: res?.response?.statusCode))) [\(String(describing: res?.timeline.totalDuration))s] Error:\(String(describing: res?.result.error))")
            } else {
                
                let data = res?.result.value as? [String : AnyObject]
                if res?.response!.statusCode == CStatus400
                {
                    CTopMostViewController.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: (data?.valueForString(key: CJsonMessage)), btnOneTitle: COk, btnOneTapped: { (action) in
                    }, btnTwoTitle:CCancel) { (action) in
                    }
             
                }else if res?.response!.statusCode == CStatus401 || res?.response!.statusCode == CStatus405
                {
                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: (data?.valueForString(key: CJsonMessage)), btnOneTitle: COk) { (action) in
                        appDelegate?.logout()
                    }
                }
                
                print("API Response: (\(String(describing: res?.response!.statusCode))) [\(String(describing: res?.timeline.totalDuration))s] Response:\(String(describing: res?.result.value))")
            }
        }
    }
    
    
    
    /// Uploading
    
    func upload(
        _ URLRequest: URLRequestConvertible,
        multipartFormData: (MultipartFormData) -> Void,
        encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) -> Void
    {
        
        let formData = MultipartFormData()
        multipartFormData(formData)
        
        
        var URLRequestWithContentType = try? URLRequest.asURLRequest()
        
        URLRequestWithContentType?.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")
        
        let fileManager = FileManager.default
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileName = UUID().uuidString
        
        #if swift(>=2.3)
        let directoryURL = tempDirectoryURL.appendingPathComponent("com.alamofire.manager/multipart.form.data")
        let fileURL = directoryURL.appendingPathComponent(fileName)
        #else
        
        let directoryURL = tempDirectoryURL.appendingPathComponent("com.alamofire.manager/multipart.form.data")
        let fileURL = directoryURL.appendingPathComponent(fileName)
        #endif
        
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            try formData.writeEncodedData(to: fileURL)
            
            DispatchQueue.main.async {
                
                let encodingResult = SessionManager.MultipartFormDataEncodingResult.success(request: SessionManager.default.upload(fileURL, with: URLRequestWithContentType!), streamingFromDisk: true, streamFileURL: fileURL)
                encodingCompletion?(encodingResult)
            }
        } catch {
            DispatchQueue.main.async {
                encodingCompletion?(.failure(error as NSError))
            }
        }
    }
    
    // HTTPs Methods
    func GET(param parameters:[String: AnyObject]?, success:ClosureSuccess?,  failure:ClosureError?) -> URLSessionTask?
    {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && response.response?.statusCode == 200)
            {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    failure!(uRequest.task!, nil , response.result.error as NSError?)
                }
            }
        }
        
        return uRequest.task
    }
    
    func GET(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask?
    {
        
        let uRequest = SessionManager.default.request((BASEURL! + tag), method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && response.response?.statusCode == 200)
            {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    failure!(uRequest.task!,nil, response.result.error as NSError?)
                }
            }
        }
        
        return uRequest.task
    }
    
    func POST(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask?
    {
        let uRequest = SessionManager.default.request((BASEURL! + tag), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && ([200, 201, 401] .contains(response.response!.statusCode)) )
            {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    
                    if response.result.error != nil
                    {
                        failure!(uRequest.task!,nil, response.result.error as NSError?)
                    }
                    else
                    {
                        let dict = response.result.value as? [String : AnyObject]
                        
                        guard let message = dict?.valueForString(key: "message") else
                        {
                            return failure!(uRequest.task!,nil, nil)
                        }
                        
                        failure!(uRequest.task!, message, nil)
                    }
                    
                }
            }
        }
        
        return uRequest.task
    }
    
    
    func POST(param parameters:[String: AnyObject]?, tag:String?, multipartFormData: @escaping (MultipartFormData) -> Void, success:ClosureSuccess?,  failure:ClosureError?) -> Void
    {
        SessionManager.default.upload(multipartFormData: { (multipart) in
            multipartFormData(multipart)
            
            if parameters != nil
            {
                for (key, value) in parameters!
                {
                    multipart.append("\(value)".data(using: .utf8)!, withName: key)
                    //  multipart.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
                }
            }
            
        },  to: (BASEURL! + (tag ?? "")), method: HTTPMethod.post , headers: headers) { (encodingResult) in
            
            
            switch encodingResult {
                
            case .success(let uRequest, _, _):
                
                self.logging(request: uRequest)
                
                uRequest.responseJSON { (response) in
                    
                    self.logging(response: response)
                    if(response.result.error == nil)
                    {
                        if(success != nil) {
                            success!(uRequest.task!, response.result.value as AnyObject)
                        }
                    }
                    else
                    {
                        if(failure != nil) {
                            failure!(uRequest.task!,nil, response.result.error as NSError?)
                        }
                    }
                }
                
                break
            case .failure(let encodingError):
                print(encodingError)
                break
            }
        }
        
    }
    
    
    
    
    func HEAD(param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask
    {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .head, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if response.result.error == nil
            {
                if (success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    failure!(uRequest.task!,nil, response.result.error as NSError?)
                }
            }
        }
        
        return uRequest.task!
    }
    
    func PATCH(param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask
    {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if response.result.error == nil
            {
                if (success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    failure!(uRequest.task!, nil, response.result.error as NSError?)
                }
            }
        }
        
        return uRequest.task!
    }
    
    func PUT(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask?
    {
        
        let uRequest = SessionManager.default.request(BASEURL!+tag, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && ([200,201] .contains(response.response!.statusCode)) )
            {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    
                    if response.result.error != nil
                    {
                        failure!(uRequest.task!,nil, response.result.error as NSError?)
                    }
                    else
                    {
                        let dict = response.result.value as? [String : AnyObject]
                        
                        guard let message = dict?.valueForString(key: "message") else
                        {
                            return failure!(uRequest.task!,nil, nil)
                        }
                        
                        failure!(uRequest.task!,message, nil)
                    }
                    
                }
            }
        }
        
        
        return uRequest.task!
    }
    
    func PUT(param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask
    {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if response.result.error == nil
            {
                if (success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    failure!(uRequest.task!, nil, response.result.error as NSError?)
                }
            }
            
        }
        
        return uRequest.task!
    }
    
    func DELETE(param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask
    {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if response.result.error == nil
            {
                if (success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    failure!(uRequest.task!, nil, response.result.error as NSError?)
                    
                }
            }
        }
        
        return uRequest.task!
    }
}



//MARK:- ---------General
class APIRequest: NSObject {
    
    typealias ClosureCompletion = (_ response:AnyObject?, _ error:NSError?) -> Void
    typealias successCallBack = (([String:AnyObject]?) -> ())
    typealias failureCallBack = ((String) -> ())
    
    var presentingSocialSignInVC:UIViewController?
    private var isInvalidUserAlertDisplaying = false
    
    private override init() {
        super.init()
    }
    
    private static var apiRequest:APIRequest {
        let apiRequest = APIRequest()
        
        if (BASEURL.count > 0 && !BASEURL.hasSuffix("/")) {
            BASEURL = BASEURL + "/"
        }
        
        Networking.sharedInstance.BASEURL = BASEURL
        return apiRequest
    }
    
    static func shared() -> APIRequest {
        return apiRequest
    }
    
    func isJSONDataValid(withResponse response: AnyObject!) -> Bool
    {
        if (response == nil) {
            return false
        }
        
        let data = response.value(forKey: CJsonData)
        
        if !(data != nil) {
            return false
        }
        
        if (data is String) {
            if ((data as? String)?.count ?? 0) == 0 {
                return false
            }
        }
        
        if (data is [Any]) {
            if (data as? [Any])?.count == 0 {
                return false
            }
        }
        
        return self.isJSONStatusValid(withResponse: response)
    }
    
    func isJSONStatusValid(withResponse response: AnyObject!) -> Bool {
        
        if response == nil {
            return false
        }
        
        let responseObject = response as? [String : AnyObject]
        
        if let meta = responseObject?[CJsonMeta]  as? [String : AnyObject] {
            
            if meta.valueForString(key: CStatusCode).toInt == CStatus200  {
                return  true
            } else {
                return false
            }
        }
        
        
        if  responseObject?.valueForString(key: CStatusCode).toInt == CStatus200 {
            return  true
        } else {
            return false
        }
    }
    
    
    func checkResponseStatusAndShowAlert(showAlert:Bool, responseobject: AnyObject?, strApiTag:String) -> Bool
    {
        MILoader.shared.hideLoader()
        
        if let meta = responseobject?.value(forKey: CJsonMeta) as? [String : Any] {
            
            switch meta.valueForInt(key: CJsonStatus) {
            case CStatusZero:
                return true
                
            case CStatusFour:
                return true
                
            case CStatusTen :
                appDelegate?.logout()
                
            default:
                if showAlert {
                    let message = meta.valueForString(key: CJsonMessage)
                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: COk) { (action) in
                    }
                }
            }
        }
        
//        else
//        {
//            // Auto Log out user
//            if let status : Int = responseobject![CJsonStatus] as? Int
//            {
//                if status == CStatus401
//                {
//                    let message : String = (responseobject![CJsonMessage] as? String)!
//                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: COk) { (action) in
//                        appDelegate?.logout()
//                    }
//                }
//            }
//        }
        
        return false
    }
    
    func actionOnAPIFailure(errorMessage:String?, showAlert:Bool, strApiTag:String,error:NSError?) -> Void
    {
        MILoader.shared.hideLoader()
        if showAlert && errorMessage != nil {
            CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMessage, btnOneTitle: COk) { (action) in
            }
        }
        
        print("API Error =" + "\(strApiTag )" + "\(String(describing: error?.localizedDescription))" )
    }
    
    
    func checkInternetConnection(complete:@escaping () -> Void) {
        
        var isScreenFind = false
        
        for objView in CTopMostViewController.view.subviews {
            if objView .isKind(of: NoInternetView.classForCoder()) {
                isScreenFind = true
                break
            }
        }
        
        if isScreenFind {
            return
        }
        
        let noInternetVW = NoInternetView.viewFromXib as? NoInternetView
       // noInternetVW?.frame = CGRect(x: 0, y: 64, width: CScreenWidth, height: CScreenHeight - 64)
        noInternetVW?.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: CScreenHeight)

        
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        CTopMostViewController.view.addSubview(noInternetVW!)
        
        noInternetVW?.btnTryAgain.touchUpInside(genericTouchUpInsideHandler: { (sender) in
            
            if (net?.isReachable)! {
                //...Network Available
                print("Network Available")
                noInternetVW?.removeFromSuperview()
                complete()
            }
        })
    }
}




//MARK:- ---------API Functions

extension APIRequest {
    
    
    //TODO:
    //TODO: --------------General API--------------
    //TODO:
    
    func getCountryList(_timestamp : AnyObject, completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GET(apiTag: CAPITagCountry, param: [CTimestamp :_timestamp], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: false, responseobject: response, strApiTag: CAPITagCountry) {
                
                self.saveCountryList(response: response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.getCountryList(_timestamp: _timestamp, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagCountry, error: error)
            }
            
        })
        
    }
    
    func cms(completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GET(apiTag: CAPITagCMS, param: [:], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagCMS) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
           
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.cms(completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagCMS, error: error)
            }
            
        })
    }
    
    
    
    //TODO:
    //TODO: --------------LRF API--------------
    //TODO:
    
    
    func signUp(_ param : [String : AnyObject], _imgData : Data?, completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        Networking.sharedInstance.POST(param: param, tag: CAPITagSignUp, multipartFormData: { (formData) in
            
            if _imgData?.count != 0 {
                formData.append(_imgData!, withName: CImage, fileName:  String(format: "%.0f.jpg", Date().timeIntervalSince1970 * 1000), mimeType: "image/jpeg")
            }
            
        }, success: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagSignUp) {
                completion(response, nil)
            }
            
            
        }) { (task, message, error) in
            MILoader.shared.hideLoader()
            
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.signUp(param, _imgData: _imgData, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagSignUp, error: error)
            }
            
        }
    }
    
    
    func login(_email: String?, _password: String?, completion: @escaping ClosureCompletion){
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagLogin, param: [CEmail : _email as AnyObject , CPassword : _password as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagLogin){
                completion(response, nil)
            }
            
        }) { (task, message, error) in
            MILoader.shared.hideLoader()
            
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.login(_email: _email, _password: _password, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagLogin, error: error)
            }
        }
        
    }
    
    func forgotPasswrd(_email : String, completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagForgotPassword, param: [CEmail : _email as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagForgotPassword){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            MILoader.shared.hideLoader()
            
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.forgotPasswrd(_email: _email, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagForgotPassword, error: error)
            }
        })
    }
    
    func editProfile(_param : [String : AnyObject],_imgData : Data?, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        Networking.sharedInstance.POST(param: _param, tag: CAPITagEditProfile, multipartFormData: { (formData) in
            
            if _imgData != nil {
                formData.append(_imgData!, withName: CImage, fileName:  String(format: "%.0f.jpg", Date().timeIntervalSince1970 * 1000), mimeType: "image/jpeg")
            }
            
        }, success: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagEditProfile) {
                completion(response, nil)
            }
            
        }) { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.editProfile(_param: _param, _imgData: _imgData, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagEditProfile, error: error)
            }
            
        }
        
    }
    
    
    func changePassword(oldPwd : String, newPwd : String, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagChangePassword, param: [CPassword : newPwd as AnyObject, COldPassword : oldPwd as AnyObject] , successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagChangePassword) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.changePassword(oldPwd: oldPwd, newPwd: newPwd, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagChangePassword, error: error)
            }
        })
    }
    
    func changeNotificationStatus(isNotify : String, completion : @escaping ClosureCompletion){
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagNotificationStatus, param: [CIs_notify  : isNotify as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagNotificationStatus){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagNotificationStatus, error: error)
        })
        
    }
    
    
    //TODO:
    //TODO: --------------HOME FLOW API--------------
    //TODO:
    
    
    func restaurantList (completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        var lat = 0.0
        var long = 0.0
        
        if (appDelegate?.loginUser != nil && appDelegate?.loginUser?.latitude != nil && appDelegate?.loginUser?.longitude != nil) && !(appDelegate?.isCurrentLoc)! {
            lat = (appDelegate?.loginUser?.latitude)!
            long = (appDelegate?.loginUser?.longitude)!
        } else if appDelegate?.loginUser == nil && !(appDelegate?.isCurrentLoc)!{
            lat =  appDelegate?.dictLocation[CLatitude]  as! Double
            long = appDelegate?.dictLocation[CLongitude]  as! Double
        } else {
            lat = CUserDefaults.object(forKey: CLatitude) as! Double
            long = CUserDefaults.object(forKey: CLongitude) as! Double
        }
        
        
        let dict = [CLatitude : lat,
                    CLongitude : long,
                    CCountry_id : appDelegate!.countryCode as AnyObject] as [String : Any]
        
        
        return Networking.sharedInstance.POST(apiTag: CAPITagRestaurantMainList, param: dict as [String : AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagRestaurantMainList) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.restaurantList(completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagRestaurantMainList, error: error)
            }
        })!
    }
    
    func moreRestaurantList (param : [String : AnyObject], completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        var dict = [String : AnyObject]()
        
        var lat = 0.0
        var long = 0.0
        
        if (appDelegate?.loginUser != nil && appDelegate?.loginUser?.latitude != nil && appDelegate?.loginUser?.longitude != nil) && !(appDelegate?.isCurrentLoc)! {
            lat = (appDelegate?.loginUser?.latitude)!
            long = (appDelegate?.loginUser?.longitude)!
        } else if appDelegate?.loginUser == nil && !(appDelegate?.isCurrentLoc)!{
            lat =  appDelegate?.dictLocation[CLatitude]  as! Double
            long = appDelegate?.dictLocation[CLongitude]  as! Double
        } else {
            lat = CUserDefaults.object(forKey: CLatitude) as! Double
            long = CUserDefaults.object(forKey: CLongitude) as! Double
        }
        
        
        dict = param
        dict[CPerPage] = CLimit as AnyObject
        dict[CLatitude] = lat as AnyObject
        dict[CLongitude] = long as AnyObject
        dict[CCountry_id] = appDelegate?.countryCode as AnyObject
        
        return Networking.sharedInstance.POST(apiTag: CAPITagRestaurantList, param: dict , successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagRestaurantList) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.moreRestaurantList(param: param, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagRestaurantList, error: error)
            }
        })!
    }
    
    func searchRestaurantOrCuisine(param : [String : AnyObject], completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        var dict = [String : AnyObject]()
        
        var lat = 0.0
        var long = 0.0
        
        if (appDelegate?.loginUser != nil && appDelegate?.loginUser?.latitude != nil && appDelegate?.loginUser?.longitude != nil) && !(appDelegate?.isCurrentLoc)! {
            lat = (appDelegate?.loginUser?.latitude)!
            long = (appDelegate?.loginUser?.longitude)!
        } else if appDelegate?.loginUser == nil && !(appDelegate?.isCurrentLoc)!{
            lat =  appDelegate?.dictLocation[CLatitude]  as! Double
            long = appDelegate?.dictLocation[CLongitude]  as! Double
        } else {
            lat = CUserDefaults.object(forKey: CLatitude) as! Double
            long = CUserDefaults.object(forKey: CLongitude) as! Double
        }
        
        
        dict = param
        dict[CPerPage] = CLimit as AnyObject
        dict[CLatitude] = lat as AnyObject
        dict[CLongitude] = long as AnyObject
        dict[CCountry_id] = appDelegate?.countryCode as AnyObject
        
        return Networking.sharedInstance.POST(apiTag: CAPITagSearchRestaurant, param: dict, successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagSearchRestaurant){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.searchRestaurantOrCuisine(param: param, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagSearchRestaurant, error: error)
            }
        })!
    }
    
    func restaurantDetail(restaurant_id : Int, completion : @escaping ClosureCompletion){
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagRestaurantDetails, param: [CRestaurant_id : restaurant_id as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagRestaurantDetails){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.restaurantDetail(restaurant_id: restaurant_id, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagRestaurantDetails, error: error)
            }
        })
        
    }
    
    func favouriteRestaurant(param : [String : AnyObject], completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagAddFavouriteRestaurant, param: param, successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagAddFavouriteRestaurant) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.favouriteRestaurant(param: param, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagAddFavouriteRestaurant, error: error)
            }
            
        })
    }
    
    func favouriteRestaurantList(page : Int, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        return Networking.sharedInstance.POST(apiTag: CAPITagFavouriteRestaurantList, param: [CPage:page as AnyObject, CPerPage : CLimit as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagFavouriteRestaurantList) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.favouriteRestaurantList(page: page, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagFavouriteRestaurantList, error: error)
            }
            
        })!
    }
    
    func promotionList(param: [String : AnyObject], completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        return Networking.sharedInstance.POST(apiTag: CAPITagPromotionList, param: param, successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagPromotionList) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.promotionList(param: param, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagPromotionList, error: error)
            }
            
        })!
    }
    
    func restaurantRatingList(restaurant_id : Int, page : Int, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        return Networking.sharedInstance.POST(apiTag: CAPITagRestaurantRating, param: [CRestaurant_id : restaurant_id as AnyObject, CPage : page as AnyObject, CPerPage : CLimit as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagRestaurantRating) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.restaurantRatingList(restaurant_id: restaurant_id, page: page, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagRestaurantRating, error: error)
            }
        })!
    }
    
    func updateRestaurantDetail (param : [String : AnyObject], completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagRestaurantUpdateDetail, param: param, successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagRestaurantUpdateDetail) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
           
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.updateRestaurantDetail(param: param, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagRestaurantRating, error: error)
            }
            
        })
    }
    
    func cuisineList(page : Int?, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        return Networking.sharedInstance.POST(apiTag: CAPITagCuisineList, param: [CPage : page as AnyObject, CPerPage : CLimit as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagCuisineList) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.cuisineList(page: page, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagCuisineList, error: error)
            }
            
        })!
        
    }
    
    
    //TODO:
    //TODO: --------------ORDER FLOW API--------------
    //TODO:
    
    func addOrder(param : [String : AnyObject], completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagAddOrder, param: param, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagAddOrder) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.addOrder(param: param, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagAddOrder, error: error)
            }
            
        })
    }
    
    
    func stripePayment(order_id : Int?, stripe_token : String, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "Processing...")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagStripePayment, param: ["order_id" : order_id as AnyObject, "stripe_token" : stripe_token as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagStripePayment){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.stripePayment(order_id: order_id, stripe_token: stripe_token, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagStripePayment, error: error)
            }
            
        })
    }
    
    func orderList(completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        return Networking.sharedInstance.POST(apiTag: CAPITagOrderList, param: [:], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagOrderList) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.orderList(completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagOrderList, error: error)
            }
            
        })!
    }
    
    func orderDetail (order_id : Int?, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagOrderDetail, param: [COrderID : order_id as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagOrderDetail) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.orderDetail(order_id: order_id, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagOrderDetail, error: error)

            }
                
        })
    }
    
    
    func orderRating(param : [String : AnyObject], completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagAddRating, param: param, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagAddRating) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.orderRating(param: param, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagAddRating, error: error)
            }
        })
    }
    
    func addCart(param : [String : AnyObject], completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagAddCart, param: param, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagAddCart) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.addCart(param: param, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagAddCart, error: error)
            }
            
        })
        
    }
    
    func cartDetail(completion : @escaping ClosureCompletion) {
        
        //CUserDefaults.object(forKey: UserDefaultCartID)
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagCartDetail, param: [CCart_id : CUserDefaults.object(forKey: UserDefaultCartID) as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: false, responseobject: response, strApiTag: CAPITagCartDetail) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.cartDetail(completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: false, strApiTag: CAPITagCartDetail, error: error)
            }
            
        })
    }
    
    //TODO:
    //TODO: --------------DEVICE TOKEN API--------------
    //TODO:
    
    func addDeviceToken(device_token : String, player_id : String, completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagDeviceToken, param: ["device_token":device_token as AnyObject, "player_id":player_id as AnyObject, "device_type": 1 as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagDeviceToken) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.addDeviceToken(device_token: device_token, player_id: player_id, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeviceToken, error: error)
            }
            
        })
    }
    
    func removeDeviceToken(player_id : String, completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag:CAPITagRemoveDeviceToken , param: ["player_id":player_id as AnyObject, "device_type": 1 as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagRemoveDeviceToken) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.removeDeviceToken(player_id: player_id, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagRemoveDeviceToken, error: error)
            }
        })
    }
}


//MARK:-
//MARK:- Save in Local

extension APIRequest {
    
    func saveUserDetailToLocal(response : [String : AnyObject]) {
        
        let dict = response.valueForJSON(key: CJsonData) as? [String : AnyObject]
        
        appDelegate?.loginUser = self.saveLoginUserDetail(dictUser: dict!)
        
        guard appDelegate?.loginUser?.user_id != nil else { return }
        
        if (CUserDefaults.object(forKey: UserDefaultLoginUserToken) == nil) {
            
            let metaData = response.valueForJSON(key: CJsonMeta) as? [String : AnyObject]
            
            CUserDefaults.set(metaData!["token"], forKey: UserDefaultLoginUserToken)
            CUserDefaults.set(appDelegate?.loginUser?.user_id, forKey: UserDefaultLoginUserID)
            CUserDefaults.synchronize()
        }
        
    }
    
    func saveLoginUserDetail (dictUser : [String : AnyObject]) ->  TblUser {
        
        CUserDefaults.set(appDelegate?.locManager.location?.coordinate.latitude, forKey: CLatitude)
        CUserDefaults.set(appDelegate?.locManager.location?.coordinate.longitude, forKey: CLongitude)
        CUserDefaults.set(appDelegate?.placeMark?.locality, forKey: UserDefaultCurrentLocation)
        CUserDefaults.synchronize()
        
        let tblUser = TblUser.findOrCreate(dictionary: ["user_id": Int64(dictUser.valueForInt(key: CId)!)]) as! TblUser
        
        tblUser.name = dictUser.valueForString(key: CName)
        tblUser.email = dictUser.valueForString(key: CEmail)
        tblUser.mobile_no = dictUser.valueForString(key: CMobile_no)
        tblUser.is_notify = dictUser.valueForBool(key: CIs_notify)
        tblUser.profile_image = dictUser.valueForString(key: CImage)
        tblUser.country_id = Int16(dictUser.valueForInt(key: CCountry_id)!)
        
        if let lat = CUserDefaults.object(forKey: CLatitude) {
            tblUser.latitude = lat as! Double
        }
       
        if let long = CUserDefaults.object(forKey: CLatitude) {
            tblUser.longitude = long as! Double
        }
        
        if let address  = CUserDefaults.object(forKey: UserDefaultCurrentLocation) {
            tblUser.address = address as? String
        }
        
        CoreData.saveContext()
        
        return tblUser
    }
    
    func saveCountryList(response : [String : AnyObject]) {
        
        let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]]
        
        let arrData = data?.sorted(by: {($0.valueForString(key: CCountry_name)) < ($1.valueForString(key: CCountry_name))})
        
        for item in arrData! {
            
            let tblCountry = TblCountryList.findOrCreate(dictionary: ["country_id":Int16(item.valueForInt(key: CId)!)]) as! TblCountryList
            
            tblCountry.country_code = item.valueForString(key: CCountry_code)
            tblCountry.country_name = item.valueForString(key: CCountry_name)
            tblCountry.status_id = Int16(item.valueForInt(key: CStatus_id)!)
            tblCountry.country_with_code = "\(item.valueForString(key: "country_name")) (\(item.valueForString(key: "country_code")))"
            
            print("Country name :", item.valueForString(key: CCountry_name))
        }
        
        CoreData.saveContext()
    }
}


