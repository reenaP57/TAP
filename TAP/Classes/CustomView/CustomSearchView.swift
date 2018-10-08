//
//  CustomSearchView.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit
import CoreLocation


@objc protocol customSearchViewDelegate : class {
    @objc optional func showNextScreen()
    @objc optional func textDidChange(text : String)
    @objc optional func clearSearchText()
    @objc optional func searchCuisine(text : String)
}

class CustomSearchView: UIView, UISearchBarDelegate {
    
    var delegate : customSearchViewDelegate?
    
    @IBOutlet weak var layoutWidthSearchbar: NSLayoutConstraint!
    @IBOutlet weak var layoutSearchBarTrailing: NSLayoutConstraint!
    @IBOutlet weak var layoutHeightSearchbar: NSLayoutConstraint!
    @IBOutlet weak var layoutLeadingSearchBar: NSLayoutConstraint!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnClear: UIButton!
    
    
    @IBOutlet weak var searchBar : UISearchBar!{
        didSet {
            
            searchBar.setImage(UIImage(named:"search"), for: .search, state: .normal)
            searchBar.tintColor = CColorWhite
            searchBar.backgroundImage = UIImage()
            
            
            //...Get TextField From SearchBar
            //...Set Font and TextColor
            
            
            let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
            
            searchTextField?.font = (IS_iPhone_X || IS_iPhone_6 || IS_iPhone_6_Plus) ? CFontSFUIText(size: 13, type: .Regular) :  CFontSFUIText(size: 11, type: .Regular)
            searchTextField?.textColor = CColorWhite
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
            
            searchTextField?.clearButtonMode = .never
            
            if let segmentView = searchBar.subviews.first?.subviews.first?.subviews.last {
                segmentView.isHidden = true
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.delegate = self
        btnClear.hide(byWidth: true)
        
        btnClear.touchUpInside { (sender) in
            self.searchBar.text = ""
            self.searchBar.resignFirstResponder()
            self.btnClear.hide(byWidth: true)
            self.delegate?.clearSearchText!()
        }
    }

    
    //MARK:-
    //MARK:- UISearchBar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
//        if let _ = CUserDefaults.value(forKey: CLatitude) as? CLLocationDegrees, let _ = CUserDefaults.value(forKey: CLongitude) as? CLLocationDegrees {
            delegate?.showNextScreen!()
     //   }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        delegate?.textDidChange!(text : searchText)
        
        if searchText.count == 0  {
            searchBar.resignFirstResponder()
            btnClear.hide(byWidth: true)
        } else {
            btnClear.hide(byWidth: false)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.searchCuisine!(text: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

