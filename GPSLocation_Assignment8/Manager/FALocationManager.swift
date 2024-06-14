//
//  FALocationManager.swift
//  GPSLocation_Assignment8
//
//  Created by KKNANXX on 6/9/24.
//

import Foundation
import CoreLocation

class FALocationManager: NSObject, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    var userLocation: CLLocation?
    
    static let sharedInstance: FALocationManager = {
        let instance = FALocationManager()
        return instance
    }()
    
    var onLocationUpdate: ((CLLocation) -> Void)?
    var onLocationError: ((Error) -> Void)?

    private override init() {
        super.init()
    }
    
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
        print(manager.authorizationStatus.rawValue)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        onLocationUpdate?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onLocationError?(error)
    }
}
