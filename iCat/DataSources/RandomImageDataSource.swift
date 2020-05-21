//
//  RandomImageDataSource.swift
//  iCat
//
//  Created by Stanislav Teslenko on 01.05.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

protocol RandomImageDataSourceDelegate: class {
    func dataReady(image: UIImage?)
}

class RandomImageDataSource {
    
//    API Documentation - Random Image: https://docs.thecatapi.com
    fileprivate let randomImageUrlString = "https://api.thecatapi.com/v1/images/search"
    
    fileprivate var dataFetcherService = DataFetcherService()
    
    weak var delegate: RandomImageDataSourceDelegate?
    
}

extension RandomImageDataSource {
    
    public func loadNetworkData() {
        dataFetcherService.fetchNetworkData(urlString: randomImageUrlString) { (data: [RandomImageModel]?) in
            guard let imageUrl = data?.first?.url else {
                self.delegate?.dataReady(image: nil)
                return}
            self.dataFetcherService.fetchImage(urlString: imageUrl) { (image) in
                if let image = image {
                    self.delegate?.dataReady(image: image)
                } else {
                    self.delegate?.dataReady(image: nil)
                }
            }
        }
    }
   
}
