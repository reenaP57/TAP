//
//  SelectLocationViewController.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlacePicker

enum fromType {
    case FromHome
    case FromOther
}


class SelectLocationViewController: ParentViewController {

    @IBOutlet weak var lblCurrentLoc : UILabel!
    @IBOutlet weak var tblLocation : UITableView!

    var vwCustomSearch : CustomSearchView?
    var arrLocation = [Any]()
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!

    var type = fromType.FromOther
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        appDelegate?.hideTabBar()
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        
        arrLocation = ["New York, NY","San Fransisco, CA","Washington, DC","London, UK","Chicago, LA","Los Angeles, CA","Atlanta, GA","Austin, TX","Boston, MA","Houston, TX","Seattle, WA","Dallas, TX"]
        
        
        DispatchQueue.main.async {
            
            if let customeView = CustomSearchView.viewFromXib as? CustomSearchView
            {
                customeView.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: 44)
                customeView.searchBar.placeholder = CSearchYourLocation
                self.vwCustomSearch = customeView
                self.vwCustomSearch?.delegate = self
                self.navigationItem.titleView = self.vwCustomSearch
                
                if self.type == .FromOther {
                    self.vwCustomSearch?.btnBack.hide(byWidth: true)
                    self.vwCustomSearch?.layoutSearchBarTrailing.constant = 0
                    self.vwCustomSearch?.layoutWidthSearchbar.constant = CScreenWidth - 20
                    
                } else {
                    self.vwCustomSearch?.btnBack.hide(byWidth: false)
                    self.vwCustomSearch?.layoutSearchBarTrailing.constant = 0
                    self.vwCustomSearch?.layoutWidthSearchbar.constant = CScreenWidth - (self.vwCustomSearch?.btnBack.CViewWidth ?? 45.0) - 20.0
                }
            
                
                
                customeView.btnBack.touchUpInside { (sender) in
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
        
        
        locManager.requestWhenInUseAuthorization()
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            currentLocation = locManager.location
        }
        
    }

}


//MARK:-
//MARK:- CustomSearchView Delegate

extension SelectLocationViewController : customSearchViewDelegate {
    
    func showNextScreen() {
        //...Open Google Picker
        
        showPickerWithCurrentLocation()
    }
}


//MARK:-
//MARK:- Google Picker Delegate


extension SelectLocationViewController : GMSPlacePickerViewControllerDelegate{
    
    func showPickerWithCurrentLocation()
    {
        var latitude = 23.0524
        var longitude = 72.5337
        
//        if !IS_iPhone_Simulator {
//
//            if currentLocation != nil {
//                latitude = currentLocation.coordinate.latitude
//                longitude = currentLocation.coordinate.longitude
//            }
//
//        }
        
        
//        if let latitude = CUserDefaults.value(forKey: CLatitude) as? CLLocationDegrees, let longitude = CUserDefaults.value(forKey: CLongitude) as? CLLocationDegrees
//        {
//            MILoader.shared.hideLoader()
            let center = CLLocationCoordinate2DMake(latitude, longitude)
            let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
            let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
            let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            let config = GMSPlacePickerConfig(viewport: viewport)
            self.showPlacePicker(config: config)
            
  //      }
        
    }
    
    func showPlacePicker(config: GMSPlacePickerConfig)
    {
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
    }
    
    
    //...Called when a place has been selected
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        
        viewController.dismiss(animated: true, completion: nil)
        
        vwCustomSearch?.searchBar.text = place.formattedAddress
        vwCustomSearch?.btnClear.hide(byWidth: false)
        
        print("Place : ",place)
        print("Name : ",place.name)
        print("coordinate : ",place.coordinate.latitude, place.coordinate.longitude)
        print("address : ",place.formattedAddress)
        print("id : ",place.placeID)
        
    }
    
    //...Called when the place picking operation has been cancelled.
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
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
