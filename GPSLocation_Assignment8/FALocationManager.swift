//
//  FALocationManager.swift
//  GPSLocation_Assignment8
//
//  Created by KKNANXX on 6/9/24.
//

//
//  FALocationManager.swift
//  FirstApp
//
//  Created by Arpit on 03/06/24.
//

import Foundation
import CoreLocation

class FALocationManager: NSObject, CLLocationManagerDelegate
{
    // MARK:- Variable
    var locationManager: CLLocationManager!
    var userLocation: CLLocation?
    
    static let sharedInstance: FALocationManager = {
        let instance = FALocationManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    // Important
    
    func setupLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.activityType = CLActivityType.otherNavigation
        locationManager.distanceFilter = 5.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.requestLocationAuthorization()
            }
        }
        
    }
    
    
    func requestLocationAuthorization() {
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(manager.authorizationStatus.rawValue) // 4
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        
        print("Current coordinates: \(location.coordinate.latitude), \(location.coordinate.longitude)")
           
        // location to city
        GeocodingService.shared.getCityFromCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { city in
            if let city = city {
                NotificationCenter.default.post(name: NSNotification.Name("CityUpdated"), object: nil, userInfo: ["city": city])
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed")
    }
    
    
}
