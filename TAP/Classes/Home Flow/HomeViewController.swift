//
//  HomeViewController.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class HomeViewController: ParentViewController {

    @IBOutlet weak var tblHome : UITableView!
    @IBOutlet weak var lblLocation : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate?.showTabBar()
    }
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
    }
    
}


//MARK:-
//MARK:- Action

extension HomeViewController {
    
    @IBAction func btnLocationClicked(sender : UIButton) {
        if let selectLocVC = CLRF_SB.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController {
            self.navigationController?.pushViewController(selectLocVC, animated: true)
        }
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
   
    public func numberOfSections(in tableView: UITableView) -> Int  {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((CScreenWidth  * 276)/375.0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell") as? RestaurantTableViewCell {
            
            if indexPath.section == 0 {
               cell.lblTitle.text = CNearbyRestaurant
                
            } else if indexPath.section == 1 {
               cell.lblTitle.text = CMostPopular
            
            } else {
                cell.lblTitle.text = CNewArrival
            }
            
            
            cell.btnSeeAll.touchUpInside { (sender) in
            
                if let seeAllVC = CMain_SB.instantiateViewController(withIdentifier: "SeeAllRestaurantViewController") as? SeeAllRestaurantViewController {
                    
                    seeAllVC.strTitle = cell.lblTitle.text!
                    self.navigationController?.pushViewController(seeAllVC, animated: true)
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }

}






