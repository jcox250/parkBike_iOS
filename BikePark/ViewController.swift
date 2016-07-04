//
//  ViewController.swift
//  BikePark
//
//  Created by James Cox on 03/07/2016.
//  Copyright © 2016 James Cox. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class ViewController: UIViewController  {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Google Maps API Key
        GMSServices.provideAPIKey("AIzaSyB42xpf3dn0eD6p4wNE9U-05TVgZlJqKnM")
        //Position maps starting point
        let camera = GMSCameraPosition.cameraWithLatitude(54.5973,longitude: -5.9301, zoom: 10)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        //GET request to JSON data containing locations for map markers
        let url = "http://jcoxcv.com/service.php"
        Alamofire.request(.GET, url, parameters: [:])
            .responseJSON { response in
                
                let jsonResult = response.result.value
                
                for res in jsonResult as! [AnyObject] {
                    
                    //Select JSON data
                    let descript = res["rack_description"] as? String
                    let latitude = res["rack_latitude"] as? String
                    let longitude = res["rack_longitude"] as? String
                    
                    //Convert latitude from string to double
                    let lat_doub = Double(latitude!)!
                    let lon_doub = Double(longitude!)!
                    
                    //Instantiate a location object
                    let location = Location()
                    location.descript = descript
                    location.latitude = lat_doub
                    location.longitude = lon_doub
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2DMake(location.latitude!, location.longitude!)
                    marker.title = location.descript
                    //marker.snippet = "Australia"
                    marker.map = mapView
                }
                
            }
    }
    //End viewDidLoad()
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

