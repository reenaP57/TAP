//
//  ParentViewController.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

   
    //MARK:-
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        MIKeyboardManager.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewAppearance()
        MIKeyboardManager.shared.enableKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resignKeyboard()
        MIKeyboardManager.shared.disableKeyboardNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }
    
    // MARK: -
    // MARK: - Keyboard Appear/Disappear Methods , Just override it.
    func miKeyboardWillShow(notification: Notification, keyboardHeight: CGFloat) {}
    func miKeyboardDidHide(notification: Notification) {}

    
    //MARK:-
    //MARK:- General Method
    
    fileprivate func setupViewAppearance() {
        
        
        //....Generic Navigation Setup
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:CFontSFUIText(size: 17, type: CFontType.Bold), NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = CColorNavRed

        self.navigationController?.navigationBar.barTintColor = CColorNavRed
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back_white")
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back_white")
        
        if self.view.tag == 100 {
            //...Hide NavigationBar
            
            self.navigationItem.hidesBackButton = true
            self.navigationController?.isNavigationBarHidden = true
            
        } else if self.view.tag == 101 {
            //...Navigation Animation

            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(customPopBack))
            
        } else {
            
            self.navigationItem.hidesBackButton = false
            self.navigationController?.isNavigationBarHidden = false
        }
        
    }
    
    @objc func customPopBack()
    {
        let animation = CATransition()
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromBottom
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.navigationController?.view.layer.add(animation, forKey: "AnimationFromTopToBottom")
        self.navigationController?.popViewController(animated: false)
        
    }
    
    func resignKeyboard() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


// MARK: -
// MARK: - MIKeyboardManagerDelegate Methods.
extension ParentViewController : MIKeyboardManagerDelegate {
    
    func keyboardWillShow(notification: Notification, keyboardHeight: CGFloat) {
        self.miKeyboardWillShow(notification: notification, keyboardHeight: keyboardHeight)
    }
    
    func keyboardDidHide(notification: Notification) {
        self.miKeyboardDidHide(notification: notification)
    }
}
