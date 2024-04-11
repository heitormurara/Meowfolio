//
//  ServiceProviderTests.swift
//  MeowfolioTests
//
//  Created by Heitor Murara on 10/04/24.
//

import XCTest
@testable import Meowfolio

final class ServiceProviderTests: XCTestCase {
    func test_request_failsWithExpectedServiceProviderError() async {
        await expect(error: .badRequest, forStatusCode: 400)
        await expect(error: .unauthorized, forStatusCode: 401)
        await expect(error: .tooManyRequests, forStatusCode: 429)
        await expect(error: .internalServerError, forStatusCode: 500)
        await expect(error: .serviceUnavailable, forStatusCode: 503)
        await expect(error: .unmapped, forStatusCode: 600)
    }
    
    func test_request_failsWithUnavailableURLRequest_whenEmptyURL() async {
        let sut = makeSUT()
        let result = await sut.request(DummyRoute.empty, decodeInto: DummyStringCodable.self)
        expect(.unavailableURLRequest, in: result)
    }
    
    func test_request_failsWithUnknownError_whenRequestThrows() async {
        let sut = makeSUT()
        let error = URLError(.badServerResponse, userInfo: [:])
        
        MockURLProtocol.requestHandler = { _ in
            throw error
        }
        
        let result = await sut.request(DummyRoute.generic, decodeInto: DummyStringCodable.self)
        expect(.unknown(error), in: result)
    }
    
    func test_request_successWithDecodable() async throws {
        let sut = makeSUT()
        let dummy = DummyStringCodable(text: "Dummy")
        let dummyEncoded = try JSONEncoder().encode(dummy)
        
        setRequestHandler(withStatusCode: 200, data: dummyEncoded)
        
        let result = await sut.request(DummyRoute.generic, decodeInto: DummyStringCodable.self)
        
        switch result {
        case .success(let success):
            XCTAssertEqual(success, dummy, "Unmatching result. Expected \(dummy) got \(success) instead")
        case .failure(let failure):
            XCTFail("Should complete with success")
        }
    }
    
    func test_request_failsOnDecodingError() async throws {
        let sut = makeSUT()
        let dummyStringCodable = DummyStringCodable(text: "Dummy")
        let dummyStringEncoded = try JSONEncoder().encode(dummyStringCodable)
        
        setRequestHandler(withStatusCode: 200, data: dummyStringEncoded)
        
        let result = await sut.request(DummyRoute.generic, decodeInto: DummyIntCodable.self)
        
        switch result {
        case .success(let success):
            XCTFail("Should complete with failure due to decoding error")
        case .failure(let failure):
            break
        }
    }
    
    private func expect(error: ServiceProviderError, forStatusCode statusCode: Int) async {
        let sut = makeSUT()
        setRequestHandler(withStatusCode: statusCode)
        
        let result = await sut.request(DummyRoute.generic, decodeInto: DummyStringCodable.self)
        expect(error, in: result)
    }
    
    private func makeSUT() -> ServiceProvider {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        return ServiceProvider(urlSession: urlSession)
    }
    
    private func setRequestHandler(withStatusCode statusCode: Int, data: Data = "".data(using: .utf8)!) {
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: DummyRoute.generic.url!,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, data)
        }
    }
    
    private func expect<T>(_ expectedError: ServiceProviderError, in result: Result<T, Error>) where T: Decodable {
        guard case let .failure(error) = result else {
            XCTFail("Should have returned an error, got \(result) instead")
            return
        }
        
        guard let serviceProviderError = error as? ServiceProviderError else {
            XCTFail("Should have returned error of type `ServiceProviderError`")
            return
        }
        
        switch (expectedError, serviceProviderError) {
        case (.unavailableURLRequest, .unavailableURLRequest),
            (.unavailableURLResponse, .unavailableURLResponse),
            (.badRequest, .badRequest),
            (.unauthorized, .unauthorized),
            (.tooManyRequests, .tooManyRequests),
            (.internalServerError, .internalServerError),
            (.serviceUnavailable, .serviceUnavailable),
            (.unmapped, .unmapped):
            break
        case let (.unknown(lhsError), .unknown(rhsError)):
            XCTAssertEqual(lhsError.localizedDescription, rhsError.localizedDescription)
        default:
            XCTFail("Completed with unmatching error. Expected \(expectedError), got \(serviceProviderError) instead")
        }
    }
}
