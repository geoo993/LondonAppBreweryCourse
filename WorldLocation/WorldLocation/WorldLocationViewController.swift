//
//  WorldLocationViewController.swift
//  WorldLocation
//
//  Created by GEORGE QUENTIN on 03/02/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//
// https://www.youtube.com/watch?v=UyiuX8jULF4
// https://www.youtube.com/watch?v=Z272SMC9zuQ

import UIKit
import MapKit
import CoreLocation
import AppCore

//NSLocationWhenInUseUsageDescription
//NSLocationAlwaysUsageDescription

public class WorldLocationViewController: UIViewController {

    @IBOutlet weak var map : MKMapView!
    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var addressLabel : UILabel!
    @IBAction func update(_ sender: UIButton) {
        getLocation()
    }
    
    let manager = CLLocationManager()
    var locationManager: LocationManager!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        locationManager = LocationManager.sharedInstance
        
        if getAutorization() {
            getLocation()
        }
        
    }
    
    func getAutorization () -> Bool {
        let autorisation = CLLocationManager.authorizationStatus()
        if autorisation == .notDetermined {
            let bundle = Bundle.main
            if bundle.object(forInfoDictionaryKey: "NSLocationAlwaysAndWhenInUseUsageDescription") != nil {
                manager.requestAlwaysAuthorization()
                print("notDetermined but Alway autorization")
                return true
            } else if bundle.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil {
                manager.requestWhenInUseAuthorization()
                print("notDetermined but Alway autorization")
                return true
            } else { 
                print("No description provided")
                return false 
            }
        }
        
        if autorisation == .authorizedWhenInUse || autorisation == .authorizedAlways {
            print("autorizated")
            return true
        }
        
        if autorisation == .restricted || autorisation == .denied {
            print("restricted or denied")
            return false
        }
        
        return true
    }
    
    @objc func requestAlwaysAuthorisation () {
        print("reponded to Always Usage Description")
    }
    
    @objc func requestWhenInUseAuthorisation() {
        print("reponded When In Use Usage Description")
    }
    
    func getLocation () {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.stopUpdatingLocation()
        manager.startUpdatingLocation()
        locationManager
            .startUpdatingLocationWithCompletionHandler { [unowned self] (latitude, longitude, status, verboseMessage, error) in
            self.update(location: CLLocation(latitude: latitude, longitude: longitude) )
        }
    }
    
    func update(location: CLLocation) {
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.04, 0.04)
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let locationCoordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegionMake(locationCoordinates, span)
        map.setRegion(region, animated: true)
        
        let locationPinCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationPinCoordinate
        map.addAnnotation(annotation)
        map.showAnnotations([annotation], animated: true)
        
        map.showsUserLocation = true
        
        print("latitude",location.coordinate.latitude, 
              ", longitude",location.coordinate.longitude, 
              ", altitude",location.altitude,
              ", speed", location.speed, 
              ", floor", location.floor?.level ?? 0)
        
        
        locationManager
            .reverseGeocodeLocationWithCoordinates(location) { [unowned self] (reverseGeoCodeInfo, placemark, error) in
                if let locationAddress = (reverseGeoCodeInfo?.object(forKey: "formattedAddress") as? String),
                    let subLocality = (reverseGeoCodeInfo?.object(forKey: "subLocality") as? String),
                    let postalCode = (reverseGeoCodeInfo?.object(forKey: "postalCode") as? String) {
                    self.locationLabel.text = locationAddress
                    self.addressLabel.text = subLocality + ", " + postalCode
                }
        }
    }
    
    
}

extension WorldLocationViewController: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //if let location = locations.first {
            //update(location: location)
        //}
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined || status != .denied || status != .restricted {
            getLocation()
        }
        
    }
}
