//
//  CatListItem.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import SwiftUI

struct BreedListItem: View {
    struct Constant {
        static let height: CGFloat = 140
        static let imageWidth: CGFloat = 120
        static let imageHeight: CGFloat = 140
    }
    
    private let breed: Breed
    
    init(_ breed: Breed) {
        self.breed = breed
    }
    
    var body: some View {
        HStack(spacing: 0) {
            image
            information
        }
        .frame(height: Constant.height)
    }
    
    private var image: some View {
        VStack {
            Spacer()
            
            AsyncImage(url: URL(string: breed.image.url)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(
                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                    )
            } placeholder: {
                imagePlaceholder
            }
            .frame(maxWidth: Constant.imageWidth, maxHeight: Constant.imageHeight)
            
            Spacer()
        }
    }
    
    private var imagePlaceholder: some View {
        ZStack {
            Image(systemName: "cat")
                .resizable()
                .scaledToFit()
                .padding()
                .foregroundStyle(.white)
        }
        .frame(width: Constant.imageWidth, height: Constant.imageHeight)
        .background(.gray)
        .clipShape(
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
        )
    }
    
    private var information: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(breed.name)
                .font(.headline)
            
            Label {
                Text(breed.origin)
            } icon: {
                Image(systemName: "mappin.and.ellipse")
            }
            .font(.caption)
            .foregroundStyle(.gray)
            .labelStyle(SpaceLabelStyle(spacing: 4))
            
            Text(breed.temperament)
                .font(.caption2)
                .foregroundStyle(.gray)
        }
        .padding()
    }
}

#Preview {
    VStack {
        Spacer()
        
        let breedImage = BreedImage(id: "0XYvRd7oD",
                                    url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg")
        let breed = Breed(id: "abys",
                          name: "Abyssinian",
                          temperament: "Active, Energetic, Independent, Intelligent, Gentle",
                          origin: "Egypt",
                          image: breedImage)
        BreedListItem(breed)
            .padding()
        
        Spacer()
    }
    .frame(maxWidth: .infinity)
    .background(.gray.opacity(0.2))
}
