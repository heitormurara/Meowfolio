//
//  Pagination.swift
//  Meowfolio
//
//  Created by Heitor Murara on 11/04/24.
//

import Foundation

protocol Pagination {
    var page: Int { get }
    var limit: Int { get }
    var itemsLoadedCount: Int { get }
    var itemsFromEndThreshold: Int { get }
    
    func addLoadedItems(amount: Int)
    func requestIfNeeded(currentIndex: Int, 
                         completion: @escaping () async -> Void) async
}
