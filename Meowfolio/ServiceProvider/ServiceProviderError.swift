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
