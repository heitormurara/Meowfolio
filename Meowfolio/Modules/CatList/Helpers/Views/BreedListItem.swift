//
//  CatListItem.swift
//  Meowfolio
//
//  Created by Heitor Murara on 10/04/24.
//

import SwiftUI

struct BreedListItem: View {
    struct Constant {
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
    }
    
    private var image: some View {
        AsyncImage(url: URL(string: breed.image.url)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            imagePlaceholder
        }
        .frame(width: Constant.imageWidth, height: Constant.imageHeight)
        .clipShape(
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
        )
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
    }
    
    private var information: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(breed.name)
                .font(.headline)
            
            Label {
                HStack {
                    Text(breed.origin)
                    Text("•")
                    Text("\(breed.lifeSpan) years")
                }
            } icon: {
                Image(systemName: "mappin.and.ellipse")
            }
            .font(.caption)
            .foregroundStyle(.gray)
            
            ForEach(breed.temperament, id: \.self) {
                Text($0)
            }
            .font(.caption2)
            .foregroundStyle(.gray)
        }
        .padding()
        .background(.white)
        .clipShape(
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 0,
                                                                     bottomLeading: 0,
                                                                     bottomTrailing: 10,
                                                                     topTrailing: 10))
        )
    }
}

#Preview {
    VStack {
        Spacer()
        
        let breedImage = BreedImage(id: "0XYvRd7oD",
                                    url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg")
        let breed = Breed(id: "abys",
                          name: "Abyssinian",
                          temperament: ["Active, Energetic, Independent, Intelligent, Gentle"],
                          origin: "Egypt",
                          lifeSpan: "14 - 15",
                          image: breedImage)
        BreedListItem(breed)
            .padding()
        
        Spacer()
    }
    .frame(maxWidth: .infinity)
    .background(.gray.opacity(0.2))
}
