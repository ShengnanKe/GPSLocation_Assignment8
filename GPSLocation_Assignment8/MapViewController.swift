//
//  MapViewController.swift
//  GPSLocation_Assignment8
//
//  Created by KKNANXX on 6/11/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showListButton: UIButton!
    
    var restaurants: [RestaurantInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Listen for city updates
        NotificationCenter.default.addObserver(self, selector: #selector(handleCityUpdated(notification:)), name: NSNotification.Name("CityUpdated"), object: nil)
        
        // Start tracking location
        FALocationManager.sharedInstance.setupLocation()
        FALocationManager.sharedInstance.startTracking()
    }
    
    @objc func handleCityUpdated(notification: Notification) {
        if let city = notification.userInfo?["city"] as? String {
            fetchRestaurants(forCity: city)
        }
    }
    
    func fetchRestaurants(forCity city: String) {
        RestaurantService.shared.fetchRestaurants(forCity: city) { [weak self] restaurants in
            DispatchQueue.main.async {
                self?.restaurants = restaurants ?? []
                self?.updateMap()
            }
        }
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        for restaurant in restaurants {
            if let latitude = restaurant.latitude, let longitude = restaurant.longitude {
                let annotation = MKPointAnnotation()
                annotation.title = restaurant.name
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                mapView.addAnnotation(annotation)
            }
        }
    }

    
    @IBAction func showListButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showRestaurantList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantList" {
            if let destinationVC = segue.destination as? RestaurantViewController {
                destinationVC.restaurants = restaurants
            }
        }
    }
}

