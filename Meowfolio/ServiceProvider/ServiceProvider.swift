//
//  ServiceProvider.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation

final class ServiceProvider {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    private func request(_ route: Route) async -> Result<Data, ServiceProviderError> {
        guard let urlRequest = route.urlRequest else {
            return .failure(.unavailableURLRequest)
        }
        
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(ServiceProviderError.unavailableURLResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                return .success(data)
            case 400:
                return .failure(ServiceProviderError.badRequest)
            case 401:
                return .failure(ServiceProviderError.unauthorized)
            case 429:
                return .failure(ServiceProviderError.tooManyRequests)
            case 500:
                return .failure(ServiceProviderError.internalServerError)
            case 503:
                return .failure(ServiceProviderError.serviceUnavailable)
            default:
                return .failure(ServiceProviderError.unmapped)
            }
        } catch {
            return .failure(.unknown(error))
        }
    }
    
    private func decodeResult<T>(for data: Data,
                                 decodeInto modelType: T.Type) -> Result<T, Error> where T : Decodable {
        do {
            let decodable = try JSONDecoder().decode(modelType, from: data)
            return .success(decodable)
        } catch let error {
            return .failure(error)
        }
    }
}

extension ServiceProvider: ServiceProviding {
    func request<T>(_ route: Route, decodeInto modelType: T.Type) async -> Result<T, Error> where T : Decodable {
        let result = await request(route)
        
        switch result {
        case .success(let data):
            return decodeResult(for: data, decodeInto: modelType)
        case .failure(let error):
            return .failure(error)
        }
    }
}
