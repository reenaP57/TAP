//
//  MIOneSignal.swift
//  TAP
//
//  Created by mac-00017 on 24/07/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit
import OneSignal


let COneSignalAppId = "887cc081-8245-4d95-869a-e48294aef44b"
let CDeviceToken = "DeviceToken"
let CPlayerId = "PlayerId"

class MIOneSignal: NSObject,OSPermissionObserver,OSSubscriptionObserver {
    
    var badgeCount : Int = 0
    
    private override init() {
        super.init()
    }
    
    private static var onesignal: MIOneSignal = {
        let onesignal = MIOneSignal()
        return onesignal
    }()
    
    static func shared() ->MIOneSignal {
        return onesignal
    }
    
    func pushNotificatonRegistration()
    {
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: true, kOSSettingsKeyInFocusDisplayOption : "\(OSNotificationDisplayType.none)"] as [String : Any]
        OneSignal.initWithLaunchOptions(appDelegate?.dicLaunchOption, appId: COneSignalAppId, handleNotificationReceived: { (notification) in
            
            if notification != nil
            {
                let payload : OSNotificationPayload = notification!.payload as OSNotificationPayload
                self.actionOnPushNotificationWithDic(payload.additionalData as! [String : Any], isComingFromQuitMode: false)
            }
            
        }, handleNotificationAction: { (result) in
            let payload : OSNotificationPayload = result!.notification.payload as OSNotificationPayload
            self.actionOnPushNotificationWithDic(payload.additionalData as! [String : Any], isComingFromQuitMode: false)
            
        }, settings: onesignalInitSettings)
        
        OneSignal.promptForPushNotifications { (accepted) in
        }
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.none;
        
        let status : OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        print("OSPermissionSubscriptionState",status)
        
        
        OneSignal.add(self as OSPermissionObserver)
        OneSignal.add(self as OSSubscriptionObserver)
    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!)
    {
        print("onOSSubscriptionChanged")
        
        // Example of detecting subscribing to OneSignal
        if (!stateChanges.from.subscribed && stateChanges.to.subscribed)
        {
            print("Subscribed for OneSignal push notifications!")
            print("TO PUSH TOKEN ----------",stateChanges.to.pushToken)
            print("FROM PUSH TOKEN ----------",stateChanges.from.pushToken)
            print("PLAYER ID ----------",stateChanges.to.userId)
            CUserDefaults.set(stateChanges.to.pushToken, forKey: CDeviceToken)
            CUserDefaults.set(stateChanges.to.userId, forKey: CPlayerId)
            
            if ((stateChanges.to.pushToken) != nil)
            {
                self.registerDeviceTokenForNotification()
            }
        }
    }
    
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!)
    {
        print("onOSPermissionChanged")
        // Example of detecting anwsering the permission prompt
        if (stateChanges.from.status == .notDetermined)
        {
            if (stateChanges.to.status == .authorized)
            {
                print("Thanks for accepting notifications!")
            }
            else if (stateChanges.to.status == .denied)
            {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
        
    }
    
    func registerDeviceTokenForNotification()
    {
        let deviceToken = CUserDefaults.value(forKey: CDeviceToken) as? String
        let playerID = CUserDefaults.value(forKey: CPlayerId) as? String
        
        if deviceToken != nil && ((appDelegate?.loginUser) != nil) && playerID != nil
        {
            APIRequest.shared().addDeviceToken(device_token: deviceToken!, player_id: playerID!) { (response, error) in
                
                if response != nil && error == nil {
                    print("Response : ",response as Any)
                }
            }
        }
    }
    
    
    func removeDeviceToken()
    {
        let deviceToken = CUserDefaults.value(forKey: CDeviceToken) as? String
        let playerID = CUserDefaults.value(forKey: CPlayerId) as? String
        
        if deviceToken != nil && ((appDelegate?.loginUser) != nil) && playerID != nil
        {
            APIRequest.shared().removeDeviceToken(player_id: playerID!) { (response, error) in
                
                if response != nil && error == nil {
                    
                    appDelegate?.tabbarController = nil
                    appDelegate?.tabbar = nil
                    
                    TblRecentLocation.deleteAllObjects()
                    TblCart.deleteAllObjects()
                    TblCartRestaurant.deleteAllObjects()
                    
                    appDelegate?.loginUser = nil
                    CUserDefaults.removeObject(forKey: UserDefaultLoginUserToken)
                    CUserDefaults.removeObject(forKey: UserDefaultLoginUserID)
                    CUserDefaults.synchronize()
                    
                    guard let loginVC = CLRF_SB.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else{
                        return
                    }
                    
                    appDelegate?.setWindowRootViewController(rootVC: UINavigationController.rootViewController(viewController: loginVC), animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func actionOnPushNotificationWithDic(_ dicNotification : [String : Any], isComingFromQuitMode : Bool?)
    {
        print(dicNotification)
        
        if appDelegate?.loginUser != nil
        {
            let dateFormat = DateFormatter()
            let orderUpdated = dateFormat.string(timestamp: dicNotification.valueForDouble(key: COrder_updated)!, dateFormat: "MMM dd, yyyy' at 'hh:mm a")
            
            let appState = UIApplication.shared.applicationState
            if (appState == .active && !isComingFromQuitMode!)
            {
                if dicNotification.valueForInt(key: "notify_type") == COrderStatusComplete {
                    
                    if let rateOrderVC = COrder_SB.instantiateViewController(withIdentifier: "RateOrderViewController") as? RateOrderViewController {
                        
                        rateOrderVC.dict = [CRestaurant_name : dicNotification.valueForString(key: CRestaurant_name),
                                            CRestaurant_image : dicNotification.valueForString(key: CRestaurant_image),
                                            COrder_updated : orderUpdated as Any,
                                            COrderID : dicNotification.valueForInt(key: COrderID) as Any] as [String : AnyObject]
                      
                        self.topViewController()?.navigationController?.pushViewController(rateOrderVC, animated: false)
                        
                        self.topViewController()?.presentAlertViewWithOneButton(alertTitle: "", alertMessage: dicNotification.valueForString(key: "message"), btnOneTitle: COk) { (action) in
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationRefreshOrderList), object: nil)
                        }
                    }
                } else {
                    
                    if let topViewController = self.topViewController() {
                        
                        topViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: dicNotification.valueForString(key: "message"), btnOneTitle: COk) { (action) in
                            
                            if topViewController is OrderViewController {
                                
                                let orderVC = topViewController as! OrderViewController
                                orderVC.loadOrderList(isRefresh: false, isFromNotification: true)
                            } else {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationRefreshOrderList), object: nil)
                            }
                        }
                    }
                }
                
                print("Active Mode")
                
            } else {
                
                if let topViewController = self.topViewController() {
                    
                    if topViewController is OrderViewController {
                        let orderVC = topViewController as! OrderViewController
                        orderVC.loadOrderList(isRefresh: false, isFromNotification: true)
                    } else {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationRefreshOrderList), object: nil)
                    }
                    print("TopViewController : ", topViewController)
                }
                
                if dicNotification.valueForInt(key: "notify_type") == COrderStatusComplete {
                    
                    // let tabbar = appDelegate?.tabbarController?.viewControllers![0] as? UINavigationController
                    
                    if let rateOrderVC = COrder_SB.instantiateViewController(withIdentifier: "RateOrderViewController") as? RateOrderViewController {
                        rateOrderVC.dict = [CRestaurant_name : dicNotification.valueForString(key: CRestaurant_name),
                                            CRestaurant_image : dicNotification.valueForString(key: CRestaurant_image),
                                            COrder_updated : orderUpdated as Any,
                                            COrderID : dicNotification.valueForInt(key: COrderID) as Any] as [String : AnyObject]
                        
                        self.topViewController()?.navigationController?.pushViewController(rateOrderVC, animated: false)
                    }
                    
                } else {
                    appDelegate?.tabbar?.btnTabClicked(sender: (appDelegate?.tabbar?.btnOrder)!)
                }
                
                print("InActive Mode")
            }
        }
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
