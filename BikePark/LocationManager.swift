//
//  LocationManager.swift
//  BikePark
//
//  Created by James Cox on 28/12/2016.
//  Copyright © 2016 James Cox. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    //Properties
    var coreLocation: CLLocationManager
    
    
    //Constructer
    init(coreLocation: CLLocationManager) {
        self.coreLocation = coreLocation
    }
    
    
    //Ask for authorisation from user to access their location
    func RequestUserLocation() {
        coreLocation.requestWhenInUseAuthorization()
    }
    
    
    //Check if location services are enabled
    func LocationServicesEnabled() -> Bool {
        if (CLLocationManager.locationServicesEnabled()) {
            coreLocation.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            coreLocation.startUpdatingLocation()
            return true
        }
        return false
    }
    
    
    //Returns users latitude
    func GetUserLatitude() -> CLLocationDegrees {
        return self.coreLocation.location!.coordinate.latitude
    }
    
    
    //Returns users longitude
    func GetUserLongitude() -> CLLocationDegrees {
        return self.coreLocation.location!.coordinate.longitude
    }
    
    
    
}
