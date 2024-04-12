//
//  Loading.swift
//  Meowfolio
//
//  Created by Heitor Murara on 11/04/24.
//

import Foundation

protocol Loading: ObservableObject {
    var state: LoadingState { get }
    func set(_ newState: LoadingState)
}
