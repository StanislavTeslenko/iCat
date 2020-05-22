//
//  BreedDataSource.swift
//  iCat
//
//  Created by Stanislav Teslenko on 07.05.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

protocol BreedDataSourceDelegate: class {
    func newCellLoaded()
    func loadComplete()
    func loadingError()
}

class BreedDataSource {
    
//    API Documentation - List the Cat Breeds: https://docs.thecatapi.com/api-reference/breeds/breeds-list
    fileprivate let breedBaseUrlString = "https://api.thecatapi.com/v1/breeds"
    fileprivate let searchBaseUrlString = "https://api.thecatapi.com/v1/images/search?breed_id="
    
    fileprivate var dataFetcherService = DataFetcherService()
    
    weak var delegate: BreedDataSourceDelegate?
    
    fileprivate var breedCells: [BreedCellModel?] = [] {
        didSet {
            delegate?.newCellLoaded()
        }
    }
    
    fileprivate var isDataReady: Bool? {
        didSet {
            if isDataReady != nil && isDataReady == true {
                delegate?.loadComplete()
            }
        }
    }
    
//    Create singlton
    static let shared = BreedDataSource()
    
}

// MARK: - Public functions

extension BreedDataSource {
    
    func getBreedsListApiData() {
        
        // Clear data
        self.breedCells = []
        self.isDataReady = false
        
        // Get API data: Breed List
        dataFetcherService.fetchNetworkData(urlString: breedBaseUrlString) { (data: [BreedModel]?) in
            guard let data = data else {
                self.isDataReady = nil
                self.delegate?.loadingError()
                return}
            
            var breedList = data

            // Parse breed list
            for (index, breed) in breedList.enumerated() {
                // Get breed Id from model
                guard let breedId = breed.id else {
                    breedList.remove(at: index)
                    return}
                
                // Concatenate base Url and breed Id for get breed with image via API
                let breedUrlString = self.searchBaseUrlString + breedId
                
                // Get API data: Get JSON Breed with image url
                self.dataFetcherService.fetchNetworkData(urlString: breedUrlString) { (data: [BreedWithImageUrlModel]?) in
                    // Check data consistency
                    guard let data = data else {return}
                    guard let breedWithUrl = data.first else {return}
                    guard let breed = breedWithUrl.breeds.first else {return}
                    
                    // Check image url and if image's url is invalid add placeholder image intro breed
                    guard let imageUrlString = breedWithUrl.url else {
                        let image = UIImage(named: "schr-cat")
                        let breedCell = BreedCellModel(breed: breed, breedImages: [image])
                        // Check breed array for prevent duplicating
                        if self.breedCells.contains(where: {$0?.breed.id == breed.id}) == false {
                        self.breedCells.append(breedCell)
                        self.isDataReady = (self.breedCells.count) == (breedList.count) ? true : false
                        }
                        return
                    }
                    
                    // Get breed's image from API and append breed with image to breed cell array
                    self.dataFetcherService.fetchImage(urlString: imageUrlString) { (image) in
                        let loadedImage: UIImage!
                        if let image = image {
                            loadedImage = image
                        } else {
                              loadedImage = UIImage(named: "schr-cat")}
                        let breedCell = BreedCellModel(breed: breed, breedAvatar: loadedImage.aspectFittedToHeight(150) ,breedImages: [loadedImage.aspectFittedToHeight(350)])
                        // Check breed array for prevent duplicating
                        if self.breedCells.contains(where: {$0?.breed.id == breed.id}) == false {
                            self.breedCells.append(breedCell)
                            self.isDataReady = (self.breedCells.count) == (breedList.count) ? true : false
                        }
                    }
                }
            }
        }
    }
    
    func getBreedImages(breed: BreedCellModel, completion: @escaping (UIImage?) -> ()) {
        
        // Get breed Id from model
        guard let breedId = breed.breed.id else {
            completion(nil)
            return}
        
        // Concatenate base Url and breed Id for get breed images via API with limit 10
        let breedUrlString = self.searchBaseUrlString + breedId + "&limit=10"
        
        // Get API data: Get JSON Breed with image
        self.dataFetcherService.fetchNetworkData(urlString: breedUrlString) { (data: [BreedWithImageUrlModel]?) in
            guard let data = data else {
                completion(nil)
                return}
            var imageUrlArray: [String] = []
            
            for breedData in data {
                if let imageUrlString = breedData.url {
                    if !imageUrlArray.contains(imageUrlString) {
                        imageUrlArray.append(imageUrlString)
                        self.dataFetcherService.fetchImage(urlString: imageUrlString) { (image) in
                            completion(image?.aspectFittedToHeight(350))
                        }
                    }
                }
            }
        }
    }
    
    func getBreedCellData() -> [BreedCellModel?] {
        return breedCells
    }
    
    func checkDataReady() -> Bool? {
        return isDataReady
    }
    
}
