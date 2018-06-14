//
//  RestaurantDetailHeaderView.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class RestaurantDetailHeaderView: UIView {

    @IBOutlet weak var collCategory : UICollectionView! {
        didSet {
            collCategory.register(UINib(nibName: "RestaurantCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RestaurantCategoryCollectionViewCell")
        }
    }
    
    var arrCategoryDetail = ["Most Popular","Veg Roll","Chicken Roll","Burgers","Sandwich","Pizza"]
    
   
    func loadCategoryList(arrCategory : [Any]) {
        
        arrCategoryDetail = arrCategory as! [String]
        collCategory.reloadData()
    }
}


//MARK:-
//MARK:- UICollectionView Delegate and Datasource Method

extension RestaurantDetailHeaderView : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategoryDetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fontToResize =  CFontSFUIText(size: 12 , type: .Regular).setUpAppropriateFont()
        let strCategoryName = arrCategoryDetail[indexPath.row]
        return CGSize(width: strCategoryName.size(withAttributes: [NSAttributedStringKey.font: fontToResize as Any]).width + 32, height: collectionView.CViewHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCategoryCollectionViewCell", for: indexPath) as? RestaurantCategoryCollectionViewCell {
            
            cell.lblCategory.text = arrCategoryDetail[indexPath.row]
            
            if cell.isSelected {
                cell.lblCategory.backgroundColor = CColorNavRed
                cell.lblCategory.textColor = .white
                cell.lblCategory.layer.borderWidth = 0.0
                cell.lblCategory.layer.borderColor = UIColor.clear.cgColor
                
            } else {
                cell.lblCategory.backgroundColor = .white
                cell.lblCategory.textColor = .black
                cell.lblCategory.layer.borderWidth = 1.0
                cell.lblCategory.layer.borderColor = CColorCement.cgColor
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? RestaurantCategoryCollectionViewCell {
            
            cell.lblCategory.backgroundColor = CColorNavRed
            cell.lblCategory.textColor = .white
            cell.lblCategory.layer.borderWidth = 0.0
            cell.lblCategory.layer.borderColor = UIColor.clear.cgColor
            cell.isSelected = true
            self.collCategory.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            if (delegate != nil)
//            {
//                self.collectionCategory.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//                delegate?.selectedCategory(strDishCategoryId: cell.accessibilityLabel ?? "")
//            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? RestaurantCategoryCollectionViewCell {
            
            cell.lblCategory.backgroundColor = .white
            cell.lblCategory.textColor = .black
            cell.lblCategory.layer.borderWidth = 1.0
            cell.lblCategory.layer.borderColor = CColorCement.cgColor
            cell.isSelected = false
        }
    }
}
