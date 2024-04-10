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
        Text("Hello, World!")
    }
}

#Preview {
    BreedListView()
}
