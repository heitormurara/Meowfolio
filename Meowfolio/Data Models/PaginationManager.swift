//
//  PaginationManager.swift
//  Meowfolio
//
//  Created by Heitor Murara on 11/04/24.
//

import Foundation

final class PaginationManager: Pagination {
    var page: Int
    var limit: Int
    var itemsLoadedCount: Int
    var itemsFromEndThreshold: Int
    
    init(page: Int = 0,
         limit: Int = 10,
         itemsLoadedCount: Int = 0,
         itemsFromEndThreshold: Int = 3) {
        self.page = page
        self.limit = limit
        self.itemsLoadedCount = itemsLoadedCount
        self.itemsFromEndThreshold = itemsFromEndThreshold
    }
    
    func requestIfNeeded(currentIndex: Int, completion: @escaping () async -> Void) async {
        guard isThresholdMet(currentIndex: currentIndex) else { return }
        
        page += 1
        await completion()
    }
    
    func addLoadedItems(amount: Int) {
        itemsLoadedCount += amount
    }
    
    private func isThresholdMet(currentIndex: Int) -> Bool {
        (itemsLoadedCount - currentIndex) == itemsFromEndThreshold
    }
}
