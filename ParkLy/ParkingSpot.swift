//
//  ParkingSpot.swift
//  Park.ly
//
//  Created by Hebatullah Saadeldine Ahmed Bakr on 3/18/17.
//  Copyright © 2017 Hebatullah Saadeldine Ahmed Bakr. All rights reserved.
//

import UIKit
import MapKit
import Contacts

//The MKAnnotation protocol is used to provide annotation-related information to a map view.
class ParkingSpot: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
    
    //We are setting the subtitle property of MKAnnotation and not creating a separate variable of the same name
    var subtitle: String? {
        return locationName
    }
    
    //A function that will pass in a coordinate (CLLocationCoordinate2D) and return an MKMapItem which encapsulates information about a specific point on a map
    func mapItem(location: CLLocationCoordinate2D) -> MKMapItem {
        
        //A dictionary that holds addresses
        let addressDictionary = [String(CNPostalAddressStreetKey): subtitle]
        
        //Takes in a coordinate (which we have) and an addressDictionary (which we also have) and creates specific point and connects it to a specific address
        let placemark = MKPlacemark(coordinate: location, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = title
        
        return mapItem
    }
}
