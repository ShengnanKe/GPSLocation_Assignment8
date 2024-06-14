//
//  MapViewModel.swift
//  GPSLocation_Assignment8
//
//  Created by KKNANXX on 6/12/24.
//

import Foundation
import CoreLocation

class MapViewModel {
    
    var restaurants: [RestaurantInfo] = [] {
        didSet {
            onUpdate?()
        }
    }
    var onUpdate: (() -> Void)?
    var onLocationUpdate: ((CLLocation) -> Void)?
    var onLocationError: ((Error) -> Void)?
    
    func fetchRestaurants(forCity city: String) {
        RestaurantService.shared.fetchRestaurants(forCity: city) { [weak self] restaurants in
            if let restaurants = restaurants {
                self?.restaurants = restaurants
            } else {
                print("Error fetching restaurants for city: \(city)")
            }
        }
    }
    
    func fetchCityFromCoordinates(location: CLLocation, completion: @escaping (String?) -> Void) {
        GeocodingService.shared.getCityFromCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, completion: completion)
    }
    
    func startLocationUpdates() {
        let locationManager = FALocationManager.sharedInstance
        locationManager.onLocationUpdate = { [weak self] location in
            self?.onLocationUpdate?(location)
        }
        locationManager.onLocationError = { [weak self] error in
            self?.onLocationError?(error)
        }
        locationManager.setupLocation()
        locationManager.startTracking()
    }
}
