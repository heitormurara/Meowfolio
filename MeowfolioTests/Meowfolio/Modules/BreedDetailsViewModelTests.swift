//
//  BreedDetailsViewModelTests.swift
//  MeowfolioTests
//
//  Created by Heitor Murara on 11/04/24.
//

import XCTest
import Combine
@testable import Meowfolio

final class BreedDetailsViewModelTests: XCTestCase {
    func test_getDetails_earlyReturs_whenLoading() async {
        let mockCatService = MockCatService()
        let sut = BreedDetailsViewModel(catService: mockCatService, 
                                        breed: makeBreed(),
                                        loadingState: .loading)
        await sut.getDetails()
        
        XCTAssertEqual(sut.loadingState, .loading)
        XCTAssertEqual(mockCatService.getBreedDetailsCount, 0)
    }
    
    func test_getDetails_setLoading() async {
        let dummyCatService = DummyCatService()
        let sut = BreedDetailsViewModel(catService: dummyCatService, breed: makeBreed())
        var loadingStates = [LoadingState]()
        var cancellables = Set<AnyCancellable>()
        
        sut.$loadingState.sink {
            loadingStates.append($0)
        }.store(in: &cancellables)
        
        await sut.getDetails()
        XCTAssertTrue(loadingStates.contains(where: { $0 == .loading }))
    }
    
    func test_getDetails_requestsFromService() async {
        let mockCatService = MockCatService()
        let sut = BreedDetailsViewModel(catService: mockCatService, breed: makeBreed())
        await sut.getDetails()
        XCTAssertEqual(mockCatService.getBreedDetailsCount, 1)
    }
    
    func test_getDetails_onSuccess_setBreedDetails() async {
        let breedDetails = makeBreedDetails()
        let stubCatService = StubCatService()
        stubCatService.getBreedDetailsHandler = {
            .success(breedDetails)
        }
        let sut = BreedDetailsViewModel(catService: stubCatService, breed: makeBreed())
        await sut.getDetails()
        XCTAssertEqual(sut.breedDetails?.name, breedDetails.name)
    }
    
    func test_getDetails_onSuccess_setLoadedState() async {
        let breedDetails = makeBreedDetails()
        let stubCatService = StubCatService()
        stubCatService.getBreedDetailsHandler = {
            .success(breedDetails)
        }
        let sut = BreedDetailsViewModel(catService: stubCatService, breed: makeBreed())
        await sut.getDetails()
        XCTAssertEqual(sut.loadingState, .loaded)
    }
    
    func test_getDetails_onFailure_setFailureState() async {
        let error = DummyError.generic
        let stubCatService = StubCatService()
        stubCatService.getBreedDetailsHandler = { .failure(error) }
        let sut = BreedDetailsViewModel(catService: stubCatService, breed: makeBreed())
        await sut.getDetails()
        XCTAssertEqual(sut.loadingState, .failed(error))
    }
    
    private func makeBreed() -> Breed {
        Breed(id: "", name: "", temperament: "", origin: "", image: .init(id: "", url: ""))
    }
    
    private func makeBreedDetails() -> BreedDetails {
        BreedDetails(name: "Breed 1", weight: .init(metric: ""), origin: "", temperament: "", lifeSpan: "", description: "", adaptabilityScale: 1, affectionLevelScale: 1, childFriendlyScale: 1, dogFriendlyScale: 1, energyLevelScale: 1)
    }
}
