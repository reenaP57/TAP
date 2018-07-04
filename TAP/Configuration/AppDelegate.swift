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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var tabbarController : TabbarViewController?
    var tabbar : TabBarView?
    var objNavController = ParentViewController()
    var isFromLoginPop : Bool = false
    var loginUser : TblUser?
    
    var locManager = CLLocationManager()
    var countryCode = String()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        GMSPlacesClient.provideAPIKey(CGooglePlacePickerKey)
        GMSServices.provideAPIKey(CGooglePlacePickerKey)
        
        locManager.delegate = self
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locManager.requestWhenInUseAuthorization()
        }else{
            locManager.startUpdatingLocation()
        }
        
//        locManager.requestWhenInUseAuthorization()
//
//        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
//            currentLocation = locManager.location
//        }
        
        
        self.loadCountryList()
        self.initSelectLanguageViewController()
        return true
    }
    
    
    // MARK:-
    // MARK:- General Method
    
    
    func initSelectLanguageViewController()
    {
        if CUserDefaults.object(forKey: UserDefaultLoginUserToken) == nil {
            let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "SelectLanguageViewController"))
            self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
        } else {
            
            loginUser =  TblUser.findOrCreate(dictionary: ["user_id" : CUserDefaults.object(forKey: UserDefaultLoginUserID) as Any]) as? TblUser
            
            appDelegate?.tabbarController = TabbarViewController.initWithNibName() as? TabbarViewController
            appDelegate?.window?.rootViewController = appDelegate?.tabbarController

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
        
        CUserDefaults.removeObject(forKey: UserDefaultLoginUserToken)
        CUserDefaults.removeObject(forKey: UserDefaultLoginUserID)
        CUserDefaults.synchronize()
        
        guard let selectLangVC = CLRF_SB.instantiateViewController(withIdentifier: "SelectLanguageViewController") as? SelectLanguageViewController else{
            return
        }
        
        self.setWindowRootViewController(rootVC: UINavigationController.rootViewController(viewController: selectLangVC), animated: true, completion: nil)
        
    }
    
    func openLoginPopup(viewController : UIViewController) {
        
        if let vwLogin = LoginPopupView.viewFromXib as? LoginPopupView {
            
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
            
            let placeMark = placemark![0]
            self.countryCode = placeMark.isoCountryCode!
        }
        
    }
    
    
    // MARK:-
    // MARK:- Common Api
    
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
