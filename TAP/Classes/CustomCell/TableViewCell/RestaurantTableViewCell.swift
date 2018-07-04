//
//  RestaurantTableViewCell.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnSeeAll : UIButton!
    @IBOutlet weak var collVwRest : UICollectionView!

    var arrRestData = [Any]()
    var strType = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func loadRestaurantDetail(arrDetail : [[String : AnyObject]], type : String) {
        
        arrRestData = arrDetail
        strType = type
        collVwRest.reloadData()
    }
}



//MARK:-
//MARK:- UICollectionView Delegate and Datasource Method

extension RestaurantTableViewCell {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrRestData.count > 5 ? 5 : arrRestData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        
        return CGSize(width: (CScreenWidth - 10.0 - ((CScreenWidth * 35.0)/375)), height: collectionView.CViewHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCollectionViewCell", for: indexPath) as? RestaurantCollectionViewCell {
            
            var dict = arrRestData[indexPath.row] as? [String : AnyObject]
            
            cell.lblRestName.text = dict?.valueForString(key: CName)
            cell.lblResLocation.text = dict?.valueForString(key: CAddress)
            cell.lblRating.text = "\(dict?.valueForDouble(key: CAvg_rating) ?? 0.0)"
            cell.vwRating.rating = (dict?.valueForDouble(key: CAvg_rating))!
            
            cell.imgVRest.sd_setShowActivityIndicatorView(true)
            cell.imgVRest.sd_setImage(with: URL(string: (dict?.valueForString(key: CImage))!), placeholderImage: nil)
            
            let arrCuisine = dict?.valueForJSON(key: CCuisine) as? [[String : AnyObject]]
            let arrCuisineName = arrCuisine?.compactMap({$0[CName]}) as? [String]
            cell.lblCuisines.text = arrCuisineName?.joined(separator: "-")
            
            
            if dict?.valueForInt(key: COpen_Close_Status) == 0 {
                cell.lblClosed.hide(byWidth: false)
                cell.lblTime.text = "Open at \(dict?.valueForString(key: COpen_time) ?? "")"
            } else {
                cell.lblClosed.hide(byWidth: true)
                cell.lblTime.text = ""
            }
            
            
            if dict?.valueForInt(key: CFav_status) == 0 {
                cell.btnLike.isSelected = false
            } else{
                cell.btnLike.isSelected = true
            }
            
            
            cell.btnLike.touchUpInside { (sender) in
                
                //...Open login Popup If user is not logged In OtherWise Like
                
                if appDelegate?.loginUser?.user_id == nil{
                    appDelegate?.openLoginPopup(viewController: self.viewController!)
                } else{
                    
                    appDelegate?.updateFavouriteStatus(restaurant_id: (dict?.valueForInt(key: CId))!, sender: cell.btnLike, completionBlock: { (response) in
                        
                        let data = response.value(forKey: CJsonData) as! [String : AnyObject]
                        
                        dict![CFav_status] = data.valueForInt(key: CIs_favourite) as AnyObject
                        self.arrRestData[indexPath.row] = dict as Any
                        self.collVwRest.reloadItems(at: [indexPath])
                    })
                }
            }
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = arrRestData[indexPath.row] as? [String : AnyObject]
        
        if let resDetailVC = CMain_SB.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as? RestaurantDetailViewController {
            resDetailVC.restaurantID = dict?.valueForInt(key: CId)
            resDetailVC.strType = strType
            self.viewController?.navigationController?.pushViewController(resDetailVC, animated: true)
        }
    }
}
