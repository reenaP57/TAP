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
        self.prefilledUserDetail()
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
    
    func prefilledUserDetail() {
        
        headerView.lblEmail.text = appDelegate?.loginUser?.email
        headerView.lblUserName.text = appDelegate?.loginUser?.name
        
        if appDelegate?.loginUser?.mobile_no != "" {
            headerView.lblMobileNo.text = appDelegate?.loginUser?.mobile_no
        } else {
            headerView.imgVPhone.hide(byHeight: true)
        }
        
        if appDelegate?.loginUser?.profile_image != nil {
            headerView.imgVProfile.sd_setImage(with: URL(string: (appDelegate?.loginUser?.profile_image)!), placeholderImage: nil)
        }
        
    }
    
}


//MARK:-
//MARK:- UITableView Delegate and Datasource Method

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSetting.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.prefilledUserDetail()
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
            
            cell.switchNotiy.isOn = (appDelegate?.loginUser?.is_notify)!
            
            if indexPath.row == arrSetting.count - 1 {
                cell.lblTitle.textColor = CColorNavRed
                cell.switchNotiy.isHidden = true
                cell.imgVArrow.isHidden = true
            }
            
            if indexPath.row == 4 {
                cell.switchNotiy.isHidden = false
                cell.imgVArrow.isHidden = true
            }
            
            cell.switchNotiy.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
       
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
       
        case 0:
            //...Edit Profile
            
            if let editProfileVC = CProfile_SB.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            }
            
        case 1:
            //...Change Password
            
            if let changePwdVC = CProfile_SB.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
                self.navigationController?.pushViewController(changePwdVC, animated: true)
            }
            
        case 2:
            //...Favorites
            
            if let favoritesVC = CProfile_SB.instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController {
                self.navigationController?.pushViewController(favoritesVC, animated: true)
            }
         
        case 3:
            //...Change Langugae
            
            if let changeLangVC = CLRF_SB.instantiateViewController(withIdentifier: "SelectLanguageViewController") as? SelectLanguageViewController {
                changeLangVC.isFromProfile = true
                self.navigationController?.pushViewController(changeLangVC, animated: true)
            }
            
        case 5,6,8:
            //...CMS
            
            if let cmsVC = CProfile_SB.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
                
                if indexPath.row == 5 {
                   cmsVC.cmsEnum = .AboutUs
                } else if indexPath.row == 6 {
                    cmsVC.cmsEnum = .TermsCondition
                } else{
                    cmsVC.cmsEnum = .PrivacyPolicy
                }
                
                self.navigationController?.pushViewController(cmsVC, animated: true)
            }
        case 7:
            //... Contact Us
            
            appDelegate?.openMailComposer(self, email: "")
            
        case 9:
            //...LogOut
            
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CLogOutMessage, btnOneTitle: CYes, btnOneTapped: { (action) in
                
                let arrCart = TblCart.fetchAllObjects()
                
                if (arrCart?.count)! > 0 {
                     self.addCartOnServer()
                }
               
                appDelegate?.isFromLoginPop = false
                appDelegate?.logout()
                
            }, btnTwoTitle: CNo) { (action) in
            }
            
        default:
            print("")
        }
    }
}

//MARK:-
//MARK:- Change Notification Status

extension ProfileViewController {
    
    @objc func switchChanged(sender : UISwitch) {
        
        if sender.isOn {
            sender.isOn = true
        } else {
            sender.isOn = false
        }
        
        APIRequest.shared().changeNotificationStatus(isNotify: sender.isOn) { (response, error) in
            
            if response != nil && error == nil {
                
                APIRequest.shared().saveUserDetailToLocal(response: response as! [String : AnyObject])
            }
        }
    }
}

//MARK:-
//MARK:- API Method

extension ProfileViewController {
    
    func addCartOnServer() {
        
        var arrCart = [[String : AnyObject]]()
        var additionalCharge = 0.0
        var subTotal = 0.0
        
        
        let arrRes = TblCartRestaurant.fetchAllObjects() as! [TblCartRestaurant]
        let resDetail =  arrRes[0]
        
        var arrADPrice = [[String : AnyObject]]()
        let arrAD = resDetail.additional_tax as? [[String : AnyObject]]
        let arrCartList =  TblCart.fetchAllObjects() as! [TblCart]
      
        
        //...Get cart list
        for cart in arrCartList {

            let total = cart.dish_price * Double(cart.quantity)
            subTotal = subTotal + total
            
            let keys = cart.entity.attributesByName.keys
            var dicTest : Dictionary = cart.dictionaryWithValues(forKeys: Array(keys))

            dicTest.removeValue(forKey: CRestaurant_id)
            dicTest.removeValue(forKey: CStatus_id)
            dicTest.removeValue(forKey: CIs_available)

            arrCart.append(dicTest as [String : AnyObject])
        }

        
        //...Get Additional charge list
        for item in arrAD! {
            
            var dict = item
            var amount = 0.0
            
            if dict.valueForString(key: "tax_type") == "1" {
                amount = ((subTotal * dict.valueForDouble(key: "tax_amount")! / 100).roundToPlaces(places: 2))
                
            } else {
                amount = (dict.valueForDouble(key: "tax_amount")!)
            }
            
            dict.removeValue(forKey: "tax_id")
            dict["order_tax_amount"] = amount as AnyObject
            
            arrADPrice.append(dict)
            
            additionalCharge = additionalCharge + amount
        }
        
        
        let taxPrice = subTotal * resDetail.tax / 100
        let totalToPay = subTotal + taxPrice + additionalCharge
        

        let dict = [CRestaurant_id : resDetail.restaurant_id as AnyObject,
                    CSubtotal : subTotal as AnyObject ,
                    CTax_percent : resDetail.tax,
                    CTax_amount : subTotal * resDetail.tax / 100 ,
                    COrder_total : totalToPay as Any,
                    CCart : arrCart,
                    CAdditional_tax : arrADPrice,
                    CCart_id : CUserDefaults.object(forKey: UserDefaultCartID) != nil ? CUserDefaults.object(forKey: UserDefaultCartID) as Any : 0] as [String : AnyObject]
        
        
        APIRequest.shared().addCart(param: dict) { (response, error) in
            
            if response != nil && error == nil {
                
                print("Add Cart : ",response as Any)
                
                let dataRes = response?.value(forKey: CJsonData) as! [String : AnyObject]
                
                CUserDefaults.set(dataRes.valueForInt(key: CCart_id), forKey: UserDefaultCartID)
                CUserDefaults.synchronize()
            }
        }
    }
}
