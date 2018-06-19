//
//  RateOrderViewController.swift
//  TAP
//
//  Created by mac-00017 on 14/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

let CharacterLimit = 250

class RateOrderViewController: ParentViewController {

    @IBOutlet fileprivate weak var lblResName : GenericLabel!
    @IBOutlet fileprivate weak var lblOrderedTime : GenericLabel!
    @IBOutlet fileprivate weak var imgVRes : UIImageView!
    
    @IBOutlet fileprivate weak var vwRating : RatingView! {
        didSet {
            vwRating.delegate = self
        }
    }
    
    @IBOutlet fileprivate weak var txtVReview : UITextView!{
        didSet {
           // txtVReview.placeholder = CAddYourReview
            txtVReview.placeholderColor = CColorLightGray
            txtVReview.placeholderFont = CFontSFUIText(size: 13, type: .Regular)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate?.hideTabBar()
    }
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
    }
}


//MARK:-
//MARK:- Action

extension RateOrderViewController {
    
    @IBAction func btnBackClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitRatingClicked(sender : UIButton) {
        
        if vwRating.rating < 1.0 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CSelectRating, btnOneTitle: COk, btnOneTapped: nil)
        
        }
        else if txtVReview.text.isBlank {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankReview, btnOneTitle: COk, btnOneTapped: nil)
       
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnViewOrderDetailedClicked(sender : UIButton) {
         self.navigationController?.popViewController(animated: true)
    }
}


//MARK:-
//MARK:- TextView Delegate Method

extension RateOrderViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count > 0 {
            textView.placeholderColor = UIColor.clear
        } else {
            textView.placeholderColor = CColorLightGray
        }
        
        if textView.text.count > CharacterLimit {
            let currentText = textView.text as NSString
            txtVReview.text = currentText.substring(to: currentText.length - 1)
        }
    }
}


//MARK:-
//MARK:- Floating Rating Delegate Method

extension RateOrderViewController : FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        print("Rating : ",vwRating.rating)
    }
}
