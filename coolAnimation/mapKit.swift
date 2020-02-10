//
//  mapKit.swift
//  coolAnimation
//
//  Created by Andrew on 10/5/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol sendLocationData {
    func sendLocation(citiName: String,countryName: String)
}

class location: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.isScrollEnabled = true
        map.isZoomEnabled = true
        map.delegate = self
        map.showsUserLocation = true
        return map
    }()
    let locationManager = CLLocationManager()
    
    var chooseDelegate: sendLocationData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveLocation))
        view.addSubview(mapView)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        addConstraints()
        
        
    }
    var cityName: String! = nil
    var countryName: String! = nil
    func setUpLocation(latitude: CLLocationDegrees,longitude: CLLocationDegrees){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location){(placemarks, error) -> Void in
            
            let placeArray = placemarks as [CLPlacemark]!
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            
//            if let locationName = placeMark.addressDictionary?["Name"] as? NSString
//            {
//                print(locationName)
//            }
            
            
            // City
            if let city = placeMark.addressDictionary?["City"] as? NSString
            {
                self.cityName = city as String!
            }
            
            
            // Country
            if let country = placeMark.addressDictionary?["Country"] as? NSString
            {
                self.countryName = country as String!
            }
        }
    }
    
    func addConstraints(){
        
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        setUpLocation(latitude: center.latitude,longitude: center.longitude)
    }
    
    @objc func saveLocation(){
        
        if countryName != nil && cityName != nil{
            self.chooseDelegate.sendLocation(citiName: cityName, countryName: countryName)
            dismiss(animated: true, completion: nil)
        }
    }
    
}



