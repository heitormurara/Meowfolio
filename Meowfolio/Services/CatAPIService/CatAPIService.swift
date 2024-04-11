//
//  CatAPIService.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation

protocol CatService {
    func getBreeds(limit: Int, page: Int) async -> Result<[Breed], Error>
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
}
