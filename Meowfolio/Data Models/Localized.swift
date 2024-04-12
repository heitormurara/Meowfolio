//
//  Localized.swift
//  Meowfolio
//
//  Created by Heitor Murara on 11/04/24.
//

import Foundation

enum Localized: String {
    
    // MARK: - BreedList
    case breedListTitle
    
    // MARK: - BreedDetails
    case breedDetailsDescriptionSectionTitle
    case breedDetailsInformationSectionTitle
    case breedDetailsWeightCaptionTitle
    case breedDetailsWeightCaptionFormatValue
    case breedDetailsLifeSpanCaptionTitle
    case breedDetailsLifeSpanCaptionFormatValue
    case breedDetailsAdaptabilityScaleTitle
    case breedDetailsAffectionLevelScaleTitle
    case breedDetailsChildFriendlyScaleTitle
    case breedDetailsDogFriendlyScaleTitle
    case breedDetailsEnergyLevelScaleTitle
    
    // MARK: - ReusableViews
    
    // MARK: ErrorView
    case errorViewHeadline
    case errorViewTryAgainButton
    case errorViewDescriptionDefault
    
    // MARK: - Errors
    
    // MARK: ServiceProviderError
    case serviceProviderErrorUnavailableURLRequest
    case serviceProviderErrorUnavailableURLResponse
    case serviceProviderErrorBadRequest
    case serviceProviderErrorUnauthorized
    case serviceProviderErrorTooManyRequests
    case serviceProviderErrorInternalServerError
    case serviceProviderErrorServiceUnavailable
    case serviceProviderErrorUnmapped
    case serviceProviderErrorUnknown
}

extension Localized {
    var string: String {
        NSLocalizedString(rawValue, comment: "")
    }
}
