//
//  DataFetcherService.swift
//  iCat
//
//  Created by Stanislav Teslenko on 01.04.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import Foundation
import UIKit

class DataFetcherService {
    
    var networkDataFetcher: DataFetcher
    
    init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.networkDataFetcher = dataFetcher
    }
    
    func fetchNetworkData<T: Codable>(urlString: String, completion: @escaping (T?) -> ()) {
        networkDataFetcher.fetchGenericJSONData(urlString: urlString, response: completion)
    }
    
    func fetchImage(urlString: String, completion: @escaping (UIImage?) -> ()) {
        networkDataFetcher.fetchData(urlString: urlString) { (data) in
            if let data = data {
                let image = UIImage(data: data)
                completion (image)
            } else {
                completion (nil)
            }
        }
    }
}
