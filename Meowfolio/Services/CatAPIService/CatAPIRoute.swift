//
//  CatAPIRoute.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation

enum CatAPIRoute {
    case getBreeds(limit: Int, page: Int)
    case getBreedDetails(id: String)
}

extension CatAPIRoute: Route {
    var baseURL: String {
        "https://api.thecatapi.com"
    }
    
    var path: String {
        switch self {
        case .getBreeds:
            return "/v1/breeds"
        case .getBreedDetails(let id):
            return "/v1/breeds/\(id)"
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
        case .getBreedDetails:
            return ["api_key": ProcessInfo.processInfo.environment["cat_api_key"] ?? ""]
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        nil
    }
}
