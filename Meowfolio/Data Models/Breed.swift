//
//  Breed.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation

struct Breed: Identifiable {
    let id: String
    let name: String
    let temperament: [String]
    let origin: String
    let lifeSpan: String
    let image: BreedImage
}
