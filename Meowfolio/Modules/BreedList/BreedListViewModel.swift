//
//  CatListViewModel.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation
import SwiftUI

final class BreedListViewModel: ObservableObject {
    private let catService: CatService
    private var paginationManager: Pagination
    
    @Published private(set) var breeds = [Breed]()
    @Published private(set) var loadingState: LoadingState
    
    init(catService: CatService = CatAPIService(), 
         loadingState: LoadingState = .idle,
         paginationManager: Pagination = PaginationManager(),
         breeds: [Breed] = [Breed]()) {
        self.catService = catService
        self.loadingState = loadingState
        self.paginationManager = paginationManager
        self.breeds = breeds
    }
    
    func requestIfNeeded(currentIndex: Int) async {
        guard loadingState != .loading else { return }
        await paginationManager.requestIfNeeded(currentIndex: currentIndex) {
            await self.getBreeds()
        }
    }
    
    func getBreeds() async {
        guard loadingState != .loading else { return }
        await MainActor.run { loadingState = .loading }
        
        let result = await catService.getBreeds(limit: paginationManager.limit, page: paginationManager.page)
        
        switch result {
        case .success(let breeds):
            paginationManager.addLoadedItems(amount: breeds.count)
            
            await MainActor.run {
                self.breeds.append(contentsOf: breeds)
                loadingState = .loaded
            }
        case .failure(let error):
            await MainActor.run { loadingState = .failed(error) }
        }
    }
}
