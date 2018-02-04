//
//  AttractionAnnotation.swift
//  Park View
//
//  Created by GEORGE QUENTIN on 03/02/2018.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import MapKit

public enum AttractionType: Int {
    case misc = 0
    case ride
    case food
    case firstAid
    
    public func image() -> UIImage {
        switch self {
        case .misc:
            return #imageLiteral(resourceName: "star")
        case .ride:
            return #imageLiteral(resourceName: "ride")
        case .food:
            return #imageLiteral(resourceName: "food")
        case .firstAid:
            return #imageLiteral(resourceName: "firstaid")
        }
    }
}

public class AttractionAnnotation: NSObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D
    public var title: String?
    public var subtitle: String?
    public var type: AttractionType
    
    public init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, type: AttractionType) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.type = type
    }
}
