//
//  AppDelegate.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.initSelectLanguageViewController()
        return true
    }

  
    // MARK:-
    // MARK:- Root Function
    
    
    func initSelectLanguageViewController()
    {
        let rootVC = UINavigationController.init(rootViewController: CLRF_SB.instantiateViewController(withIdentifier: "SelectLanguageViewController"))
        self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
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

