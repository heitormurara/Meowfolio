//
//  BreedListViewModelTests.swift
//  MeowfolioTests
//
//  Created by Heitor Murara on 11/04/24.
//

import XCTest
import Combine
@testable import Meowfolio

final class BreedListViewModelTests: XCTestCase {
    func test_getBreeds_earlyReturns_whenLoading() async {
        let mockCatService = MockCatService()
        let sut = BreedListViewModel(catService: mockCatService,
                                     loadingState: .loading)
        await sut.getBreeds()
        
        XCTAssertEqual(sut.loadingState, .loading)
        XCTAssertEqual(mockCatService.getBreedsCount, 0)
    }
    
    func test_getBreeds_setLoading() async {
        let dummyCatService = DummyCatService()
        let sut = BreedListViewModel(catService: dummyCatService)
        var loadingStates = [LoadingState]()
        var cancellables = Set<AnyCancellable>()
        
        sut.$loadingState.sink {
            loadingStates.append($0)
        }.store(in: &cancellables)
        
        await sut.getBreeds()
        XCTAssertTrue(loadingStates.contains(where: { $0 == .loading }))
    }
    
    func test_getBreeds_requestsFromService() async {
        let mockCatService = MockCatService()
        let sut = BreedListViewModel(catService: mockCatService)
        await sut.getBreeds()
        XCTAssertEqual(mockCatService.getBreedsCount, 1)
    }
    
    func test_getBreeds_onSuccess_addLoadedItemsToPagination() async {
        let stubCatService = StubCatService()
        stubCatService.getBreedsHandler = { .success([]) }
        
        let paginationMock = PaginationMock()
        let sut = BreedListViewModel(catService: stubCatService, paginationManager: paginationMock)
        await sut.getBreeds()
        XCTAssertTrue(paginationMock.addedLoadedItems)
    }
    
    func test_getBreeds_onSuccess_appendsBreeds() async {
        let breed = Breed(id: "1", name: "", temperament: "", origin: "", image: .init(id: "", url: ""))
        let stubCatService = StubCatService()
        stubCatService.getBreedsHandler = { .success([breed]) }
        let sut = BreedListViewModel(catService: stubCatService)
        await sut.getBreeds()
        XCTAssertEqual(sut.breeds.first?.id, breed.id)
    }
    
    func test_getBreeds_onSuccess_setLoadingState() async {
        let breed = Breed(id: "1", name: "", temperament: "", origin: "", image: .init(id: "", url: ""))
        let stubCatService = StubCatService()
        stubCatService.getBreedsHandler = { .success([breed]) }
        let sut = BreedListViewModel(catService: stubCatService)
        await sut.getBreeds()
        XCTAssertEqual(sut.loadingState, .loaded)
    }
    
    func test_getBreeds_onFailure_setFailureState() async {
        let error = DummyError.generic
        let stubCatService = StubCatService()
        stubCatService.getBreedsHandler = { .failure(error) }
        let sut = BreedListViewModel(catService: stubCatService)
        await sut.getBreeds()
        XCTAssertEqual(sut.loadingState, .failed(error))
    }
    
    func test_requestIfNeeded_earlyReturns_whenLoading() async {
        let paginationMock = PaginationMock()
        
        let sut = BreedListViewModel(loadingState: .loading, paginationManager: paginationMock)
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

final class DummyCatService: CatService {
    func getBreeds(limit: Int, page: Int) async -> Result<[Breed], Error> {
        .success([])
    }
    
    func getBreedDetails(_ breed: Breed) async -> Result<BreedDetails, Error> {
        .failure(DummyError.generic)
    }
}

final class MockCatService: CatService {
    var getBreedsCount = 0
    var getBreedDetailsCount = 0
    
    func getBreeds(limit: Int, page: Int) async -> Result<[Meowfolio.Breed], Error> {
        getBreedsCount += 1
        return .success([])
    }
    
    func getBreedDetails(_ breed: Breed) async -> Result<BreedDetails, Error> {
        getBreedDetailsCount += 1
        return .failure(DummyError.generic)
    }
}

final class StubCatService: CatService {
    var getBreedsHandler: (() -> Result<[Breed], Error>)? = nil
    var getBreedDetailsHandler: (() -> Result<BreedDetails, Error>)? = nil
    
    func getBreeds(limit: Int, page: Int) async -> Result<[Breed], Error> {
        getBreedsHandler?() ?? .failure(DummyError.generic)
    }
    
    func getBreedDetails(_ breed: Breed) async -> Result<BreedDetails, Error> {
        getBreedDetailsHandler?() ?? .failure(DummyError.generic)
    }
}
