//
//  SettingViewController.swift
//  TAP
//
//  Created by mac-00017 on 13/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class ProfileViewController:ParentViewController {
    
    @IBOutlet weak var tblSetting : UITableView!
    
    var headerView : ProfileHeaderView!
    
    var arrSetting = [CEditProfile, CChangePassword, CMyFavourite, CChangeLanguage, CNotification, CAboutUs, CTermsConditions, CContactUs, CPrivacyPolicy, CLogOut]
    
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
        self.title = CProfileSetting
        
        if headerView == nil {
            headerView = ProfileHeaderView.viewFromXib as? ProfileHeaderView
        }
        
        tblSetting.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
    }
    
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSetting.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ((CScreenWidth * headerView.CViewHeight) / 375.0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((CScreenWidth * 59) / 375.0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as? SettingTableViewCell {
            
            cell.lblTitle.text = arrSetting[indexPath.row]
            cell.switchNotiy.isHidden = true
            cell.imgVArrow.isHidden = false
            cell.lblTitle.textColor = CColorLightBlack
            
            if indexPath.row == arrSetting.count - 1 {
                cell.lblTitle.textColor = CColorNavRed
                cell.switchNotiy.isHidden = true
                cell.imgVArrow.isHidden = true
            }
            
            if indexPath.row == 4 {
                cell.switchNotiy.isHidden = false
                cell.imgVArrow.isHidden = true
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}



