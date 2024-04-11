//
//  CatListViewModel.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation

final class BreedListViewModel: ObservableObject {
    private let catService: CatService
    private let limit = 10
    private let itemsFromEndThreshold = 3
    private var page = 0
    private var itemsLoadedCount = 0
    
    @Published private(set) var breeds = [Breed]()
    @Published private(set) var isLoading = false
    
    init(catService: CatService = CatAPIService()) {
        self.catService = catService
        Task { await getBreeds() }
    }
    
    func getBreedsIfNeeded(currentIndex: Int) async {
        guard !isLoading, isThresholdMet(currentIndex: currentIndex) else { return }
        page += 1
        await getBreeds()
    }
    
    private func getBreeds() async {
        setLoading(true)
        let result = await catService.getBreeds(limit: limit, page: page)
        
        switch result {
        case .success(let breeds):
            itemsLoadedCount += breeds.count
            await MainActor.run {
                self.breeds.append(contentsOf: breeds)
            }
        case .failure(let error):
            break
        }
        
        setLoading(false)
    }
    
    private func isThresholdMet(currentIndex: Int) -> Bool {
        (itemsLoadedCount - currentIndex) == itemsFromEndThreshold
    }
    
    private func setLoading(_ isLoading: Bool) {
        Task { @MainActor in
            self.isLoading = isLoading
        }
    }
}
