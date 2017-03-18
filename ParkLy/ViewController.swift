//
//  ViewController.swift
//  Park.ly
//
//  Created by Hebatullah Saadeldine Ahmed Bakr on 3/18/17.
//  Copyright © 2017 Hebatullah Saadeldine Ahmed Bakr. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var parkBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 500
    
    var parkedCarAnnotation: ParkingSpot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        checkLocationAuthorizationStatus()
    }
    
    @IBAction func parkBtnWasPressed(_ sender: Any) {
   
        if mapView.annotations.count == 1 {
            
            mapView.addAnnotation(parkedCarAnnotation!)
            parkBtn.setImage(UIImage(named: "foundCar.png"), for: .normal)
            
        } else {
            
            mapView.removeAnnotations(mapView.annotations)
            parkBtn.setImage(UIImage(named: "parkCar.png"), for: .normal)
        }
        
        centerMapOnLocation(location: LocationService.instance.locationManager.location!)
    }
    
    //This function will check to see if we are authorized for location services
    //If we are not, it will request "When In Use" authorization. If we are already authorized, it will show the users location on the Map View and tell our LocationService to start updating our location
        func checkLocationAuthorizationStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            mapView.showsUserLocation = true
            LocationService.instance.locationManager.delegate = self
            LocationService.instance.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationService.instance.locationManager.startUpdatingLocation()
            
        } else {
            
            LocationService.instance.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //“A function which takes in a location property of type CLLocation (basically just a coordinate including longitude and latitude properties). Then you will create a coordinate region which tells the map what size it should zoom to. Then we set the region and it will animate automatically
    func centerMapOnLocation(location: CLLocation) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        if let annotation = annotation as? ParkingSpot {
            
            let identifier = "pin"
            var view: MKPinAnnotationView
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.animatesDrop = true
            view.pinTintColor = UIColor.orange
            view.calloutOffset = CGPoint(x: -8, y: -3)
            view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
            return view
            
        } else {
            
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let location = view.annotation as! ParkingSpot
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        
        location.mapItem(location: (parkedCarAnnotation?.coordinate)!).openInMaps(launchOptions: launchOptions)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        centerMapOnLocation(location: CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude))
        
        let locationServiceCoordinate = LocationService.instance.locationManager.location!.coordinate
        
        parkedCarAnnotation = ParkingSpot(title: "My Parking Spot", locationName: "Tap the 'i' for GPS", coordinate: CLLocationCoordinate2D(latitude: locationServiceCoordinate.latitude , longitude: locationServiceCoordinate.longitude))
    }
}

