//
//  CatListViewModel.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import Foundation

final class BreedListViewModel: ObservableObject {
    @Published private(set) var breeds = [Breed]()
}
