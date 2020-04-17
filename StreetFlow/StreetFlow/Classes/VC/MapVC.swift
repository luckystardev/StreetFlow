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

class MapVC: BaseVC , MKMapViewDelegate, CLLocationManagerDelegate { //

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var infoView: RoundView!
    @IBOutlet weak var popInfoView: RoundView!
    
    var locationManager = CLLocationManager()
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let mRegion = MKCoordinateRegion(center: center, span: span)

        map.setRegion(mRegion, animated: true)
        
        locationManager.stopUpdatingLocation()
        
        let geocoder = CLGeocoder()
            
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(mUserLocation,
                    completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                print(firstLocation as Any)
                print("===============")
                let placename: String = (firstLocation?.subThoroughfare)! + " " + (firstLocation?.thoroughfare)! + ", " + (firstLocation?.locality)! + ", " + (firstLocation?.administrativeArea)! + " " + (firstLocation?.postalCode)! //+ ", " + (firstLocation?.country)!
                print(placename)
                self.getEstatedInfo(placename)
            }
        })
    }
    
    func getEstatedInfo(_ address: String) {
        let baseUrl = "https://apis.estated.com/v4/property?token=cyoidbzD1vn0HwQsykSFLvLXKWVmFU&combined_address="
        let urlStr = baseUrl + address
        let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(urlString!)
        
        let url = URL(string:urlString!)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
        }

        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
//        if let annotationTitle = view.annotation?.title
//        {
            self.popupPropertyView()
//        }
    }
}
