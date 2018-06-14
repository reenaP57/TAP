//
//  TabbarViewController.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTabbarView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension TabbarViewController {
    
    func setUpTabbarView() {
        
        self.tabBar.isHidden = true

        guard let tabbar = TabBarView.shared else { return }
        tabbar.frame = self.tabBar.frame
        tabbar.CViewSetY(y: CScreenHeight - 49.0 - (IS_iPhone_X ? 34.0 : 0.0))
      
        tabbar.btnHome.isSelected = true
        tabbar.btnOrder.isSelected = false
        tabbar.btnSearch.isSelected = false
        tabbar.btnCart.isSelected = false
        tabbar.btnProfile.isSelected = false

        appDelegate?.tabbar = tabbar
        
        self.view.addSubview(tabbar)
        
        guard let homeVC = CMain_SB.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        let homeNav = UINavigationController.rootViewController(viewController: homeVC)
        
      
        guard let searchVC = CMain_SB.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        let searchNav = UINavigationController.rootViewController(viewController: searchVC)
        
        
        guard let orderVC = CMain_SB.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        let orderNav = UINavigationController.rootViewController(viewController: orderVC)
        
        
        guard let cartVC = CMain_SB.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        let cartNav = UINavigationController.rootViewController(viewController: cartVC)
        
     
        guard let profileVC = CProfile_SB.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }
        let profileNav = UINavigationController.rootViewController(viewController: profileVC)

        guard let profileLoginVC = CProfile_SB.instantiateViewController(withIdentifier: "ProfileLoginViewController") as? ProfileLoginViewController else { return }
        let profileLoginNav = UINavigationController.rootViewController(viewController: profileLoginVC)
        
        
        self.setViewControllers([homeNav, searchNav, orderNav, cartNav, profileLoginNav], animated: true)
        
    }
}
