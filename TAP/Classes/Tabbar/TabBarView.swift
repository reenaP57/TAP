//
//  TabBarView.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class TabBarView: UIView {
 
    @IBOutlet weak var btnHome : UIButton!
    @IBOutlet weak var btnOrder : UIButton!
    @IBOutlet weak var btnSearch : UIButton!
    @IBOutlet weak var btnCart : UIButton!
    @IBOutlet weak var btnProfile : UIButton!
    @IBOutlet weak var lblCartCount : UILabel!

    private static var tabbar : TabBarView? = {
        
        guard let tabbar = TabBarView.viewFromXib as? TabBarView else {
            return nil
        }
      
        return tabbar
    }()
    
    static var shared : TabBarView?{
        return tabbar
    }
    
}


extension TabBarView {
    
    @IBAction func btnTabClicked(sender : UIButton) {
        
        if sender.isSelected {
            return
        }
        
        btnCart.isSelected = false
        btnHome.isSelected = false
        btnOrder.isSelected = false
        btnSearch.isSelected = false
        btnProfile.isSelected = false
        sender.isSelected = true
        
        appDelegate?.tabbarController?.selectedIndex = sender.tag
        
    }
}
