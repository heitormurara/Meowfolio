//
//  Loader.swift
//  Meowfolio
//
//  Created by Heitor Murara on 11/04/24.
//

import Foundation

final class Loader: Loading {
    @Published var state: LoadingState
    
    init(state: LoadingState) {
        self.state = state
    }
    
    func set(_ newState: LoadingState) {
        Task { @MainActor in
            self.state = newState
        }
    }
}
