//
//  PhotoCellViewModel.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 27.08.2021.
//

import UIKit

final class PhotoCellViewModel {
    
    private let model : EpicImage
    private let scheme = "https"
    private let host = "api.nasa.gov"
    private let apiKey : String = "KK2KcxX66KsS1jjiVH7gQDdJWcBHSxyE1S93QMOL"
    
    init(model: EpicImage) {
        self.model = model
        //self.apiKey = apiKey
    }
    
    var imageUrl : URL {
        let basePath = "/EPIC/archive/natural/"
        guard let datePath = (model.date.split(separator: " ").first)?.replacingOccurrences(of: "-", with: "/") else { return URL(string: "")! }
        let fileExtPath = "/png/"
        let fileName = model.image + ".png"
        let path = basePath + datePath + fileExtPath + fileName
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        if let url = urlComponents.url {
            return url
        } else {
            return URL(string: "")!
        }
    }

    var title: String {
        return model.caption
    }
    
    var subtitle: String {
        return model.date
    }
    
}

//struct PhotoItem {
//    let image       : UIImage?
//    let title       : String
//    let subtitle    : String
//}
