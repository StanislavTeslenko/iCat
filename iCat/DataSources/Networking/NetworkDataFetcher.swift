//
//  NetworkDataFetcher.swift
//  iCat
//
//  Created by Stanislav Teslenko on 01.04.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func fetchGenericJSONData<T: Codable>(urlString: String, response: @escaping (T?) -> ())
    func fetchData(urlString: String, response: @escaping (Data?) -> ())
}

class NetworkDataFetcher: DataFetcher {
    
    var networking: Networking
    
    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }
    
    func fetchGenericJSONData<T: Codable>(urlString: String, response: @escaping (T?) -> ()) {
        networking.request(urlString: urlString) { (data, error) in
            if let error = error {
                print(#function,#line,"Error received requesting data: \(error.localizedDescription)")
                response (nil)
            }
            let decoded = self.decodeJSON(type: T.self, from: data)
            response(decoded)
        }
    }
    
    private func decodeJSON<T: Codable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print(#function, #line, "Failed to decode JSON", jsonError)
            return nil
        }
    }
    
    func fetchData(urlString: String, response: @escaping (Data?) -> ()) {
        networking.request(urlString: urlString) { (data, error) in
            if let error = error {
                print(#function,#line,"Error received requesting data: \(error.localizedDescription)")
                response (nil)
            }
            if let data = data {
                response (data)
            } else {
                response (nil)
            }
        }
    }
    
}
