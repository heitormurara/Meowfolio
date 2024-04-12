//
//  PaginationManagerTests.swift
//  MeowfolioTests
//
//  Created by Heitor Murara on 11/04/24.
//

import XCTest
@testable import Meowfolio

final class PaginationManagerTests: XCTestCase {
    func test_requestIfNeeded_earlyReturns_whenThresholdNotMet() async {
        let sut = makeSUT()
        await sut.requestIfNeeded(currentIndex: 10) {
            XCTFail("Should not call for completion when threshold not met")
        }
        XCTAssertEqual(0, sut.page, "Should not add page when threshold not met")
    }
    
    func test_requestIfNeeded_completes_whenThresholdMet() async {
        let sut = makeSUT()
        let expectation = expectation(description: "Should complete when threshold is met")
        await sut.requestIfNeeded(currentIndex: 17) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation])
    }
    
    func test_requestIfNeeded_addsPage_whenThresholdMet() async {
        let sut = makeSUT()
        await sut.requestIfNeeded(currentIndex: 17) {}
        XCTAssertEqual(1, sut.page, "Should add to page when threshold is met")
    }
    
    func test_addLoadedItems_addsAmountToItemsLoadedCount() {
        let sut = makeSUT()
        sut.addLoadedItems(amount: 5)
        XCTAssertEqual(sut.itemsLoadedCount, 25, "Should have added to loadedItems.")
    }
    
    private func makeSUT() -> Pagination {
        PaginationManager(page: 0,
                          limit: 10,
                          itemsLoadedCount: 20,
                          itemsFromEndThreshold: 3)
    }
}
