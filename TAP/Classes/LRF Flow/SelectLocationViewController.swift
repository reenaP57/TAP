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
    var arrLocation = [TblRecentLocation]()
    

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
        
      //  else if appDelegate?.loginUser == nil && !(appDelegate?.isCurrentLoc)!{
        //    lblCurrentLoc.text = appDelegate?.dictLocation[CAddress] as? String
      //  }
        
        if let _ = CUserDefaults.value(forKey: CLatitude) as? CLLocationDegrees, let _ = CUserDefaults.value(forKey: CLongitude) as? CLLocationDegrees
        {
                  lblCurrentLoc.text = CUserDefaults.object(forKey: UserDefaultCurrentLocation) as? String
        } else {
            lblCurrentLoc.text = CCurrentLocation
        }
 
        
//        if (appDelegate?.loginUser != nil && appDelegate?.loginUser?.latitude != nil && appDelegate?.loginUser?.longitude != nil) && !(appDelegate?.isCurrentLoc)! {
//            lblCurrentLoc.text = appDelegate?.loginUser?.address
//        } else {
//             lblCurrentLoc.text = CUserDefaults.object(forKey: UserDefaultCurrentLocation) as? String
//        }
        
       
        self.fetchRecentLocationList()
        
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
    }

}

//MARK:-
//MARK:- Action

extension SelectLocationViewController {
   
    @IBAction func btnClearAllListClicked(sender : UIButton) {
        TblRecentLocation.deleteAllObjects()
        arrLocation.removeAll()
        tblLocation.reloadData()
    }
    
     @IBAction func btnCurrentLocationClicked(sender : UIButton) {
        
        if let _ = CUserDefaults.value(forKey: CLatitude) as? CLLocationDegrees, let _ = CUserDefaults.value(forKey: CLongitude) as? CLLocationDegrees
        {
            appDelegate?.isCurrentLoc = true
            appDelegate?.tabbarController = TabbarViewController.initWithNibName() as? TabbarViewController
            appDelegate?.setWindowRootViewController(rootVC: appDelegate?.tabbarController, animated: true, completion: nil)
            
        } else {
           
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    
                    self.presentAlertViewWithTwoButtons(alertTitle: CLocationPermissionTitle, alertMessage: CLocationpermissionMsg, btnOneTitle: CSetting, btnOneTapped: { (action) in
                        
                        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)")
                            })
                        }
                        
                    }, btnTwoTitle: CCancel) { (action) in
                    }
                    
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                }
            } else {
                print("Location services are not enabled")
            }
        }
    }
}


//MARK:-
//MARK:- CustomSearchView Delegate

extension SelectLocationViewController : customSearchViewDelegate {
    
    func showNextScreen() {
        //...Open Google Picker
        vwCustomSearch?.searchBar.resignFirstResponder()
        showPickerWithCurrentLocation()
    }
    
    func clearSearchText() {
    }
}


//MARK:-
//MARK:- Google Picker Delegate


extension SelectLocationViewController : GMSPlacePickerViewControllerDelegate{
    
    func showPickerWithCurrentLocation()
    {
        if let latitude = CUserDefaults.value(forKey: CLatitude) as? CLLocationDegrees, let longitude = CUserDefaults.value(forKey: CLongitude) as? CLLocationDegrees
        {
        
        let center = CLLocationCoordinate2DMake(latitude, longitude)
            let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
            let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
            let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            let config = GMSPlacePickerConfig(viewport: viewport)
            self.showPlacePicker(config: config)
            
        } else {
            
            let center = CLLocationCoordinate2DMake(0.0, 0.0)
            let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
            let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
            let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            let config = GMSPlacePickerConfig(viewport: viewport)
            self.showPlacePicker(config: config)
        }
    }
    
    func showPlacePicker(config: GMSPlacePickerConfig)
    {
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
    }
    
    
    //...Called when a place has been selected
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {

        viewController.dismiss(animated: true) {
            self.vwCustomSearch?.searchBar.text = place.formattedAddress
            self.vwCustomSearch?.btnClear.hide(byWidth: false)
            appDelegate?.isCurrentLoc = false
            
            if appDelegate?.loginUser?.user_id != nil {
                appDelegate?.loginUser?.latitude = place.coordinate.latitude
                appDelegate?.loginUser?.longitude = place.coordinate.longitude
                appDelegate?.loginUser?.address = place.name
                CoreData.saveContext()
                
            } else {
                
                //...Save in lat,long and place name in dictionary for guest user to pass in restuarant api
                appDelegate?.dictLocation.removeAll()
                appDelegate?.dictLocation[CLatitude] = place.coordinate.latitude as AnyObject
                appDelegate?.dictLocation[CLongitude] = place.coordinate.longitude as AnyObject
                appDelegate?.dictLocation[CAddress] = place.name as AnyObject
                
//                CUserDefaults.set(place.coordinate.latitude, forKey: CLatitude)
//                CUserDefaults.set(place.coordinate.longitude, forKey: CLongitude)
//                CUserDefaults.set(place.name, forKey: UserDefaultCurrentLocation)
//                CUserDefaults.synchronize()
            }
            
            
            if place.formattedAddress != nil {
                
                let dict = ["id" : place.placeID,
                            "name" : place.name,
                            "address" : place.formattedAddress as Any,
                            "latitude" : place.coordinate.latitude,
                            "longitude" : place.coordinate.longitude] as [String : AnyObject]
                
                self.saveRecentLocation(dict: dict)
            }
            
            appDelegate?.tabbarController = TabbarViewController.initWithNibName() as? TabbarViewController
            appDelegate?.setWindowRootViewController(rootVC: appDelegate?.tabbarController, animated: true, completion: nil)
        }
        
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
        return arrLocation.count > 20 ? 20 : arrLocation.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLocationTableViewCell") as? SelectLocationTableViewCell {
            
            let dict = arrLocation[indexPath.row]
            
            cell.lblLocation.text = dict.name
            cell.lblLocationName.text = dict.address
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = arrLocation[indexPath.row]
        appDelegate?.isCurrentLoc = false
        
        
        if appDelegate?.loginUser?.user_id != nil {
            
            appDelegate?.loginUser?.latitude = dict.latitude
            appDelegate?.loginUser?.longitude = dict.longitude
            appDelegate?.loginUser?.address = dict.name
            CoreData.saveContext()
        } else {
            
            //...Save in lat,long and place name in dictionary for guest user to pass in restuarant api
            appDelegate?.dictLocation.removeAll()
            appDelegate?.dictLocation[CLatitude] = dict.latitude as AnyObject
            appDelegate?.dictLocation[CLongitude] = dict.longitude as AnyObject
            appDelegate?.dictLocation[CAddress] = dict.name as AnyObject

        }
 

        appDelegate?.tabbarController = TabbarViewController.initWithNibName() as? TabbarViewController
        appDelegate?.setWindowRootViewController(rootVC: appDelegate?.tabbarController, animated: true, completion: nil)
        
    }
    
}


//MARK:-
//MARK:- Store Recent Location in Local and FetchK

extension SelectLocationViewController {
    
    func saveRecentLocation(dict : [String : AnyObject]) {
        
        let tblRecentLocation = TblRecentLocation.findOrCreate(dictionary: ["place_id": dict.valueForString(key: "id"), "user_id" : appDelegate?.loginUser?.user_id ?? 0]) as! TblRecentLocation
        
        tblRecentLocation.name = dict.valueForString(key: "name")
        tblRecentLocation.address = dict.valueForString(key: "address")
        tblRecentLocation.latitude = dict.valueForDouble(key: "latitude")!
        tblRecentLocation.longitude = dict.valueForDouble(key: "longitude")!
        tblRecentLocation.index = Int64((TblRecentLocation.fetchAllObjects()?.count)!)+1
        
        CoreData.saveContext()
    }
    
    func fetchRecentLocationList() {
        
        let arrData = TblRecentLocation.fetch(predicate: NSPredicate(format: "%K == %@", "user_id", "\(appDelegate?.loginUser?.user_id ?? 0)"), orderBy: "index", ascending: false)
        
        if (arrData?.count)! > 0 {
            arrLocation = (arrData as? [TblRecentLocation])!.sorted(by: { $0.index > $1.index })
        }
        tblLocation.reloadData()
    }
    
}
