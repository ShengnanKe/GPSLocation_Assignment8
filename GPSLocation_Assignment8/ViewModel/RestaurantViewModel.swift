//
//  RestaurantViewModel.swift
//  GPSLocation_Assignment8
//
//  Created by KKNANXX on 6/12/24.
//

import Foundation

class RestaurantViewModel {
    
    var restaurants: [RestaurantInfo] = [] {
        didSet {
            onUpdate?()
        }
    }
    var onUpdate: (() -> Void)?
    
    init(restaurants: [RestaurantInfo] = []) {
        self.restaurants = restaurants
    }
}
