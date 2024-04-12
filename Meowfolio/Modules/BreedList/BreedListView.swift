//
//  CatListView.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import SwiftUI

struct BreedListView: View {
    @ObservedObject private var viewModel = BreedListViewModel()
    @State private var isLoading = false
    
    var body: some View {
        let breeds = viewModel.breeds.enumerated().map({ $0 })
        
        return NavigationStack {
            List(breeds, id: \.element.id) { index, breed in
                NavigationLink {
                    let viewModel = BreedDetailsViewModel(breed: breed)
                    BreedDetailsView(viewModel: viewModel)
                } label: {
                    BreedListItem(breed)
                        .onAppear {
                            Task { await viewModel.requestIfNeeded(currentIndex:index) }
                    }
                }
            }
            .background(.gray.opacity(0.1))
            .task {
                await viewModel.getBreeds()
            }
            .opacity(viewModel.loadingState == .loaded || viewModel.loadingState == .idle ? 1 : 0)
            .overlay { loadingView }
            .overlay { errorView }
            .navigationTitle(Localized.breedListTitle.string)
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        if viewModel.loadingState == .loading {
            ProgressView()
        }
    }
    
    @ViewBuilder
    private var errorView: some View {
        if case let .failed(error) = viewModel.loadingState {
            let errorWithDescription = error as? ErrorWithDescription
            ErrorView(errorDescription: errorWithDescription?.description) {
                Task { await viewModel.getBreeds() }
            }
        }
    }
}

#Preview {
    BreedListView()
}
