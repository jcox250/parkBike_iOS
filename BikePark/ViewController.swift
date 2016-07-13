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
import CoreLocation
import MapKit


class ViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap, CLLocationManagerDelegate {
    
    //MARK: Properties
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var searchBar: UIBarButtonItem!
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apikey = "AIzaSyCO5vvTi1fqTOCGscJ3EtsFu0BxNk_CcJ0"
    let locationManager = CLLocationManager()
    
   
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get users location
        let cus_lat = self.locationManager.location?.coordinate.latitude
        let cus_lon = self.locationManager.location?.coordinate.longitude
        print(cus_lat, cus_lon)
        
        let location = CLLocationCoordinate2D(
            latitude: cus_lat!,
            longitude: cus_lon!
        )
        
        
        //Map zoom level
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //GET request to JSON data containing locations for map markers
        Alamofire.request(.GET, "http://jcoxcv.com/service.php", parameters: [:]).responseJSON { response in
        
            let jsonResult = response.result.value
        
            for res in jsonResult as! [AnyObject] {
                let descript = res["rack_description"] as? String
                let latitude = res["rack_latitude"] as? String
                let longitude = res["rack_longitude"] as? String
                        
                let lat_doub = Double(latitude!)!
                let lon_doub = Double(longitude!)!
                        
                //Create location object
                let location = Location()
                    location.descript = descript
                    location.latitude = lat_doub
                    location.longitude = lon_doub
                        
                        
                let markerLocation = CLLocationCoordinate2D(
                    latitude: location.latitude!,
                    longitude: location.longitude!
                )
                        
                        
                let marker = MKPointAnnotation()
                    marker.coordinate = markerLocation
                    marker.title = location.descript
                self.mapView.addAnnotation(marker)
        
            }
 
        }
    }//Viewdidload
    
    
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func searchWithAddress(sender: AnyObject) {
        //        let searchController = GMSAutocompleteViewController()
        //        searchController.delegate = self
        //        self.presentViewController(searchController, animated: true, completion: nil)
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    
    
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let position = CLLocationCoordinate2DMake(lat, lon)
            
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: position, span: span)
            self.mapView.setRegion(region, animated: true)
            
            let marker = MKPointAnnotation()
                marker.coordinate = position
                marker.title = "Address: \(title)"
            
            self.mapView.addAnnotation(marker)
    
        }
    }

    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error: NSError?) -> Void in
            
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            
            for result in results! {
                if let result = result as? GMSAutocompletePrediction {
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            
            self.searchResultController.reloadDataWithArray(self.resultsArray)
        }
    }
    
    
    
    //Draw the map and markers
//    func createMap () {
//        
//        let cus_lat = self.locationManager.location?.coordinate.latitude
//        let cus_lon = self.locationManager.location?.coordinate.longitude
//        
//        
//        
//        //GET request to JSON data containing locations for map markers
//        Alamofire.request(.GET, "http://jcoxcv.com/service.php", parameters: [:]).responseJSON { response in
//            
//            let jsonResult = response.result.value
//            
//            for res in jsonResult as! [AnyObject] {
//                
//                //Select JSON data
//                let descript = res["rack_description"] as? String
//                let latitude = res["rack_latitude"] as? String
//                let longitude = res["rack_longitude"] as? String
//                
//                //Convert latitude from string to double
//                let lat_doub = Double(latitude!)!
//                let lon_doub = Double(longitude!)!
//                
//                //Create location object
//                let location = Location()
//                location.descript = descript
//                location.latitude = lat_doub
//                location.longitude = lon_doub
//                
//                //Custom marker
//                let cyclingMarker = UIImage(named: "cycling.png")!.imageWithRenderingMode(.AlwaysTemplate)
//                self.markerView = UIImageView(image: cyclingMarker)
//                let marker = GMSMarker()
//                marker.position = CLLocationCoordinate2DMake(location.latitude!, location.longitude!)
//                marker.title = location.descript
//                marker.iconView = self.markerView
//                marker.tracksViewChanges = true
//                marker.map = self.mapView
//            }
//        }
//
//    }
}





extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // TODO: handle the error.
        print("Error: \(error.description)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

