//
//  ServiceProviderError.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation

enum ServiceProviderError: Error {
    case unavailableURLRequest
    case unavailableURLResponse
    case badRequest
    case unauthorized
    case tooManyRequests
    case internalServerError
    case serviceUnavailable
    case unmapped
    case unknown(Error)
}

extension ServiceProviderError: ErrorWithDescription {
    var description: String {
        switch self {
        case .unavailableURLRequest:
            Localized.serviceProviderErrorUnavailableURLRequest.string
        case .unavailableURLResponse:
            Localized.serviceProviderErrorUnavailableURLResponse.string
        case .badRequest:
            Localized.serviceProviderErrorBadRequest.string
        case .unauthorized:
            Localized.serviceProviderErrorUnauthorized.string
        case .tooManyRequests:
            Localized.serviceProviderErrorTooManyRequests.string
        case .internalServerError:
            Localized.serviceProviderErrorInternalServerError.string
        case .serviceUnavailable:
            Localized.serviceProviderErrorServiceUnavailable.string
        case .unmapped:
            Localized.serviceProviderErrorUnmapped.string
        case .unknown:
            Localized.serviceProviderErrorUnknown.string
        }
    }
}
