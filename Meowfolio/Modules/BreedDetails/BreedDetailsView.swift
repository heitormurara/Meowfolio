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
        ScrollView {
            content
                .padding()
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
                mainInformationView(for: breedDetails)
                descriptionView(for: breedDetails)
                informationView(for: breedDetails)
            }
            
            Spacer()
        }
    }
    
    private func mainInformationView(for breedDetails: BreedDetails) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(breedDetails.name)
                .font(.title)
                .fontWeight(.bold)
            
            image
                .padding(.top, 10)
            
            Label {
                Text(breedDetails.origin)
            } icon: {
                Image(systemName: "mappin.and.ellipse")
            }
            .font(.caption)
            .foregroundStyle(.gray)
            .labelStyle(SpaceLabelStyle(spacing: 4))
            .padding(.top, 20)
            
            Text(breedDetails.temperament)
                .font(.caption2)
                .foregroundStyle(.gray)
                .padding(.top, 10)
        }
    }
    
    private var image: some View {
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
            Text("Description")
                .font(.headline)
            
            Text(breedDetails.description)
                .font(.body)
        }
    }
    
    private func informationView(for breedDetails: BreedDetails) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Information")
                .font(.headline)
            
            HStack {
                rectangleInfoView(title: "\(breedDetails.weight.metric) kgs",
                                  subtitle: "Weight")
                
                rectangleInfoView(title: "\(breedDetails.lifeSpan) years",
                                  subtitle: "Life Span")
            }
            
            progressView(title: "Adaptability", value: breedDetails.adaptabilityScale)
            
            progressView(title: "Affection Level", value: breedDetails.affectionLevelScale)
            
            progressView(title: "Child Friendly", value: breedDetails.childFriendlyScale)
            
            progressView(title: "Dog Friendly", value: breedDetails.dogFriendlyScale)
            
            progressView(title: "Energy Level", value: breedDetails.energyLevelScale)
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
