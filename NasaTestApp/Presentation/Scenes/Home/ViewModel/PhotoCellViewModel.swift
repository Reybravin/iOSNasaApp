//
//  PhotoCellViewModel.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 27.08.2021.
//

import UIKit

final class PhotoCellViewModel {
    
    private let model : EpicImage
    private let nasaDataRepository: NasaDataRepositoryInterface
//    private let scheme = "https"
//    private let host = "api.nasa.gov"
//    private let apiKey : String = "KK2KcxX66KsS1jjiVH7gQDdJWcBHSxyE1S93QMOL"
    
    init(model: EpicImage, nasaDataRepository: NasaDataRepositoryInterface) {
        self.model = model
        self.nasaDataRepository = nasaDataRepository
    }
    
//    var imageUrl : URL? {
//
//        let basePath = "/EPIC/archive/natural/"
//        guard let datePath = (model.date.split(separator: " ").first)?.replacingOccurrences(of: "-", with: "/") else { return nil }
//        let fileExtPath = "/png/"
//        let fileName = model.image + ".png"
//        let path = basePath + datePath + fileExtPath + fileName
//
//        var urlComponents = URLComponents()
//        urlComponents.scheme = scheme
//        urlComponents.host = host
//        urlComponents.path = path
//        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
//
//        return urlComponents.url
//
//    }
    
    var imageUrl : URL? {
        return nasaDataRepository.epicImageUrl(image: model)
    }

    var title: String {
        return model.caption
    }
    
    var subtitle: String {
        return model.date
    }
    
}
