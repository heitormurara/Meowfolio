//
//  CatAPIRouteTests.swift
//  MeowfolioTests
//
//  Created by Heitor Murara on 10/04/24.
//

import XCTest
@testable import Meowfolio

final class CatAPIRouteTests: XCTestCase {
    func test_getBreeds() {
        let route = CatAPIRoute.getBreeds(limit: 10, page: 1)
        let baseURL = "https://api.thecatapi.com"
        let path = "/v1/breeds"
        let parameters = ["limit": "10", "page": "1"]
        let method = HTTPMethod.get
        
        XCTAssertEqual(route.baseURL, baseURL, "Expected baseURL \(baseURL), got \(route.baseURL) instead")
        XCTAssertEqual(route.path, path, "Expected path \(path), got \(route.path) instead")
//        XCTAssertEqual(route.parameters, parameters, "Expected parameters \(parameters), got \(String(describing: route.parameters)) instead")
        XCTAssertEqual(route.method, method, "Expected method \(method), got \(route.method) instead")
        XCTAssertNil(route.headers, "Headers should be nil")
    }
}
