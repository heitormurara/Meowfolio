//
//  CatListViewModel.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation
import SwiftUI

final class BreedListViewModel<L>: ObservableObject where L: Loading {
    private let catService: CatService
    private var paginationManager: Pagination
    
    @Published private(set) var breeds = [Breed]()
    @Published private(set) var loading: L
    
    init(catService: CatService = CatAPIService(), 
         loading: L = Loader(state: .idle),
         paginationManager: Pagination = PaginationManager(),
         breeds: [Breed] = [Breed]()) {
        self.catService = catService
        self.loading = loading
        self.paginationManager = paginationManager
        self.breeds = breeds
    }
    
    func requestIfNeeded(currentIndex: Int) async {
        guard loading.state != .loading else { return }
        await paginationManager.requestIfNeeded(currentIndex: currentIndex) {
            await self.getBreeds()
        }
    }
    
    func getBreeds() async {
        guard loading.state != .loading else { return }
        loading.set(.loading)
        
        let result = await catService.getBreeds(limit: paginationManager.limit, page: paginationManager.page)
        
        switch result {
        case .success(let breeds):
            paginationManager.addLoadedItems(amount: breeds.count)
            
            await MainActor.run {
                self.breeds.append(contentsOf: breeds)
            }
            loading.set(.loaded)
        case .failure(let error):
            loading.set(.failed(error))
        }
    }
}
