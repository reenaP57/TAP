//
//  CustomSearchView.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class CustomSearchView: UIView, UISearchBarDelegate {
    
    @IBOutlet weak var layoutWidthSearchbar: NSLayoutConstraint!
    @IBOutlet weak var layoutSearchBarTrailing: NSLayoutConstraint!
    @IBOutlet weak var layoutHeightSearchbar: NSLayoutConstraint!
    @IBOutlet weak var layoutLeadingSearchBar: NSLayoutConstraint!
    @IBOutlet weak var btnBack : UIButton!

    @IBOutlet weak var searchBar : UISearchBar!{
        didSet {
            
            searchBar.delegate = self
            
            searchBar.setImage(UIImage(named:"search"), for: .search, state: .normal)
            searchBar.tintColor = CColorNavRed
            searchBar.backgroundImage = UIImage()
            
            
            //...Get TextField From SearchBar
            //...Set Font and TextColor
            
            
            let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
            
            searchTextField?.font = (IS_iPhone_X) ? CFontSFUIText(size: 15, type: .Regular) : (IS_iPhone_6 || IS_iPhone_6_Plus) ? CFontSFUIText(size: 15, type: .Regular) :  CFontSFUIText(size: 14, type: .Regular)
            searchTextField?.textColor = CColorBlack   // CRGB(r: 204, g: 204, b: 204)
            searchBar.layer.cornerRadius = 0.0
            searchBar.layer.masksToBounds = true
            

            //...Change Placeholder TextColor
            
            searchTextField?.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("Search", comment:""), attributes:[NSAttributedStringKey.foregroundColor: CRGB(r: 204, g: 204, b: 204)])
            
            searchTextField?.setValue(CRGB(r: 255, g: 255, b: 255), forKeyPath: "_placeholderLabel.textColor")
            
            searchTextField?.backgroundColor = CRGB(r: 213, g: 44, b: 52)
            
            
            //...Change BackGround Color and Corner Radius Of SearchFieldBackGroundView
            
            if let searchFieldBackground = searchTextField?.subviews.first{
                
                searchFieldBackground.backgroundColor = CRGB(r: 213, g: 44, b: 52)
                searchFieldBackground.layer.cornerRadius = 4
                searchFieldBackground.clipsToBounds = true
            }
        }
    }
    
    private static var customSearch : CustomSearchView? = {
        
        guard let customSearch = CustomSearchView.viewFromXib as? CustomSearchView else {return nil
        }
        customSearch.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: 40)
        return customSearch
    }()
    
    
    static var shared : CustomSearchView? {
        return customSearch
    }
    
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
    
    class func destroy() {
        customSearch = nil
    }
    
}
