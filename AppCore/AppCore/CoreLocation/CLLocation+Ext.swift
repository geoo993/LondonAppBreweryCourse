//
//  CLLocation+Ext.swift
//  ProjectStemCore
//
//  Created by GEORGE QUENTIN on 10/02/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import CoreLocation
import GLKit
import SceneKit

public func -(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> CLLocationDistance {

    let leftLatRadian = left.latitude.toRadians
    let leftLonRadian = left.longitude.toRadians

    let rightLatRadian = right.latitude.toRadians
    let rightLonRadian = right.longitude.toRadians

    let a = pow(sin((rightLatRadian - leftLatRadian) / 2), 2)
        + pow(sin((rightLonRadian - leftLonRadian) / 2), 2) * cos(leftLatRadian) * cos(rightLatRadian)
    return 2 * atan2(sqrt(a), sqrt(1 - a))
}


public extension CLLocation {
    
    public typealias LMReverseGeocodeCompletionHandler = ((_ reverseGecodeInfo:NSDictionary?,_ placemark:CLPlacemark?, _ error:String?)->Void)?
    public typealias LMGeocodeCompletionHandler = ((_ placemarks:[CLPlacemark]?, _ error:Error?)->Void)
    public typealias LMLocationCompletionHandler = ((_ latitude:Double, _ longitude:Double, _ status:String, _ verboseMessage:String, _ error:String?)->())?

    func reverseGeocode (completion: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }

    public func bearing(to location: CLLocation) -> Double {
        return self.coordinate.bearing(to: location.coordinate)
    }

    public func location(to locationTranslation: LocationTranslation) -> CLLocation {
        let latitudeCoordinate = self.coordinate.coordinate(with: 0, and: locationTranslation.latitudeTranslation)
        let longitudeCoordinate = self.coordinate.coordinate(with: 90, and: locationTranslation.longitudeTranslation)
        let coordinate = CLLocationCoordinate2D(
            latitude: latitudeCoordinate.latitude,
            longitude: longitudeCoordinate.longitude)
        let altitude = self.altitude + locationTranslation.altitudeTranslation
        return CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.verticalAccuracy, timestamp: self.timestamp)
    }

    public func translation(to location: CLLocation) -> LocationTranslation {
        let inbetweenLocation = CLLocation(latitude: self.coordinate.latitude, longitude: location.coordinate.longitude)
        let distanceLatitude = location.distance(from: inbetweenLocation)
        let latitudeTranslation: Double
        if location.coordinate.latitude > inbetweenLocation.coordinate.latitude {
            latitudeTranslation = distanceLatitude
        } else {
            latitudeTranslation = 0 - distanceLatitude
        }
        let distanceLongitude = self.distance(from: inbetweenLocation)
        let longitudeTranslation: Double
        if self.coordinate.longitude > inbetweenLocation.coordinate.longitude {
            longitudeTranslation = 0 - distanceLongitude
        } else {
            longitudeTranslation = distanceLongitude
        }
        let altitudeTranslation = location.altitude - self.altitude
        return LocationTranslation(
            latitudeTranslation: latitudeTranslation,
            longitudeTranslation: longitudeTranslation,
            altitudeTranslation: altitudeTranslation)
    }

    public static func bestLocationEstimate(from locations: [CLLocation]) -> CLLocation {
        let sortedLocationEstimates = locations.sorted(by: {
            if $0.horizontalAccuracy == $1.horizontalAccuracy {
                return $0.timestamp > $1.timestamp
            }
            return $0.horizontalAccuracy < $1.horizontalAccuracy
        })
        return sortedLocationEstimates.first!
    }

    public func transformMatrix(for matrix: simd_float4x4, to location: CLLocation) -> simd_float4x4 {
        let origin = self
        let distance = Float(location.distance(from: origin))
        let bearing = GLKMathDegreesToRadians(Float(origin.coordinate.direction(to: location.coordinate)))
        let position = vector_float4(0.0, 0.0, -distance, 0.0)
        let translationMatrix = matrix_identity_float4x4.translationMatrix(with: position)
        let rotationMatrix = matrix_identity_float4x4.rotateAroundY(for: bearing)
        let transformMatrix = simd_mul(rotationMatrix, translationMatrix)
        return simd_mul(matrix, transformMatrix)
    }
}

