//
//  Breed.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation

struct Breed: Identifiable, Decodable {
    let id: String
    let name: String
    let temperament: String
    let origin: String
    let image: BreedImage
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case temperament
        case origin
        case image
    }
}
