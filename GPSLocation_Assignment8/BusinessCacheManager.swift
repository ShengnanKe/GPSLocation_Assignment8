//
//  BusinessCacheManager.swift
//  GPSLocation_Assignment8
//
//  Created by KKNANXX on 6/10/24.
//

import Foundation
//
//class BusinessCacheManager {
//    static let shared = BusinessCacheManager()
//    private let cache = NSCache<NSString, NSData>()
//
//    private init() {}
//
//    func setBusiness(_ business: Business, forKey key: String) {
//        do {
//            let data = try JSONEncoder().encode(business)
//            cache.setObject(data as NSData, forKey: key as NSString)
//        } catch {
//            print("Failed to encode business: \(error.localizedDescription)")
//        }
//    }
//
//    func getBusiness(forKey key: String) -> Business? {
//        if let data = cache.object(forKey: key as NSString) as Data? {
//            do {
//                let business = try JSONDecoder().decode(Business.self, from: data)
//                return business
//            } catch {
//                print("Failed to decode business: \(error.localizedDescription)")
//                return nil
//            }
//        }
//        return nil
//    }
//}
