//
//  CatListView.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import SwiftUI

struct BreedListView: View {
    @ObservedObject private var viewModel = BreedListViewModel()
    
    var body: some View {
        let breeds = viewModel.breeds.enumerated().map({ $0 })
        
        return List(breeds, id: \.element.id) { index, breed in
            BreedListItem(breed)
                .onAppear {
                    Task { await viewModel.getBreedsIfNeeded(currentIndex:index) }
                }
        }
        .background(.gray.opacity(0.1))
    }
}

#Preview {
    BreedListView()
}
