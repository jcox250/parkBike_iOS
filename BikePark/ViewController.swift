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
    
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coreLocation = CLLocationManager()
        let locationManager = LocationManager(coreLocation: coreLocation)
        
        locationManager.RequestUserLocation()
        let locationServicesEnabled = locationManager.LocationServicesEnabled()
        
        //If location services are enabled get users location and configure
        //the map for the users location
        if (locationServicesEnabled) {
            let userLat = locationManager.GetUserLatitude()
            let userLon = locationManager.GetUserLongitude()
            let location = CLLocationCoordinate2D(latitude: userLat, longitude: userLon)
            let map = Map(mapView: mapView, latitudeDelta: 0.05, longitudeDelta: 0.05, showUserLocation: true, mapAnimated: true)
            map.ConfigureMap(location: location)
            
            
            //GET request to JSON data containing locations for map markers
            Alamofire.request(Constants.API.url).responseJSON { response in
                let jsonResult = response.result.value
                
                for res in jsonResult as! [AnyObject] {
                    let descript = res["rack_description"] as? String
                    let latitude = res["rack_latitude"] as? String
                    let longitude = res["rack_longitude"] as? String
                    
                    let latDegrees = CLLocationDegrees(latitude!)
                    let lonDegrees = CLLocationDegrees(longitude!)
                    
                    let marker = MKPointAnnotation()
                    marker.coordinate = CLLocationCoordinate2D(latitude: latDegrees!, longitude: lonDegrees!)
                    marker.title = descript
                    map.PlaceMarker(marker: marker)
                }
            }
        }
    }//Viewdidload
    
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func searchWithAddress(_ sender: AnyObject) {
        //        let searchController = GMSAutocompleteViewController()
        //        searchController.delegate = self
        //        self.presentViewController(searchController, animated: true, completion: nil)
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
    
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async { () -> Void in
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

    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //let placeClient = GMSPlacesClient()
        //placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error: NSError?) -> Void in
            
//            self.resultsArray.removeAll()
//            if results == nil {
//                return
//            }
//            
//            for result in results! {
//                if let result = result as? GMSAutocompletePrediction {
//                    self.resultsArray.append(result.attributedFullText.string)
//                }
//            }
//            
//            self.searchResultController.reloadDataWithArray(self.resultsArray)
        //}
    }

}





extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error.localizedDescription )")
        self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
}

