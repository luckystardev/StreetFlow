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

class MapVC: BaseVC, MKMapViewDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var infoView: RoundView!
    @IBOutlet weak var popInfoView: RoundView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.addShadowEffect()
        popInfoView.addShadowEffect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }
    
    func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func popupPropertyView() {
        infoView.isHidden = true
        popInfoView.isHidden = false
    }
    
    func dismissPropertyView() {
        infoView.isHidden = false
        popInfoView.isHidden = true
    }
    
    @IBAction func dropDownBtnAction(_ sender: Any) {
        dismissPropertyView()
    }
    
    @IBAction func dismissBtnAction(_ sender: Any) {
        dismissPropertyView()
    }
    
    @IBAction func addPropertyBtnAction(_ sender: Any) {
        //TODO
    }
    
    @IBAction func tapPopInfoView(_ sender: Any) {
        popNextVCWithID("DealVC", isFull: false)
    }
    
    //MARK:- CLLocationManagerDelegate Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation

        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        map.setRegion(mRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            self.popupPropertyView()
        }
    }
}
