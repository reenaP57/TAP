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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        arrRestData = [["res_name":"Cafe de perks", "res_location":"Alpha One Mall", "Cuisine":"Rolls - Desserts - Fast Food", "rating":"4.0", "time":"", "like_status":0],
                       ["res_name":"Dominoz", "res_location":"Alpha One Mall", "Cuisine":"Rolls - Desserts - Fast Food", "rating":"4.0", "time":"Opens at 7 PM", "like_status":1],
                       ["res_name":"Barbeque Nation", "res_location":"Alpha One Mall", "Cuisine":"Rolls - Desserts - Fast Food", "rating":"4.0", "time":"Opens at 7 PM", "like_status":1]]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
            
            let dict = arrRestData[indexPath.row] as? [String : AnyObject]
            
            cell.lblRestName.text = dict?.valueForString(key: "res_name")
            cell.lblResLocation.text = dict?.valueForString(key: "res_location")
            cell.lblCuisines.text = dict?.valueForString(key: "Cuisine")
            cell.lblRating.text = dict?.valueForString(key: "rating")
            cell.lblTime.text = dict?.valueForString(key: "time")
            
            if dict?.valueForInt(key: "like_status") == 0 {
                cell.btnLike.isSelected = false
            } else{
                cell.btnLike.isSelected = true
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let resDetailVC = CMain_SB.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as? RestaurantDetailViewController {
            self.viewController?.navigationController?.pushViewController(resDetailVC, animated: true)
        }
    }
}
