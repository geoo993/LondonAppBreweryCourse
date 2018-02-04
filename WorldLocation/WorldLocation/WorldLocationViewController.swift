//
//  WorldLocationViewController.swift
//  WorldLocation
//
//  Created by GEORGE QUENTIN on 03/02/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//
// https://www.youtube.com/watch?v=UyiuX8jULF4
// https://www.youtube.com/watch?v=Z272SMC9zuQ
// https://www.youtube.com/watch?v=Idzn65L4p-A
// https://www.latlong.net/
// https://www.youtube.com/watch?v=nhUHzst6x1U
// https://www.appcoda.com/mapkit-beginner-guide/

import UIKit
import MapKit
import CoreLocation
import AppCore

/*
 
 //NSLocationAlwaysUsageDescription
 Location Always Usage Description – This pops up when we request access to the location even when the App is closed

 //NSLocationWhenInUseUsageDescription
 Location When In Use Usage Description – This pops up when we request access to the location only when the App is open
 
 */
public class WorldLocationViewController: UIViewController {

    
    @IBOutlet weak var map : MKMapView!
    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var addressLabel : UILabel!
    @IBAction func update(_ sender: UIButton) {
        getLocation()
    }
    
    @IBAction func next(_ sender: UIButton) {
        placesIndex = (placesIndex + 1) % places.count 
        getLocation()
    }
    
    let manager = CLLocationManager()
    var locationManager: LocationManager!
    var placesIndex = 0
    var places = ["Drysdale Building",
                  "Applied Vision Research Centre", 
                  "City Bar", "Home", 
                  //"Current Location"
    ]
    var placesLocations = [
        "Drysdale Building": CLLocation(latitude: 51.527062043612816, longitude: -0.10339915752410889),
        "Applied Vision Research Centre": CLLocation(latitude: 51.52767112333336, longitude: -0.10222971439361572),
        "City Bar": CLLocation(latitude: 51.528041573315456, longitude:  -0.10065525770187378),
        "Home": CLLocation(latitude: 51.4365389, longitude: -0.12284639999995761),
        "Current Location": CLLocation(latitude: 0, longitude: 0)
    ]
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        locationManager = LocationManager.sharedInstance
        
        if getAutorization() {
            
            setupMap()
            getLocation()
        }
        
    }
    
    func getAutorization () -> Bool {
        let autorisation = CLLocationManager.authorizationStatus()
        switch autorisation {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .restricted, .denied:
            return false
        case .notDetermined:
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
    }
   
    func getLocation () {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.stopUpdatingLocation()
        manager.startUpdatingLocation()
        locationManager
            .startUpdatingLocationWithCompletionHandler { [unowned self] (latitude, longitude, status, verboseMessage, error) in
                
                let currentCoordinates = CLLocation(latitude: latitude, longitude: longitude)
                self.placesLocations["Current Location"] = currentCoordinates
                
                let place = self.places[self.placesIndex]
                if let placesCoordinates = self.placesLocations[place] {
                    //self.update(name: place, location: location )
                    self.update(direction: currentCoordinates, to: placesCoordinates, transportType: .walking)
                }
        }
    }
    
    func update(direction from: CLLocation, to: CLLocation, transportType: MKDirectionsTransportType) {
        let sourceCoordinates2D = CLLocationCoordinate2DMake(from.coordinate.latitude, from.coordinate.longitude)
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinates2D)
        let sourcesMapItem = MKMapItem(placemark: sourcePlaceMark)
        annotateMap(with: "Me", location2D: sourceCoordinates2D)
        
        let destinationCoordinates2D = CLLocationCoordinate2DMake(to.coordinate.latitude, to.coordinate.longitude)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationCoordinates2D)
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        annotateMap(with: "", location2D: destinationCoordinates2D)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourcesMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = transportType
        
        let direction = MKDirections(request: directionRequest)
        direction.calculate { [unowned self] (response, error) in
            guard let response = response else { 
                if let error = error {
                    print("Error calculating directions:\(error)")
                }
                return 
            }
            
            if let route = response.routes.first {
                self.map.add(route.polyline, level: .aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                let region = MKCoordinateRegionForMapRect(rect)
                self.map.setRegion(region, animated: true)
            }
        }
    }
    
    func update(name: String, location: CLLocation) {
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.04, 0.04)
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let locationCoordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegionMake(locationCoordinates, span)
        map.setRegion(region, animated: true)
        
        let locationPinCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotateMap(with: name, location2D: locationPinCoordinate)
        
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
    
    func annotateMap(with name : String, location2D: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.subtitle = "AR Places"
        annotation.coordinate = location2D
        map.addAnnotation(annotation)
        map.showAnnotations([annotation], animated: true)
    }
    
    func setupMap() {
        map.delegate = self
        map.showsScale = true
        map.showsPointsOfInterest = true
        map.showsUserLocation = true
    }
    
}

// MARK: - CLLocationManagerDelegate
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

// MARK: - CLLocationManagerDelegate
extension WorldLocationViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.random
        renderer.lineWidth = 5
        return renderer
    }
}
