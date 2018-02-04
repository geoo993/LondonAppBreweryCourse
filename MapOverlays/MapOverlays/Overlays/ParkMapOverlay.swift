//
//  ParkMapOverlay.swift
//  Park View
//
//  Created by GEORGE QUENTIN on 03/02/2018.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import MapKit

public class ParkMapOverlay: NSObject, MKOverlay {
    public var coordinate: CLLocationCoordinate2D
    public var boundingMapRect: MKMapRect
    
    public init(park: Park) {
        boundingMapRect = park.overlayBoundingMapRect
        coordinate = park.midCoordinate
    }
}
