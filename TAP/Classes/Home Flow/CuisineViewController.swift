//
//  CuisineViewController.swift
//  TAP
//
//  Created by mac-00017 on 02/10/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class CuisineViewController: ParentViewController {

    @IBOutlet fileprivate weak var collCuisine : UICollectionView!
    @IBOutlet fileprivate weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet fileprivate weak var lblNoData : UILabel!
   
    var vwCustomSearch : CustomSearchView?
    var arrCuisine = [[String : AnyObject]]()
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    
    var currentPage : Int = 1
    var lastPage : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialze()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vwCustomSearch?.searchBar.text = ""
    }
    
    func initialze() {
        
        self.setCustomSearchBar()
        
        refreshControl.addTarget(self, action: #selector(pulltoRefresh), for: .valueChanged)
        refreshControl.tintColor = CColorNavRed
        if #available(iOS 10.0, *) {
            collCuisine.refreshControl = refreshControl
        } else {
            collCuisine.refreshControl = refreshControl
        }
        
        self.loadCuisineList(isRefresh: false)
    }
    
    
    func setCustomSearchBar() {
        
        if let customeView = CustomSearchView.viewFromXib as? CustomSearchView
        {
            customeView.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: 44)
            customeView.searchBar.placeholder = CSearchRestaurant
            customeView.delegate = self
            vwCustomSearch = customeView
            
            
            customeView.btnBack.hide(byWidth: true)
            customeView.layoutSearchBarTrailing.constant = 0
            customeView.layoutWidthSearchbar.constant = CScreenWidth - 20
            
            self.navigationItem.titleView = customeView
            
            customeView.btnBack.touchUpInside { (sender) in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func lastIndexPath() -> IndexPath?
    {
        let sections = collCuisine.numberOfSections
        
        if (sections<=0){
            return nil
        }
        
        let rows = collCuisine.numberOfItems(inSection: sections-1)
        
        if (rows<=0){return nil}
        
        return IndexPath(row: rows-1, section: sections-1)
    }
}


//MARK:-
//MARK:- UISearchBar delegate

extension CuisineViewController : customSearchViewDelegate {
    
    func textDidChange(text : String) {
    }
    
    func searchCuisine(text : String) {
        if let searchVC = CMain_SB.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            searchVC.searchCuisine = text
            self.navigationController?.pushViewController(searchVC, animated: false)
        }
    }

    func clearSearchText() {
    }
    
    func showNextScreen() {
    }
}


//MARK:-
//MARK:- UICollectionview delegate and datasource

extension CuisineViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCuisine.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        return CGSize(width: (CScreenWidth/2 - 15), height:(CScreenWidth/2 - 15))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisineCollectionViewCell", for: indexPath) as? CuisineCollectionViewCell {
            
            let dict = arrCuisine[indexPath.row]
            
            cell.imgVCuisine.contentMode = .scaleAspectFill
            cell.lblCuisineName.text = dict.valueForString(key: "cuisineName")
            cell.imgVCuisine.sd_setShowActivityIndicatorView(true)
            cell.imgVCuisine.sd_setImage(with: URL(string: (dict.valueForString(key: "cuisineImage"))), placeholderImage: nil)
            
            if indexPath == self.lastIndexPath() {
                
                //...Load More
                if currentPage < lastPage {
                    
                    if apiTask?.state == URLSessionTask.State.running {
                        self.loadCuisineList(isRefresh: true)
                    }
                }
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = arrCuisine[indexPath.row]
        
        if let searchVC = CMain_SB.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            searchVC.searchCuisine = dict.valueForString(key: "cuisineName")
            self.navigationController?.pushViewController(searchVC, animated: false)
        }
    }
}


//MARK:-
//MARK:- API

extension CuisineViewController {
    
    @objc func pulltoRefresh(){
        refreshControl.beginRefreshing()
        self.currentPage = 1
        self.loadCuisineList(isRefresh: true)
    }
    
    func loadCuisineList(isRefresh : Bool) {
        
        if self.apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if !isRefresh {
            self.activityLoader.startAnimating()
        }
        
        apiTask = APIRequest.shared().cuisineList(page: self.currentPage, completion: { (response, error) in
            
            self.activityLoader.stopAnimating()
            self.refreshControl.endRefreshing()
            self.apiTask?.cancel()
            
            if response != nil && error == nil {
                
                print("Response :",response as Any)
                
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                
                if self.currentPage == 1 || arrData.count == 0 {
                    self.arrCuisine.removeAll()
                }
                
                if arrData.count > 0 {
                    
                    self.arrCuisine.removeAll()
                    for item in arrData {
                        self.arrCuisine.append(item)
                    }
                }
                
                self.lastPage = metaData.valueForInt(key: CLastPage)!
                
                if metaData.valueForInt(key: CCurrentPage)! <= self.lastPage {
                    self.currentPage = metaData.valueForInt(key: CCurrentPage)! + 1
                }
                
                self.lblNoData.isHidden = self.arrCuisine.count != 0
                self.collCuisine.reloadData()
            }
        })
        
    }
}
