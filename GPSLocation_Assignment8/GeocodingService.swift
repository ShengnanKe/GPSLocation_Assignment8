//
//  GeocodingService.swift
//  GPSLocation_Assignment8
//
//  Created by KKNANXX on 6/11/24.
//

import Foundation
import CoreLocation

class GeocodingService {
    static let shared = GeocodingService()
    
    func getCityFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error in geocoding: \(error.localizedDescription)")
                completion(nil)
            } else if let placemark = placemarks?.first {
                let city = placemark.locality
                completion(city)
            } else {
                completion(nil)
            }
        }
    }
}
