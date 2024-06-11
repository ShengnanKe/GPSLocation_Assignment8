//
//  RestaurantInfo.swift
//  GPSLocation_Assignment8
//
//  Created by KKNANXX on 6/11/24.
//

import Foundation

struct Restaurant: Decodable {
    let name: String?
    let latitude: Double?
    let longitude: Double?
    let city: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "BusinessName"
        case latitude = "Geocode_Latitude"
        case longitude = "Geocode_Longitude"
        case city = "AddressLine3"
    }
}
