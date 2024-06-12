//
//  RestaurantService.swift
//  GPSLocation_Assignment8
//
//  Created by KKNANXX on 6/11/24.
//

import Foundation

class RestaurantService {
    static let shared = RestaurantService()
    
    func fetchRestaurants(forCity city: String, completion: @escaping ([RestaurantInfo]?) -> Void) {
        let urlString = "https://wyre-data.p.rapidapi.com/restaurants/town/\(city)"
        
        NetworkManager.shared.request(urlString: urlString, method: .GET, body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let restaurants = try JSONDecoder().decode([RestaurantInfo].self, from: data)
                    completion(restaurants)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
