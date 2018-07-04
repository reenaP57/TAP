//
//  SearchViewController.swift
//  TAP
//
//  Created by mac-00017 on 16/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SearchViewController: ParentViewController, customSearchViewDelegate {
    
    @IBOutlet weak var tblSearch : UITableView! {
        didSet {
            tblSearch.register(UINib(nibName: "SearchRestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchRestaurantTableViewCell")
        }
    }
    
    @IBOutlet weak var lblResultCount : UILabel!
    @IBOutlet weak var cnTblBottom : NSLayoutConstraint!
    @IBOutlet weak var activityLoader : UIActivityIndicatorView!
    
    var vwCustomSearch : CustomSearchView?

    var isFromOther : Bool = false
    var arrRestData = [[String : AnyObject]]()
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    
    var currentPage : Int = 1
    var lastPage : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFromOther ? appDelegate?.hideTabBar() : appDelegate?.showTabBar()
        
    }
    
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.setCustomSearchBar()
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = CColorNavRed
        tblSearch.pullToRefreshControl = refreshControl
        
    }
    
    func setCustomSearchBar() {
        
        if let customeView = CustomSearchView.viewFromXib as? CustomSearchView
        {
            customeView.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: 44)
            customeView.searchBar.placeholder = CSearchRestaurant
            customeView.delegate = self
            vwCustomSearch = customeView
            
            if isFromOther {
                cnTblBottom.constant = 0
                customeView.btnBack.hide(byWidth: false)
                customeView.layoutWidthSearchbar.constant = CScreenWidth - (self.vwCustomSearch?.btnBack.CViewWidth ?? 45.0) - 20.0
                customeView.layoutLeadingSearchBar.constant = 0
                
            } else {
                customeView.btnBack.hide(byWidth: true)
                customeView.layoutSearchBarTrailing.constant = 0
                customeView.layoutWidthSearchbar.constant = CScreenWidth - 20
            }
 
            
            self.navigationItem.titleView = customeView
            
            customeView.btnBack.touchUpInside { (sender) in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}


//MARK:-
//MARK:- Custom SearchBar Delegate

extension SearchViewController {

    func textDidChange(text : String) {
       currentPage = 1
       lblResultCount.text = ""
       self.loadSearchRestaurantList(search: text, isRefresh: false)
    }
    
    func clearSearchText() {
        lblResultCount.text = ""
        arrRestData.removeAll()
        tblSearch.isHidden = true
        tblSearch.reloadData()
    }

    func showNextScreen() {
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRestData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((CScreenWidth  * 222)/375.0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRestaurantTableViewCell") as? SearchRestaurantTableViewCell {
            
            var dict = arrRestData[indexPath.row]
            
            cell.lblRestName.text = dict.valueForString(key: CName)
            cell.lblResLocation.text = dict.valueForString(key: CAddress)
            cell.lblRating.text = "\(dict.valueForDouble(key: CAvg_rating) ?? 0.0)"
            cell.vwRating.rating = (dict.valueForDouble(key: CAvg_rating))!
            
            cell.imgVRest.sd_setShowActivityIndicatorView(true)
            cell.imgVRest.sd_setImage(with: URL(string: (dict.valueForString(key: CImage))), placeholderImage: nil)
            
            let arrCuisine = dict.valueForJSON(key: CCuisine) as? [[String : AnyObject]]
            let arrCuisineName = arrCuisine?.compactMap({$0[CName]}) as? [String]
            cell.lblCuisines.text = arrCuisineName?.joined(separator: "-")
            
            
            if dict.valueForInt(key: COpen_Close_Status) == 0 {
                cell.lblClosed.hide(byWidth: false)
                cell.lblTime.text = "Open at \(dict.valueForString(key: COpen_time))"
            } else {
                cell.lblClosed.hide(byWidth: true)
            }
            
            
            if dict.valueForInt(key: CFav_status) == 0 {
                cell.btnLike.isSelected = false
            } else{
                cell.btnLike.isSelected = true
            }
            
            cell.btnLike.touchUpInside { (sender) in
                
                //...Open login Popup If user is not logged In OtherWise Like
                
                if appDelegate?.loginUser?.user_id == nil{
                    appDelegate?.openLoginPopup(viewController: self.viewController!)
                } else{
                    if cell.btnLike.isSelected {
                        cell.btnLike.isSelected = false
                    } else {
                        cell.btnLike.isSelected = true
                    }
                    
                    appDelegate?.updateFavouriteStatus(restaurant_id: dict.valueForInt(key: CId)!, sender: cell.btnLike, completionBlock: { (response) in
                        
                        let data = response.value(forKey: CJsonData) as! [String : AnyObject]
                        dict[CFav_status] = data.valueForInt(key: CIs_favourite) as AnyObject
                        self.arrRestData[indexPath.row] = dict
                        self.tblSearch.reloadRows(at: [indexPath], with: .none)
                    })
                }
            }
            return cell
        }
        
        return UITableViewCell()
    }
}


//MARK:-
//MARK:- API Method

extension SearchViewController {
    
    @objc func pullToRefresh() {
        
        currentPage = 1
        refreshControl.beginRefreshing()
        self.loadSearchRestaurantList(search: (vwCustomSearch?.searchBar.text)!, isRefresh: true)
    }
    
    func loadSearchRestaurantList(search: String, isRefresh : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        let dict = [CSearch : search,
                    CPage : currentPage] as [String : AnyObject]
        
        if !isRefresh {
            tblSearch.isHidden = true
            activityLoader.startAnimating()
        }
        
        apiTask = APIRequest.shared().searchRestaurantOrCuisine(param: dict, completion: { (response, error) in
            
            self.apiTask?.cancel()
            self.activityLoader.stopAnimating()
            self.refreshControl.endRefreshing()
            
            
            if response != nil && error == nil {
                
                print("Response :",response as Any)
                
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                
                if self.currentPage == 1 || arrData.count == 0 {
                    self.arrRestData.removeAll()
                }
                
                
                if arrData.count > 0 {
                   
                    self.arrRestData.removeAll()
                    for item in arrData {
                        self.arrRestData.append(item)
                    }
                }
                
                self.lastPage = metaData.valueForInt(key: CLastPage)!
                
                if metaData.valueForInt(key: CCurrentPage)! <= self.lastPage {
                    self.currentPage = metaData.valueForInt(key: CCurrentPage)! + 1
                }
                
                if self.arrRestData.count > 0 {
                    self.tblSearch.isHidden = false
                }
                
                self.lblResultCount.text = "\(metaData.valueForInt(key: "total")!) search results found"
                self.tblSearch.reloadData()
            }
        })
        
    }
}


