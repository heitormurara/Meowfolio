//
//  CatAPIRoute.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation

enum CatAPIRoute {
    case getBreeds(limit: Int, page: Int)
}

extension CatAPIRoute: Route {
    var baseURL: String {
        "https://api.thecatapi.com"
    }
    
    var path: String {
        switch self {
        case .getBreeds:
            return "/v1/breeds"
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .getBreeds(let limit, let page):
            return [
                "limit": "\(limit)",
                "page": "\(page)",
                "api_key": ProcessInfo.processInfo.environment["cat_api_key"] ?? ""
            ]
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        nil
    }
}
