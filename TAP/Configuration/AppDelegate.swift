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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabbarController : TabbarViewController?
    var tabbar : TabBarView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        GMSPlacesClient.provideAPIKey(CGooglePlacePickerKey)
        GMSServices.provideAPIKey(CGooglePlacePickerKey)
        
        
        self.initSelectLanguageViewController()
        return true
    }

  
    // MARK:-
    // MARK:- General Method
    
    
    func initSelectLanguageViewController()
    {
//        appDelegate?.tabbarController = TabbarViewController.initWithNibName() as? TabbarViewController
//        appDelegate?.window?.rootViewController = appDelegate?.tabbarController
        
        let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "SelectLanguageViewController"))
        self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
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
        
        guard let vcLogin = CLRF_SB.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else{
            return
        }
            
       self.setWindowRootViewController(rootVC: UINavigationController.rootViewController(viewController: vcLogin), animated: true, completion: nil)
        
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
                
                //...After Payment Success redirect
                
                vwLogin.removeFromSuperview()
                
                if let loginVC = CLRF_SB.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    loginVC.loginFrom = .FromPopup
                    viewController.navigationController?.pushViewController(loginVC, animated: true)
                }
            }
            
            vwLogin.btnSignUp.touchUpInside { (sender) in
                
                vwLogin.removeFromSuperview()
                
                if let signUpVC = CLRF_SB.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
                    signUpVC.signupFrom = .FromPopup
                    viewController.navigationController?.pushViewController(signUpVC, animated: true)
                }
            }
            
            vwLogin.btnClose.touchUpInside { (sender) in
                vwLogin.removeFromSuperview()
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

