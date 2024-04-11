//
//  ServiceProviding.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation

protocol ServiceProviding {
    func request<T>(_ route: Route,
                    decodeInto modelType: T.Type) async -> Result<T, Error> where T : Decodable
}
