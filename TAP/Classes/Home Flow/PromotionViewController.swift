//
//  PromotionViewController.swift
//  TAP
//
//  Created by mac-00017 on 13/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class PromotionViewController: ParentViewController {

    @IBOutlet weak var tblPromotion : UITableView!
    
    var arrOffers = [Any]()
    
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
        self.title = CPromotions
        
        tblPromotion.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)

        arrOffers = [["offer":"Buy 1 Get 1 Free"],["offer":"Buy 1 Get 1 Free Buy 1 Get 1 Free Buy 1 Get 1 Free Buy 1 Get 1 Free Buy 1 Get 1 Free Buy 1 Get 1 Free Buy 1 Get 1 Free##"],["offer":"15% off in this summer"]]
    }

}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension PromotionViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOffers.count
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionTableViewCell") as? PromotionTableViewCell {
            
            let dict = arrOffers[indexPath.row] as? [String : AnyObject]
            cell.lblOffer.text = dict?.valueForString(key: "offer")
            
            return cell
        }
        
        return UITableViewCell()
    }
}



