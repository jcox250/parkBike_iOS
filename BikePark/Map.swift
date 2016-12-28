//
//  Map.swift
//  BikePark
//
//  Created by James Cox on 27/12/2016.
//  Copyright © 2016 James Cox. All rights reserved.
//

import Foundation
import MapKit
import GoogleMaps

class Map {
    
    var mapView: MKMapView
    var latitudeDelta: CLLocationDegrees
    var longitudeDelta: CLLocationDegrees
    var showUserLocation: Bool
    var mapAnimated: Bool
    
    
    init(mapView: MKMapView, latitudeDelta: Double, longitudeDelta: Double, showUserLocation: Bool,
         mapAnimated: Bool) {
            self.mapView = mapView
            self.latitudeDelta = latitudeDelta
            self.longitudeDelta = longitudeDelta
            self.showUserLocation = showUserLocation
            self.mapAnimated = mapAnimated
    }
    
    
    func ConfigureMap(location: CLLocationCoordinate2D) {
        let mapSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        let region = MKCoordinateRegion(center: location, span: mapSpan)
        self.mapView.setRegion(region, animated: mapAnimated)
        self.mapView.showsUserLocation = showUserLocation
    }
    
    
    func PlaceMarker(marker: MKPointAnnotation) {
        mapView.addAnnotation((marker))
    }
    

}
