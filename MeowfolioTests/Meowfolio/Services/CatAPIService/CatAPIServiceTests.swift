//
//  CatAPIServiceTests.swift
//  MeowfolioTests
//
//  Created by Heitor Murara on 10/04/24.
//

import XCTest
@testable import Meowfolio

final class CatAPIServiceTests: XCTestCase {
    func test_getBreeds_success() async {
        let expectedBreeds = makeBreeds()
        let mockServiceProvider = MockServiceProvider(handler: {
            return .success(expectedBreeds)
        })
        
        let sut = CatAPIService(serviceProvider: mockServiceProvider)
        let result = await sut.getBreeds(limit: 10, page: 1)
        
        switch result {
        case .success(let breeds):
            XCTAssertEqual(expectedBreeds.count, breeds.count, "Should have returned \(expectedBreeds.count) breeds, got \(breeds.count) instead")
            XCTAssertEqual(expectedBreeds.first?.id, breeds.first?.id, "Unmatching first element")
        case .failure:
            XCTFail("Should return success, got failure instead")
        }
    }
    
    func test_getBreeds_failure() async {
        let expectedError = DummyError.generic
        let mockServiceProvider = MockServiceProvider(handler: {
            return .failure(expectedError)
        })
        
        let sut = CatAPIService(serviceProvider: mockServiceProvider)
        let result = await sut.getBreeds(limit: 10, page: 1)
        
        switch result {
        case .success:
            XCTFail("Should return failure, got success instead")
        case .failure(let error):
            XCTAssertEqual(error as? DummyError, expectedError, "Should return \(expectedError), got \(error) instead")
        }
    }
    
    func test_getBreedDetails_success() async {
        let expectedBreedDetail = makeBreedDetails()
        let mockServiceProvider = MockServiceProvider(handler: {
            return .success(expectedBreedDetail)
        })
        
        let sut = CatAPIService(serviceProvider: mockServiceProvider)
        let result = await sut.getBreedDetails(makeBreeds().first!)
        
        switch result {
        case .success(let breedDetail):
            XCTAssertEqual(expectedBreedDetail.name, breedDetail.name, "Unmatching element")
        case .failure:
            XCTFail("Should return success, got failure instead")
        }
    }
    
    func test_getBreedDetails_failure() async {
        let expectedError = DummyError.generic
        let mockServiceProvider = MockServiceProvider(handler: {
            return .failure(expectedError)
        })
        
        let sut = CatAPIService(serviceProvider: mockServiceProvider)
        let result = await sut.getBreedDetails(makeBreeds().first!)
        
        switch result {
        case .success:
            XCTFail("Should return failure, got success instead")
        case .failure(let error):
            XCTAssertEqual(error as? DummyError, expectedError, "Should return \(expectedError), got \(error) instead")
        }
    }
    
    private func makeBreeds() -> [Breed] {
        [
            Breed(id: "1", name: "Breed 1", temperament: "", origin: "", image: BreedImage(id: "", url: "")),
            Breed(id: "2", name: "Breed 2", temperament: "", origin: "", image: BreedImage(id: "", url: "")),
        ]
    }
    
    private func makeBreedDetails() -> BreedDetails {
        BreedDetails(name: "Name 1", weight: .init(metric: ""), origin: "", temperament: "", lifeSpan: "", description: "", adaptabilityScale: 1, affectionLevelScale: 1, childFriendlyScale: 1, dogFriendlyScale: 1, energyLevelScale: 1)
    }
}
