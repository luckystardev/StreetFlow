//
//  MapVC.swift
//  StreetFlow
//
//  Created by Alex on 3/12/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import JGProgressHUD

class MapVC: BaseVC , MKMapViewDelegate, CLLocationManagerDelegate { //

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var infoView: RoundView!
    @IBOutlet weak var popInfoView: RoundView!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var popNameLbl: UILabel!
    @IBOutlet weak var popStreetLbl: UILabel!
    @IBOutlet weak var popAddressLbl: UILabel!
    
    var locationManager = CLLocationManager()
    var isSuccess = false
    var mUserLocation:CLLocation!
    let lDelta = 0.002
    var currentArtwork: Artwork?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.addShadowEffect()
        popInfoView.addShadowEffect()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(setCurrentLocation), name: Notification.Name("CurrentLocation"), object: nil)
        
        getProperties()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getProperties() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = ""
        hud.show(in: self.view)
        
        let webService =  RestAPIManager.sharedManager
        webService?.readAllProperties(callback: { (responseObject:Array<Any>?, error:NSError?) in
            hud.dismiss()
            if((error) != nil){ //error
                if let descrip = error?.localizedDescription{
                    self.showErrorAlert(title: descrip)
                }
            }else{ //success
                print("success")
                print(responseObject?.count as Any)
                print(responseObject!)
                ary_properties = responseObject
                if ary_properties != nil {
                    self.addPropertyPins()
                }
            }
        })
    }
    
    func addPropertyPins() {
        for (index, dic) in ary_properties.enumerated() {
            if let property = dic as? [String: Any] {
                var name: String = ""
                var address: String = ""
                var street: String = ""
                
                if let owner = property["owner_property"]! as? [String: String] {
                    name = owner["owner"]!
                    street = owner["property_label"]!
                    address = owner["address"]!
                }
                if let location = property["geo"]! as? [String: Double] {
                    let newcodi = CLLocationCoordinate2D(latitude: Double(location["lat"]!), longitude: Double(location["lon"]!))
                    
                    if index ==  ary_properties.count - 1 {
                        let span = MKCoordinateSpan(latitudeDelta: lDelta, longitudeDelta: lDelta)
                        let mRegion = MKCoordinateRegion(center: newcodi, span: span)
                        map.setRegion(mRegion, animated: true)
                    }
                    
                    let artwork = Artwork(name: name, street: street, address: address, coordinate: newcodi, index: index)
                    self.map.addAnnotation(artwork)
                }
            }
        }
    }
    
    func popupPropertyView() {
        popNameLbl.text = currentArtwork?.name
        popStreetLbl.text = currentArtwork?.street
        popAddressLbl.text = currentArtwork?.address
        
        /*
        var info: [String : String?]?
        info = getbasicInfo()
        if info?["name"] != "" {
            let ownerStr = info?["name"] ?? ""
            popNameLbl.text = updateFullname(ownerStr!)
            popStreetLbl.text = info?["formatted_street_address"] ?? ""
            let city : String = (info?["city"] ?? "") ?? " "
            let state : String = (info?["state"] ?? "") ?? " "
            let zip_code : String = (info?["zip_code"] ?? "") ?? " "
            let address : String = city + ", " + state + " " + zip_code
            popAddressLbl.text = address
        } */
        
        infoView.isHidden = true
        popInfoView.isHidden = false
    }
    
    func dismissPropertyView() {
        infoView.isHidden = false
        popInfoView.isHidden = true
    }
    
    @IBAction func dropDownBtnAction(_ sender: Any) {
        let dic = ary_properties[currentArtwork!.index]
        if let property = dic as? [String: Any] {
            pp_data = property
        }
        popNextVCWithID("DealVC", isFull: false)
    }
    
    @IBAction func dismissBtnAction(_ sender: Any) {
        dismissPropertyView()
    }
    
    @IBAction func addPropertyBtnAction(_ sender: Any) {
        //TODO
    }
    
    @IBAction func tapPopInfoView(_ sender: Any) {
//        popNextVCWithID("DealVC", isFull: false)
    }
    
    @objc private func setCurrentLocation(notification: NSNotification){
        print("setCurrentLocation")
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: lDelta, longitudeDelta: lDelta)
        let mRegion = MKCoordinateRegion(center: center, span: span)

        map.setRegion(mRegion, animated: true)
    }
    
    //MARK:- CLLocationManagerDelegate Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        
        
        mUserLocation = locations[0] as CLLocation

        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: lDelta, longitudeDelta: lDelta)
        let mRegion = MKCoordinateRegion(center: center, span: span)

        map.setRegion(mRegion, animated: true)
        
        /*
        let geocoder = CLGeocoder()
            
        // Look up the location and pass it to the completion handler
                
        geocoder.reverseGeocodeLocation(mUserLocation,
                    completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                print("===============")
                let placename: String = (firstLocation?.subThoroughfare)! + " " + (firstLocation?.thoroughfare)! + ", " + (firstLocation?.locality)! + ", " + (firstLocation?.administrativeArea)! + " " + (firstLocation?.postalCode)! //+ ", " + (firstLocation?.country)!
                print(placename)
                self.getEstatedInfo(placename) { (flag, result) in
                    if !flag {
                        print("failed!!!")
                        DispatchQueue.main.async {
                            self.infoLbl.text = result
                            
                            let hud2 = JGProgressHUD(style: .dark)
                            hud2.textLabel.text = result
                            hud2.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud2.show(in: self.view)
                            hud2.dismiss(afterDelay: 2.0)
                        }
                    } else {
                        print("success!!!")
                        DispatchQueue.main.async {
                            self.infoLbl.text = "Tap on a property to pick"
                            let newPin = MKPointAnnotation()
                            newPin.coordinate = self.mUserLocation.coordinate
                            self.map.addAnnotation(newPin)
                        }
                        self.isSuccess = true
                    }
                }
            }
        }) */
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
//        if let annotationTitle = view.annotation?.title
//        {
//            self.popupPropertyView()
//        }
        guard let artwork = view.annotation as? Artwork else {
          return
        }
        currentArtwork = artwork
        self.popupPropertyView()
    }
}

class Artwork: NSObject, MKAnnotation {
    let name: String?
    let street: String?
    let address: String?
    let coordinate: CLLocationCoordinate2D
    let index: Int
    init(
      name: String?,
      street: String?,
      address: String?,
      coordinate: CLLocationCoordinate2D,
      index: Int
    ) {
      self.name = name
      self.street = street
      self.address = address
      self.coordinate = coordinate
      self.index = index
        
      super.init()
    }
}
