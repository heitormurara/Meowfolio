//
//  BreedListViewModelTests.swift
//  MeowfolioTests
//
//  Created by Heitor Murara on 11/04/24.
//

import XCTest
@testable import Meowfolio

final class BreedListViewModelTests: XCTestCase {
    func test_getBreeds_earlyReturns_whenLoading() async {
        let mockCatService = MockCatService()
        let loadingSpy = LoadingSpy()
        loadingSpy.state = .loading
        
        let sut = BreedListViewModel(catService: mockCatService,
                                     loading: loadingSpy)
        await sut.getBreeds()
        
        XCTAssertFalse(loadingSpy.hasSetState(.loading))
        XCTAssertEqual(mockCatService.getBreedsCount, 0)
    }
    
    func test_getBreeds_setLoading() async {
        let dummyCatService = DummyCatService()
        let loadingSpy = LoadingSpy()
        let sut = BreedListViewModel(catService: dummyCatService,
                                     loading: loadingSpy)
        await sut.getBreeds()
        XCTAssertTrue(loadingSpy.hasSetState(.loading))
    }
    
    func test_getBreeds_requestsFromService() async {
        let mockCatService = MockCatService()
        let sut = BreedListViewModel(catService: mockCatService)
        await sut.getBreeds()
        XCTAssertEqual(mockCatService.getBreedsCount, 1)
    }
    
    func test_getBreeds_onSuccess_addLoadedItemsToPagination() async {
        let stubCatService = StubCatService {
            .success([])
        }
        let paginationMock = PaginationMock()
        let sut = BreedListViewModel(catService: stubCatService, paginationManager: paginationMock)
        await sut.getBreeds()
        XCTAssertTrue(paginationMock.addedLoadedItems)
    }
    
    func test_getBreeds_onSuccess_appendsBreeds() async {
        let breed = Breed(id: "1", name: "", temperament: "", origin: "", lifeSpan: "", image: .init(id: "", url: ""))
        let stubCatService = StubCatService {
            .success([breed])
        }
        let sut = BreedListViewModel(catService: stubCatService)
        await sut.getBreeds()
        XCTAssertEqual(sut.breeds.first?.id, breed.id)
    }
    
    func test_getBreeds_onSuccess_setLoadingState() async {
        let breed = Breed(id: "1", name: "", temperament: "", origin: "", lifeSpan: "", image: .init(id: "", url: ""))
        let stubCatService = StubCatService {
            .success([breed])
        }
        let loadingSpy = LoadingSpy()
        let sut = BreedListViewModel(catService: stubCatService, loading: loadingSpy)
        await sut.getBreeds()
        XCTAssertTrue(loadingSpy.hasSetState(.loaded))
    }
    
    func test_getBreeds_onFailure_setFailureState() async {
        let error = DummyError.generic
        let stubCatService = StubCatService {
            .failure(error)
        }
        let loadingSpy = LoadingSpy()
        let sut = BreedListViewModel(catService: stubCatService, loading: loadingSpy)
        await sut.getBreeds()
        XCTAssertTrue(loadingSpy.hasSetState(.failed(error)))
    }
    
    func test_requestIfNeeded_earlyReturns_whenLoading() async {
        let paginationMock = PaginationMock()
        let loadingSpy = LoadingSpy()
        loadingSpy.state = .loading
        
        let sut = BreedListViewModel(loading: loadingSpy, paginationManager: paginationMock)
        await sut.requestIfNeeded(currentIndex: 1)
        XCTAssertFalse(paginationMock.requestedIfNeeded)
    }
    
    func test_requestIfNeeded_requestsFromService() async {
        let mockCatService = MockCatService()
        let paginationStub = PaginationStub()
        let sut = BreedListViewModel(catService: mockCatService, paginationManager: paginationStub)
        await sut.requestIfNeeded(currentIndex: 1)
        XCTAssertEqual(mockCatService.getBreedsCount, 1)
    }
}

final class PaginationStub: Pagination {
    var page: Int = 0
    var limit: Int = 10
    var itemsLoadedCount: Int = 0
    var itemsFromEndThreshold: Int = 3
    
    func addLoadedItems(amount: Int) {}
    
    func requestIfNeeded(currentIndex: Int, completion: @escaping () async -> Void) async {
        await completion()
    }
}

final class PaginationMock: Pagination {
    var page: Int = 0
    var limit: Int = 10
    var itemsLoadedCount: Int = 0
    var itemsFromEndThreshold: Int = 3
    
    var addedLoadedItems = false
    var requestedIfNeeded = false
    
    func addLoadedItems(amount: Int) {
        addedLoadedItems = true
    }
    
    func requestIfNeeded(currentIndex: Int, completion: @escaping () async -> Void) async {
        requestedIfNeeded = true
    }
}

final class LoadingSpy: Loading {
    var state: LoadingState = .idle
    var setStates: [LoadingState] = []
    
    func set(_ newState: LoadingState) {
        setStates.append(newState)
    }
    
    func hasSetState(_ state: LoadingState) -> Bool {
        setStates.first(where: { $0 == state }) != nil
    }
}

final class DummyCatService: CatService {
    func getBreeds(limit: Int, page: Int) async -> Result<[Breed], Error> {
        return .success([])
    }
}

final class MockCatService: CatService {
    var getBreedsCount = 0
    
    func getBreeds(limit: Int, page: Int) async -> Result<[Meowfolio.Breed], Error> {
        getBreedsCount += 1
        return .success([])
    }
}

final class StubCatService: CatService {
    var handler: (() -> Result<[Breed], Error>)
    
    init(handler: @escaping () -> Result<[Breed], Error>) {
        self.handler = handler
    }
    
    func getBreeds(limit: Int, page: Int) async -> Result<[Breed], Error> {
        handler()
    }
}
