//
//  CatAPIService.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation

protocol CatService {
    func getBreeds(limit: Int, page: Int) async -> Result<[Breed], Error>
    func getBreedDetails(_ breed: Breed) async -> Result<BreedDetails, Error>
}

final class CatAPIService {
    private let serviceProvider: ServiceProviding
    
    init(serviceProvider: ServiceProviding = ServiceProvider()) {
        self.serviceProvider = serviceProvider
    }
}

extension CatAPIService: CatService {
    func getBreeds(limit: Int, page: Int) async -> Result<[Breed], Error> {
        let route = CatAPIRoute.getBreeds(limit: limit, page: page)
        return await serviceProvider.request(route, decodeInto: [Breed].self)
    }
    
    func getBreedDetails(_ breed: Breed) async -> Result<BreedDetails, Error> {
        let route = CatAPIRoute.getBreedDetails(id: breed.id)
        return await serviceProvider.request(route, decodeInto: BreedDetails.self)
    }
}
