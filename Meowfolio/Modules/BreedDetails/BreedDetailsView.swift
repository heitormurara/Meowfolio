//
//  BreedDetailsView.swift
//  Meowfolio
//
//  Created by Heitor Murara on 11/04/24.
//

import SwiftUI

struct BreedDetailsView: View {
    @ObservedObject private var viewModel: BreedDetailsViewModel
    
    init(viewModel: BreedDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                content
                    .padding()
            }
            .navigationTitle(viewModel.breed.name)
        }
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.1))
        .task {
            await viewModel.getDetails()
        }
        .opacity(viewModel.loadingState == .loading ? 0 : 1)
        .overlay {
            if viewModel.loadingState == .loading {
                ProgressView()
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if let breedDetails = viewModel.breedDetails {
            VStack(alignment: .leading, spacing: 20) {
                imageView(for: breedDetails)
                descriptionView(for: breedDetails)
                informationView(for: breedDetails)
            }
        }
    }
    
    private func imageView(for breedDetails: BreedDetails) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            asyncImage
            imageCaption(for: breedDetails)
        }
    }
    
    private func imageCaption(for breedDetails: BreedDetails) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label {
                Text(breedDetails.origin)
            } icon: {
                Image(systemName: "mappin.and.ellipse")
            }
            .font(.caption)
            .foregroundStyle(.gray)
            .labelStyle(SpaceLabelStyle(spacing: 4))
            
            Text(breedDetails.temperament)
                .font(.caption2)
                .foregroundStyle(.gray)
        }
    }
    
    private var asyncImage: some View {
        AsyncImage(url: URL(string: viewModel.breed.image.url)) { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                )
        } placeholder: {
            HStack {}
        }
    }
    
    private func descriptionView(for breedDetails: BreedDetails) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Localized.breedDetailsDescriptionSectionTitle.string)
                .font(.headline)
            
            Text(breedDetails.description)
                .font(.body)
        }
    }
    
    private func informationView(for breedDetails: BreedDetails) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(Localized.breedDetailsInformationSectionTitle.string)
                .font(.headline)
            
            HStack {
                rectangleInfoView(title: String(format: Localized.breedDetailsWeightCaptionFormatValue.string, breedDetails.weight.metric),
                                  subtitle: Localized.breedDetailsWeightCaptionTitle.string)
                
                rectangleInfoView(title: String(format: Localized.breedDetailsLifeSpanCaptionFormatValue.string, breedDetails.lifeSpan),
                                  subtitle: Localized.breedDetailsLifeSpanCaptionTitle.string)
            }
            
            progressView(title: Localized.breedDetailsAdaptabilityScaleTitle.string, 
                         value: breedDetails.adaptabilityScale)
            
            progressView(title: Localized.breedDetailsAffectionLevelScaleTitle.string, 
                         value: breedDetails.affectionLevelScale)
            
            progressView(title: Localized.breedDetailsChildFriendlyScaleTitle.string, 
                         value: breedDetails.childFriendlyScale)
            
            progressView(title: Localized.breedDetailsDogFriendlyScaleTitle.string,
                         value: breedDetails.dogFriendlyScale)
            
            progressView(title: Localized.breedDetailsEnergyLevelScaleTitle.string,
                         value: breedDetails.energyLevelScale)
        }
    }
    
    private func rectangleInfoView(title: String, subtitle: String) -> some View {
        VStack {
            Text(title)
                .fontWeight(.medium)
            Text(subtitle)
                .font(.caption)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .stroke(.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func progressView(title: String, value: Int) -> some View {
        ProgressView(title, value: Float(value) / 5.0)
    }
}

#Preview {
    let breed = Breed(id: "abys", name: "Abyssinian", temperament: "Active, Energetic, Independent, Intelligent, Gentle", origin: "Egypt", image: .init(id: "0XYvRd7oD", url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"))
    let viewModel = BreedDetailsViewModel(breed: breed)
    return BreedDetailsView(viewModel: viewModel)
}
