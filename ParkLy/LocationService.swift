//
//  LocationService.swift
//  Park.ly
//
//  Created by Hebatullah Saadeldine Ahmed Bakr on 3/18/17.
//  Copyright © 2017 Hebatullah Saadeldine Ahmed Bakr. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let instance = LocationService()
    
    //A variable to manage our location
    var locationManager = CLLocationManager()
    
    //A variable to save our current location to
    var currentLocation: CLLocationCoordinate2D?
    
    override init () {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
       
        self.currentLocation = locationManager.location?.coordinate
    }
}
