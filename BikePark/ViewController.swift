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


class ViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap {
    
    //MARK: Properties
    
    @IBOutlet weak var searchBar: UIBarButtonItem!
    @IBOutlet weak var googleMapsViewContainer: UIView!
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apikey = "AIzaSyCO5vvTi1fqTOCGscJ3EtsFu0BxNk_CcJ0"
    
    var mapView: GMSMapView!
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMap()
    }
    
    
   
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
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 10)
            self.mapView.camera = camera
            
            marker.title = "Address: \(title)"
            marker.map = self.mapView
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
    
    
    //MARK: Actions

    func createMap () {
        //Google Maps API Key
        GMSServices.provideAPIKey(apikey)
        
        //Position maps starting point
        let camera = GMSCameraPosition.cameraWithLatitude(54.5973,longitude: -5.9301, zoom: 13)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.myLocationEnabled = true
        view = mapView
        
        
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
                    marker.map = self.mapView
                }
        }

    }
    

    
    


    
    
   

    
    //Geocoding
    //    func getLatLngForZip(zipCode: String) {
    //        let url = NSURL(string: "\(baseUrl)address=\(zipCode)&key=\(apikey)")
    //        let data = NSData(contentsOfURL: url!)
    //        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
    //        if let result = json["results"] as? NSArray {
    //            if let geometry = result[0]["geometry"] as? NSDictionary {
    //                if let location = geometry["location"] as? NSDictionary {
    //                    let latitude = location["lat"] as! Float
    //                    let longitude = location["lng"] as! Float
    //                    print("\n\(latitude), \(longitude)")
    //                }
    //            }
    //        }
    //    }
    
    //Reverse Geocoding
    //    func getAddressForLatLng(latitude: String, longitude: String) {
    //        let url = NSURL(string: "\(baseUrl)latlng=\(latitude),\(longitude)&key=\(apikey)")
    //        let data = NSData(contentsOfURL: url!)
    //        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
    //        if let result = json["results"] as? NSArray {
    //            if let address = result[0]["address_components"] as? NSArray {
    //                let number = address[0]["short_name"] as! String
    //                let street = address[1]["short_name"] as! String
    //                let city = address[2]["short_name"] as! String
    //                let state = address[4]["short_name"] as! String
    //                let zip = address[6]["short_name"] as! String
    //                print("\n\(number) \(street), \(city), \(state) \(zip)")
    //            }
    //        }
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

