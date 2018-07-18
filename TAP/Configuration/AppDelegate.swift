//
//  AppDelegate.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import MessageUI
import CoreLocation
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var tabbarController : TabbarViewController?
    var tabbar : TabBarView?
    var objNavController = ParentViewController()
    var isFromLoginPop : Bool = false
    var loginUser : TblUser?
    
    var locManager = CLLocationManager()
    var placeMark : CLPlacemark?
    var countryCode = String()
    var isCurrentLoc : Bool = false
    var dictLocation = [String : AnyObject]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        STPPaymentConfiguration.shared().publishableKey = CStripePublishableKey
        
        GMSPlacesClient.provideAPIKey(CGooglePlacePickerKey)
        GMSServices.provideAPIKey(CGooglePlacePickerKey)
        
        self.loadCountryList()
        self.initSelectLanguageViewController()
        
        
        locManager.delegate = self
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locManager.requestWhenInUseAuthorization()
        } else {
            locManager.startUpdatingLocation()
        }

        return true
    }
    
    
    // MARK:-
    // MARK:- General Method
    
    
    func initSelectLanguageViewController()
    {
        if CUserDefaults.object(forKey: UserDefaultLoginUserToken) == nil {
            let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "SelectLanguageViewController"))
            self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
            
        } else if CUserDefaults.object(forKey: UserDefaultLoginUserToken) != nil {
            
            loginUser =  TblUser.findOrCreate(dictionary: ["user_id" : CUserDefaults.object(forKey: UserDefaultLoginUserID) as Any]) as? TblUser
            
            
            if loginUser?.latitude == nil && loginUser?.longitude == nil {
                
                let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "SelectLocationViewController"))
                self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
                
            } else {
                
                appDelegate?.tabbarController = TabbarViewController.initWithNibName() as? TabbarViewController
                self.setWindowRootViewController(rootVC: appDelegate?.tabbarController, animated: false, completion: nil)
            }
        }
    }
    
    func hideTabBar() {
        appDelegate?.tabbar?.CViewSetY(y: CScreenHeight)
    }
    
    func showTabBar() {
        appDelegate?.tabbar?.CViewSetY(y: CScreenHeight - 49.0 - (IS_iPhone_X ? 34.0 : 0.0))
    }
    
    func logout()
    {
        tabbarController = nil
        tabbar = nil
        
        TblRecentLocation.deleteAllObjects()
        TblCart.deleteAllObjects()
        
        appDelegate?.loginUser = nil
        CUserDefaults.removeObject(forKey: UserDefaultLoginUserToken)
        CUserDefaults.removeObject(forKey: UserDefaultLoginUserID)
        CUserDefaults.synchronize()
        
        guard let loginVC = CLRF_SB.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else{
            return
        }
        
        self.setWindowRootViewController(rootVC: UINavigationController.rootViewController(viewController: loginVC), animated: true, completion: nil)
        
    }
    
    func openLoginPopup(viewController : UIViewController, fromOrder: Bool, completion : @escaping () -> ()) {
        
        if let vwLogin = LoginPopupView.viewFromXib as? LoginPopupView {
            
            if fromOrder {
               vwLogin.lblMsg.text = CMessaseOrderPopup
               vwLogin.btnClose.hide(byWidth: true)
            } else {
                vwLogin.lblMsg.text = CMessaseLoginPopup
                vwLogin.btnClose.hide(byWidth: false)
            }
            
            
            vwLogin.CViewSetSize(width: CScreenWidth, height: CScreenHeight)
            
            vwLogin.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.1) {
                vwLogin.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            appDelegate?.window?.addSubview(vwLogin)
            
            
            //...Action
            vwLogin.btnLogin.touchUpInside { (sender) in
                
                appDelegate?.isFromLoginPop = true
                //...After Payment Success redirect
                
                vwLogin.removeFromSuperview()
                
                self.objNavController = (viewController as? ParentViewController)!
                
                if let loginVC = CLRF_SB.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                 viewController.navigationController?.pushViewController(loginVC, animated: true)
                }
            }
            
            vwLogin.btnSignUp.touchUpInside { (sender) in
                
                vwLogin.removeFromSuperview()
                appDelegate?.isFromLoginPop = true
            
            
                completion()
                
                self.objNavController = (viewController as? ParentViewController)!
                
                if let signUpVC = CLRF_SB.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
                {
                    signUpVC.isFromProfileScreen = false
                    viewController.navigationController?.pushViewController(signUpVC, animated: true)
                }
            }
            
            vwLogin.btnClose.touchUpInside { (sender) in
                vwLogin.removeFromSuperview()
            }
        }
    }
    
    func openMailComposer(_ vController : UIViewController, email : String?)  {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setToRecipients(["test@gmail.com"])
            mail.setMessageBody("You're so awesome!", isHTML: true)
            vController.present(mail, animated: true)
        } else {
            
            vController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessaseDeviceNotSupport, btnOneTitle: COk) { (action) in
            }
        }
    }
    
    func UTCToLocalTime(date:String, fromFormat: String, toFormat: String, timezone: String) -> String {
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        dateFormatter.defaultDate = Date()
//        dateFormatter.dateFormat = fromFormat
//
//        let convertedDate = dateFormatter.date(from: date)
//        return ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: timezone)

        
        let dt = dateFormatter.date(from: date)
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: dt!)
        
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = fromFormat
//       // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//
//        let dt = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = toFormat
//
//        return dateFormatter.string(from: dt!)
    }
    

    
    // MARK:-
    // MARK:- Root update
    
    func setWindowRootViewController(rootVC:UIViewController?, animated:Bool, completion: ((Bool) -> Void)?) {
        
        guard rootVC != nil else {
            return
        }
        
        UIView.transition(with: self.window!, duration: animated ? 0.6 : 0.0, options: .transitionCrossDissolve, animations: {
            
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            
            self.window?.rootViewController = rootVC
            UIView.setAnimationsEnabled(oldState)
        }) { (finished) in
            if let handler = completion {
                handler(true)
            }
        }
    }
    
    
    // MARK:-
    // MARK:- Country List API
    
    
    func loadCountryList(){
        
        var timestamp : TimeInterval = 0
        
        if CUserDefaults.value(forKey: UserDefaultTimestamp) != nil {
            timestamp = CUserDefaults.value(forKey: UserDefaultTimestamp) as! TimeInterval
        }
        
        
        APIRequest.shared().getCountryList(_timestamp: timestamp as AnyObject, completion: { (response, error) in
            
            if response != nil && error == nil {
                
                let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject]
                
                CUserDefaults.setValue(metaData?["new_timestamp"], forKey: UserDefaultTimestamp)
                CUserDefaults.synchronize()
            }
        })
    }
    
    // MARK:-
    // MARK:- Location Delegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedAlways , .authorizedWhenInUse:
            self.locManager.startUpdatingLocation()
            
        case .denied , .notDetermined , .restricted:
            print("denied")
            self.locManager.requestWhenInUseAuthorization()
            self.locManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]

        CUserDefaults.set(userLocation.coordinate.latitude, forKey: CLatitude)
        CUserDefaults.set(userLocation.coordinate.longitude, forKey: CLongitude)
        CUserDefaults.synchronize()

        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(userLocation) { (placemark, error) in
            
            if placemark != nil {
                
                self.placeMark = placemark![0]
                self.countryCode = (self.placeMark?.isoCountryCode!)!
                
                CUserDefaults.set(self.placeMark?.locality, forKey: UserDefaultCurrentLocation)
                CUserDefaults.synchronize()
            }
        }
        
    }
    
    
    // MARK:-
    // MARK:- Common Api
    
    func loadCartDetail() {
        
     
        APIRequest.shared().cartDetail { (response, error) in
            
            if response != nil && error == nil {
               
                let dataRes = response?.value(forKey: CJsonData) as! [String : AnyObject]
                
                let arrCart = dataRes.valueForJSON(key: CCart) as! [[String : AnyObject]]
                
                for item in arrCart {
                     self.saveCart(dict: item, rest_id: dataRes.valueForInt(key: CRestaurant_id)!)
                }
                
                let contactNo = dataRes.valueForJSON(key: CContact_number) as! [String]
                
                var dictRest = [String : AnyObject]()
                dictRest = [CId : dataRes.valueForInt(key: CRestaurant_id),
                            CName : dataRes.valueForString(key: CRestaurant_name),
                            CAddress : dataRes.valueForString(key: CAddress),
                            CImage : dataRes.valueForString(key: CRestaurant_image),
                            CLatitude : dataRes.valueForDouble(key: CLatitude),
                            CLongitude : dataRes.valueForDouble(key: CLongitude),
                            CContact_no : contactNo.joined(separator: "\n"),
                            CTax_percent : dataRes.valueForDouble(key: CTax_percent),
                            CAdditional_tax : dataRes.valueForJSON(key: CAdditional_tax)] as [String : AnyObject]
                
                self.saveRestaurantDetail(dictRest: dictRest)
 
            }
        }
    }
    
    func updateFavouriteStatus(restaurant_id : Int, sender : UIButton, completionBlock : @escaping ((AnyObject) -> Void)) {
        
        if sender.isSelected {
            sender.isSelected = false
        } else {
            
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {
                sender.transform = .identity
                sender.isSelected = true
            }, completion: nil)
        }
        
        
        APIRequest.shared().favouriteRestaurant(param: [CRestaurant_id : restaurant_id, CIs_favourite :sender.isSelected ? CFavourite : CUnfavourite] as [String : AnyObject], completion: { (response, error) in
            
            if response != nil && error == nil {
                completionBlock(response as AnyObject)
            } else {
                sender.isSelected = !sender.isSelected
            }
        })
        
    }
    
   
    // MARK:-
    // MARK:- Save cart and restaurant detail
    
    func saveCart(dict : [String : AnyObject], rest_id : Int) {
        
        let tblCart = TblCart.findOrCreate(dictionary: [CDish_id: Int64(dict.valueForInt(key: CDish_id)!)]) as! TblCart
        
        tblCart.restaurant_id = Int64(rest_id)
        tblCart.dish_category_ids = dict.valueForJSON(key: "dish_category_ids") as? NSObject
        tblCart.dish_name = dict.valueForString(key: CDish_name)
        tblCart.dish_image = dict.valueForString(key: CDish_image)
        tblCart.dish_price = dict.valueForDouble(key: CDish_price)!
        tblCart.quantity = Int16(dict.valueForInt(key: CQuantity)!)
        tblCart.dish_ingredients = dict.valueForString(key: CDish_ingredients)
        tblCart.is_available = dict.valueForBool(key: CIs_available)
        tblCart.popular_index = Int16(dict.valueForInt(key: CPopular_index)!)
        tblCart.status_id = Int16(CActive)
        
        CoreData.saveContext()
    }
    
    func saveRestaurantDetail(dictRest : [String : AnyObject]) {
        
        let arr = TblCartRestaurant.fetchAllObjects()
        
        if arr?.count == 0 {
            
            let tblCartRest = TblCartRestaurant.findOrCreate(dictionary: ["restaurant_id" : dictRest.valueForInt(key: CId)!]) as! TblCartRestaurant
            
            tblCartRest.restaurant_name = dictRest.valueForString(key: CName)
            tblCartRest.restaurant_img = dictRest.valueForString(key: CImage)
            tblCartRest.address = dictRest.valueForString(key: CAddress)
            tblCartRest.latitude = dictRest.valueForDouble(key: CLatitude)!
            tblCartRest.longitude = dictRest.valueForDouble(key: CLongitude)!
            tblCartRest.contact_no = dictRest.valueForString(key: CContact_no)
            tblCartRest.tax = dictRest.valueForDouble(key: CTax_percent)!
            tblCartRest.additional_tax = dictRest.valueForJSON(key: CAdditional_tax) as? NSObject
            
            CoreData.saveContext()
        }
        
    }
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TAP")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

// MARK:-
// MARK:- MFMailComposeViewControllerDelegate

extension AppDelegate :MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
