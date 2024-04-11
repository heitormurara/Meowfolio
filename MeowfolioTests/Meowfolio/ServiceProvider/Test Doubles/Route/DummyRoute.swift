//
//  DummyRoute.swift
//  MeowfolioTests
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation
@testable import Meowfolio

enum DummyRoute: Route {
    case generic
    case empty
    
    var baseURL: String {
        switch self {
        case .generic:
            return "https://www.google.com"
        case .empty:
            return ""
        }
    }
    
    var path: String {
        switch self {
        case .generic:
            return "/maps"
        case .empty:
            return ""
        }
    }
    
    var parameters: [String : String]? { nil }
    
    var method: Meowfolio.HTTPMethod { . get }
    
    var headers: [String : String]? { nil }
    
    var sampleData: Data? { nil }
}
