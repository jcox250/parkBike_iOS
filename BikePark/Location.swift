//
//  Location.swift
//  BikePark
//
//  Created by James Cox on 04/07/2016.
//  Copyright © 2016 James Cox. All rights reserved.
//

import Foundation

class Location: NSObject {
    
    var descript: String?
    var latitude: Double?
    var longitude: Double?
    
    override init() {
        
    }
    
    init(descript: String, latitude: Double, longitude: Double) {
        self.descript! = descript
        self.latitude! = latitude
        self.longitude! = longitude
    }
    
    func printDetails() {
        print(self.descript, self.latitude, self.longitude)
    }
    
}