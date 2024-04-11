//
//  MockServiceProvider.swift
//  MeowfolioTests
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation
@testable import Meowfolio

final class MockServiceProvider: ServiceProviding {
    var handler: (() -> Result<Decodable, Error>)
    
    init(handler: @escaping () -> Result<Decodable, Error>) {
        self.handler = handler
    }
    
    func request<T>(_ route: Meowfolio.Route,
                    decodeInto modelType: T.Type) async -> Result<T, Error> where T : Decodable {
        let result = handler()
        
        switch result {
        case .success(let decodable):
            let decoded = decodable as! T
            return .success(decoded)
        case .failure(let error):
            return .failure(error)
        }
    }
}
