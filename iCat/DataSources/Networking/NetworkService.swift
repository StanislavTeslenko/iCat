//
//  NetworkService.swift
//  iCat
//
//  Created by Stanislav Teslenko on 01.04.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import Foundation

protocol Networking {
    func request(urlString: String, completion: @escaping (Data?, Error?) ->())
}

class NetworkService: Networking {
    
    func request(urlString: String, completion: @escaping (Data?, Error?) ->()) {
        
        // Create URL from String
        guard let url = URL(string: urlString) else {return}
        
        // Create Request from URL
        var request = URLRequest(url: url)
        
        // Add API key into request header
        let apiKey = PrivateData().getApiKey()
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        // Create URLSession data task
        let task = createDataTask(from: request, completion: completion)
        
        // Start data task
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask {
        
        // Create URL Session
        let session = URLSession(configuration: .default)
        
        // Create data task
        return session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
   
}
