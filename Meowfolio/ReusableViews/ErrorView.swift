//
//  ErrorView.swift
//  Meowfolio
//
//  Created by Heitor Murara on 11/04/24.
//

import SwiftUI

struct ErrorView: View {
    let errorDescription: String
    let tryAgain: () -> Void
    
    init(errorDescription: String?, tryAgain: @escaping () -> Void) {
        self.errorDescription = errorDescription ?? Localized.errorViewDescriptionDefault.string
        self.tryAgain = tryAgain
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("sad-cat")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text(Localized.errorViewHeadline.string)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(errorDescription)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            Button(Localized.errorViewTryAgainButton.string) {
                tryAgain()
            }
            
            Spacer()
        }
        .padding()
    }
}
