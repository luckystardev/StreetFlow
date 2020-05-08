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
        
        // This is test code
//        let location = CLLocationCoordinate2D(latitude: 37.785834,
//                                              longitude: -122.406417)
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: location, span: span)
//        map.setRegion(region, animated: true)
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        annotation.title = "Big Ben"
//        annotation.subtitle = "New York"
//        map.addAnnotation(annotation)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(setCurrentLocation), name: Notification.Name("CurrentLocation"), object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func popupPropertyView() {
        var info: [String : String?]?
        info = getbasicInfo()
        if info?["name"] != "" {
            var ownerStr = info?["name"] ?? ""
            ownerStr = ownerStr?.replacingOccurrences(of: ";", with: ", ")
            popNameLbl.text = ownerStr
            popStreetLbl.text = info?["formatted_street_address"] ?? ""
            let city : String = (info?["city"] ?? "") ?? " "
            let state : String = (info?["state"] ?? "") ?? " "
            let zip_code : String = (info?["zip_code"] ?? "") ?? " "
            let address : String = city + ", " + state + " " + zip_code
            popAddressLbl.text = address
        }
        
        infoView.isHidden = true
        popInfoView.isHidden = false
    }
    
    func dismissPropertyView() {
        infoView.isHidden = false
        popInfoView.isHidden = true
    }
    
    @IBAction func dropDownBtnAction(_ sender: Any) {
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
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let mRegion = MKCoordinateRegion(center: center, span: span)

        map.setRegion(mRegion, animated: true)
    }
    
    //MARK:- CLLocationManagerDelegate Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        
        mUserLocation = locations[0] as CLLocation

        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let mRegion = MKCoordinateRegion(center: center, span: span)

        map.setRegion(mRegion, animated: true)
        
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
        })
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
        if self.isSuccess {
            self.popupPropertyView()
        }
    }
    
    func estateDataToDictionary(_ data:Any) {
        
    }
}

