//
//  RestaurantDetailHeaderView.swift
//  TAP
//
//  Created by mac-00017 on 12/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

protocol selectCategoryProtocol : class {
    func selectCategory(categoryID : String)
}

class RestaurantDetailHeaderView: UIView {

    var delegate : selectCategoryProtocol?
    
    @IBOutlet weak var lblNoDishMsg : UILabel!
    @IBOutlet weak var collCategory : UICollectionView! {
        didSet {
            collCategory.register(UINib(nibName: "RestaurantCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RestaurantCategoryCollectionViewCell")
        }
    }
    
    var arrCategoryDetail = [[String : Any]]()
    var categoryID : String?
    
    
    func loadCategoryList(arrCategory : [[String : Any]], categoryId : String) {
        
        arrCategoryDetail = arrCategory
        collCategory.reloadData()
        categoryID = categoryId
        
        if arrCategoryDetail.count > 0 {
            collCategory.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}


//MARK:-
//MARK:- UICollectionView Delegate and Datasource Method

extension RestaurantDetailHeaderView : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrCategoryDetail.count > 0 ? arrCategoryDetail.count + 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fontToResize =  CFontSFUIText(size: 12 , type: .Regular).setUpAppropriateFont()
        var strCategoryName = ""
        
        if indexPath.row == 0 {
             strCategoryName = "Most Popular"
        } else {
            let dict = arrCategoryDetail[indexPath.row - 1]
            strCategoryName = dict.valueForString(key: CDish_category_name)
        }
        
      
        return CGSize(width: strCategoryName.size(withAttributes: [NSAttributedStringKey.font: fontToResize as Any]).width + 32, height: collectionView.CViewHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCategoryCollectionViewCell", for: indexPath) as? RestaurantCategoryCollectionViewCell {
            
            if indexPath.item == 0 {
                cell.lblCategory.text  = "Most Popular"
                cell.accessibilityLabel = ""
            } else {
                
                let dict = arrCategoryDetail[indexPath.row - 1]
                cell.lblCategory.text = dict.valueForString(key: CDish_category_name)
                cell.accessibilityLabel = "\(dict["dish_category_id"] ?? "")"
            }
            
            
            if cell.accessibilityLabel == categoryID
            {
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
            categoryID = cell.accessibilityLabel
            
            if delegate != nil {
                delegate?.selectCategory(categoryID: cell.accessibilityLabel ?? "")
                self.collCategory.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? RestaurantCategoryCollectionViewCell {
            
            cell.lblCategory.backgroundColor = .white
            cell.lblCategory.textColor = .black
            cell.lblCategory.layer.borderWidth = 1.0
            cell.lblCategory.layer.borderColor = CColorCement.cgColor
        }
    }
}
