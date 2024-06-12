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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCityUpdated(notification:)), name: NSNotification.Name("CityUpdated"), object: nil)
        
        let locationManager = FALocationManager.sharedInstance
        locationManager.setupLocation()
        locationManager.startTracking()
    }
    
    @objc func handleCityUpdated(notification: Notification) {
        if let city = notification.userInfo?["city"] as? String {
            let locationManager = FALocationManager.sharedInstance
            if let coordinate = locationManager.userLocation?.coordinate {
                // Print the current coordinates
                print("Current coordinates: \(coordinate.latitude), \(coordinate.longitude)")
            }
            fetchRestaurants(forCity: city)
        }
    }
    
    func fetchRestaurants(forCity city: String) {
        let urlString = "https://wyre-data.p.rapidapi.com/restaurants/town/\(city)"
        
        NetworkManager.shared.request(urlString: urlString, method: .GET, body: nil) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let restaurants = try JSONDecoder().decode([RestaurantInfo].self, from: data)
                    self?.restaurants = restaurants
                    DispatchQueue.main.async {
                        self?.updateMap()
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
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
    
    @IBAction func dropPin(sender: UIButton) {
        let locationManager = FALocationManager.sharedInstance
        if let coordinate = locationManager.userLocation?.coordinate {
            // Print the current coordinates
            print("Current coordinates: \(coordinate.latitude), \(coordinate.longitude)")
            
            setupPin(location: coordinate)
        }
    }
    
    func setupPin(location: CLLocationCoordinate2D) {
        let pin = MKPlacemark(coordinate: location)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(pin)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantList" {
            if let destinationVC = segue.destination as? RestaurantViewController {
                destinationVC.restaurants = restaurants
            }
        }
    }
}
