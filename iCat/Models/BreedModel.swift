//
//  BreedModel.swift
//  iCat
//
//  Created by Stanislav Teslenko on 07.05.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

struct BreedModel: Codable {
    
    let id: String?
    let name: String?
    let temperament: String?
    let origin: String?
    let description: String?
    let life_span: String?
    let weight: BreedWeight?
    let wikipedia_url: String?
    
}

struct BreedWeight: Codable {
    let metric: String?
}

struct BreedWithImageUrlModel: Codable {
    
    let url: String?
    let breeds: [BreedModel]
}

struct BreedCellModel: Hashable {
    
    var breed: BreedModel
    var breedImages: [UIImage?]
    let uuid = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: BreedCellModel, rhs: BreedCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
