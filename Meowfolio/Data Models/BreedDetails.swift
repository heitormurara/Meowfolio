//
//  BreedDetail.swift
//  Meowfolio
//
//  Created by Heitor Murara on 11/04/24.
//

import Foundation

struct BreedDetails: Decodable {
    let name: String
    let weight: BreedWeight
    let origin: String
    let temperament: String
    let lifeSpan: String
    let description: String
    let adaptabilityScale: Int
    let affectionLevelScale: Int
    let childFriendlyScale: Int
    let dogFriendlyScale: Int
    let energyLevelScale: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case weight
        case origin
        case temperament
        case lifeSpan = "life_span"
        case description
        case adaptabilityScale = "adaptability"
        case affectionLevelScale = "affection_level"
        case childFriendlyScale = "child_friendly"
        case dogFriendlyScale = "dog_friendly"
        case energyLevelScale = "energy_level"
    }
}

struct BreedWeight: Decodable {
    let metric: String
}
