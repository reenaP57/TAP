//
//  CMSViewController.swift
//  TAP
//
//  Created by mac-00017 on 16/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

enum cmsTitle {
    case AboutUs
    case TermsCondition
    case PrivacyPolicy
}

class CMSViewController: ParentViewController {

    @IBOutlet weak var webContent : UIWebView!
    
    var cmsEnum = cmsTitle.AboutUs

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize(){
        
        switch cmsEnum {
        case .AboutUs :
            self.title = CAboutUs
        case .TermsCondition :
            self.title = CTermsConditions
        case .PrivacyPolicy :
            self.title = CPrivacyPolicy
        }
        
        self.cms()
    }

    func cms()
    {
        let str = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." as String
        
//        let myURL = URL(string: "https://www.apple.com")
//        let myRequest = URLRequest(url: myURL!)
//        self.webVw.loadRequest(myRequest)
        
         self.webContent.loadHTMLString(str, baseURL: nil)
    }
}

