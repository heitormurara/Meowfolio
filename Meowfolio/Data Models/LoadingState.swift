//
//  LoadingState.swift
//  Meowfolio
//
//  Created by Heitor Murara on 11/04/24.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case failed(Error)
    case loaded
}

extension LoadingState: Equatable {
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.loaded, .loaded):
            return true
        case let (.failed(error1), .failed(error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}
