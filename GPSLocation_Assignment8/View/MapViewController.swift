//
//  MapViewController.swift
//  GPSLocation_Assignment8
//
//  Created by KKNANXX on 6/11/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {  //} FALocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showListButton: UIButton!
    
    private var viewModel = MapViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Bind the view model updates to the updateMap method
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.updateMap()
            }
        }
        
        let locationManager = FALocationManager.sharedInstance
        //locationManager.delegate = self
        locationManager.setupLocation()
        locationManager.startTracking()
    }
    
    func didUpdateLocation(_ location: CLLocation) {
        print("Current coordinates: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        viewModel.fetchCityFromCoordinates(location: location) { [weak self] city in
            if let city = city {
                print("The city is: \(city)")
                self?.viewModel.fetchRestaurants(forCity: city)
            } else {
                print("Failed to retrieve city for coordinates: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            }
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        for restaurant in viewModel.restaurants {
            if let latitude = restaurant.latitude, let longitude = restaurant.longitude {
                let annotation = MKPointAnnotation()
                annotation.title = restaurant.name
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    @IBAction func showListButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showRestaurantList", sender: nil)
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
                destinationVC.viewModel = RestaurantViewModel(restaurants: viewModel.restaurants)
            }
        }
    }
}
