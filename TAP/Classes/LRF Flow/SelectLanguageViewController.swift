//
//  SelectLanguageViewController.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SelectLanguageViewController: ParentViewController {

    @IBOutlet weak var btnEnglish : UIButton!
    @IBOutlet weak var btnPortuguese : UIButton!
    @IBOutlet weak var btnContinue : UIButton!
    @IBOutlet weak var imgVEnglish : UIImageView!
    @IBOutlet weak var imgVPortuguese : UIImageView!

    var isFromProfile : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        
        LocalizationSetLanguage(language: CLanguageEnglish)

        if isFromProfile {
            self.title = CChangeLanguage
            btnContinue.setTitle(CDone, for: .normal)
        } else {
            self.title = CSelectLanguage
            btnContinue.setTitle(CContinue, for: .normal)
        }
    }
}


//MARK:-
//MARK:- Action

extension SelectLanguageViewController {
    
    @IBAction func btnSelectLanguageClicked(sender : UIButton) {
        
        if sender.isSelected {
            return
        }
        
        btnEnglish.isSelected = false
        btnPortuguese.isSelected = false
        sender.isSelected = true
        
        if sender.accessibilityIdentifier == "0" {
            //...English
            imgVPortuguese.isHidden = true
            imgVEnglish.isHidden = false
            LocalizationSetLanguage(language: CLanguageEnglish)
            
        } else {
           //... Portuguese
            imgVPortuguese.isHidden = false
            imgVEnglish.isHidden = true
            LocalizationSetLanguage(language: CLanguagePortuguese)
        }
  
    }
    
    @IBAction func btnContinueClicked(sender : UIButton) {
        
        if isFromProfile {
            self.navigationController?.popViewController(animated: true)
            
        } else {
            
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
}

