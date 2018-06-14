//
//  SelectLocationViewController.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SelectLocationViewController: ParentViewController {

    @IBOutlet weak var lblCurrentLoc : UILabel!
    @IBOutlet weak var tblLocation : UITableView!

    var vwCustomSearch : CustomSearchView?
    var arrLocation = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate?.hideTabBar()
        self.updateSearchUI()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        
        arrLocation = ["New York, NY","San Fransisco, CA","Washington, DC","London, UK","Chicago, LA","Los Angeles, CA","Atlanta, GA","Austin, TX","Boston, MA","Houston, TX","Seattle, WA","Dallas, TX"]
        
        
        guard let customSearch = CustomSearchView.shared else {return}
        
        customSearch.searchBar.placeholder = CSearchYourLocation
        vwCustomSearch = customSearch
        vwCustomSearch?.searchBar.delegate = self as? UISearchBarDelegate
        
        self.navigationItem.titleView = vwCustomSearch
        customSearch.btnBack.touchUpInside { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    fileprivate func updateSearchUI()
    {
        DispatchQueue.main.async {
            
            self.vwCustomSearch?.btnBack.hide(byWidth: false)
            self.vwCustomSearch?.layoutWidthSearchbar.constant = CScreenWidth - (self.vwCustomSearch?.btnBack.CViewWidth ?? 45.0) - 20.0
            self.vwCustomSearch?.layoutLeadingSearchBar.constant = 0
        }
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension SelectLocationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLocationTableViewCell") as? SelectLocationTableViewCell {
            
            cell.lblLocationName.text = arrLocation[indexPath.row] as? String
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        appDelegate?.tabbarController = TabbarViewController.initWithNibName() as? TabbarViewController
        appDelegate?.window?.rootViewController = appDelegate?.tabbarController
        
    }
    
}
