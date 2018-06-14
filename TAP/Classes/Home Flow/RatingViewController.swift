//
//  RatingViewController.swift
//  TAP
//
//  Created by mac-00017 on 13/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class RatingViewController: ParentViewController {

    @IBOutlet weak var tblRating : UITableView!
    
    var arrRating = [Any]()
    
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
        self.title = CRatings
        
        tblRating.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        
        arrRating = [["username":"Liam_Martine","rating":3.0, "review":"Maxican style tomato salsa, spicy chill sauce cheese cream..."],
                     ["username":"John Doe","rating":5.0, "review":"Maxican style tomato salsa, spicy chill sauce cheese cream..."],
                     ["username":"Samantha Martin","rating":1.0, "review":"Maxican style tomato salsa, spicy chill sauce cheese cream..."]]
    }
    
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension RatingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRating.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell") as? RatingTableViewCell {
            
            let dict = arrRating[indexPath.row] as? [String : AnyObject]
            cell.lblUserName.text = dict?.valueForString(key: "username")
            cell.lblRating.text = dict?.valueForString(key: "rating")
            cell.lblReview.text = dict?.valueForString(key: "review")
            cell.vwRating.rating = (dict?.valueForDouble(key: "rating"))!

            return cell
        }
        
        return UITableViewCell()
    }
}
