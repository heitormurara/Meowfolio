//
//  BreedDetailsViewModel.swift
//  Meowfolio
//
//  Created by Heitor Murara on 11/04/24.
//

import Foundation

final class BreedDetailsViewModel: ObservableObject {
    private let catService: CatService
    let breed: Breed
    
    @Published private(set) var breedDetails: BreedDetails? = nil
    @Published private(set) var loadingState: LoadingState
    
    init(catService: CatService = CatAPIService(),
         breed: Breed,
         loadingState: LoadingState = .idle) {
        self.catService = catService
        self.breed = breed
        self.loadingState = loadingState
    }
    
    func getDetails() async {
        guard loadingState != .loading else { return }
        await MainActor.run { loadingState = .loading }
        
        let result = await catService.getBreedDetails(breed)
        
        switch result {
        case .success(let breedDetails):
            await MainActor.run {
                self.breedDetails = breedDetails
                loadingState = .loaded
            }
        case .failure(let error):
            await MainActor.run { loadingState = .failed(error) }
        }
    }
}
