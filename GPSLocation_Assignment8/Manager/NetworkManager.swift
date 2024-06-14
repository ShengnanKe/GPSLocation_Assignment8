//
//  NetworkManager.swift
//  GPSLocation_Assignment8
//
//  Created by KKNANXX on 6/9/24.
//

import Foundation


class NetworkManager: NSObject {
    
    static let shared: NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
    }
    
    var apiKey: String = "cf4863382emsh660b0a010bd400dp1de074jsn26d3499ba6e2"
    
    func request(urlString: String, method: HTTPMethod, body: Data?, completion: @escaping (Result<Data, Error>) -> Void) {
        
        // 1. Step - Make URL
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // 2. Step - Make Request
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.setValue("wyre-data.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        
        // Base authentication
        /*
        let credStr = "any formula"
        
        let logindata = credStr.data(using: .utf8)
        
        let base64 = logindata?.base64EncodedString()
        
        request.setValue(base64, forHTTPHeaderField: "Authorization")
        */
        request.timeoutInterval = 20.0 // timeout error
        
        // 3. Make Actual Session URL
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else  {
                completion(.failure(NetworkError.noData))
                return
            }
            
            completion(.success(data))
            
        })
        
        task.resume()
        
    }
    
    func requestDownload(urlString: String, method: HTTPMethod, body: Data?, completion: @escaping (Result<URL, Error>) -> Void) {
        // 1. Step - Make URL
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        
        let task = URLSession.shared.downloadTask(with: request, completionHandler: { fileUrl, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let fileUrl = fileUrl else  {
                completion(.failure(NetworkError.noData))
                return
            }
            
            completion(.success(fileUrl))
        
            
        })
        
        task.resume()
        
    }
}
