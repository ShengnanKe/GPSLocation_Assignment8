//
//  FALocationManager.swift
//  GPSLocation_Assignment8
//
//  Created by KKNANXX on 6/9/24.
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
        locationManager.distanceFilter = 1000.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        
        if CLLocationManager.locationServicesEnabled() {
            requestLocationAuthorization()
        }
    }
    
    
    func requestLocationAuthorization() {
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        
    }
}
