//
//  APIEndpoints.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//

import UIKit


fileprivate let API_KEY : String = "KK2KcxX66KsS1jjiVH7gQDdJWcBHSxyE1S93QMOL"
//fileprivate let SCHEME = "https"
//fileprivate let HOST = "api.nasa.gov"
fileprivate let APOD_PATH = "planetary/apod"
fileprivate let EPIC_PATH = "EPIC/api/natural/images"
fileprivate let EPIC_IMAGE_PATH = "EPIC/archive/natural/"


struct APIEndpoints {
    
    private enum urlEndpoint {
        
        case apod
        case epicImages
        case epicImageUrl(EpicImage)
        
        var path : String {
            switch self {
            case .apod: return APOD_PATH
            case .epicImages : return EPIC_PATH
            case .epicImageUrl(let model):
                guard let datePath = (model.date.split(separator: " ").first)?.replacingOccurrences(of: "-", with: "/") else {
                    return ""
                }
                
                let basePath = EPIC_IMAGE_PATH
                let fileExtPath = "/png/"
                let fileName = model.image + ".png"
                let path = basePath + datePath + fileExtPath + fileName
                return path
            }
        }
        
        var queryParameters : [String: Any] {
            switch self {
            case .apod : return ["api_key" : API_KEY,
                                 "thumbs" : "\(true)"]
            case .epicImages :  return ["api_key" : API_KEY]
            case .epicImageUrl(_) : return ["api_key" : API_KEY]
            }
        }
        
        var bodyParameters: [String: Any] {
            switch self {
            default: return [:]
            }
        }
    
    }
    
    func headerParameters(accessToken : String? = nil) -> [String : String] {
        var headers : [String : String] = [:]
        headers[HeaderParameters.contentType.field] = HeaderParameters.contentType.value
        return headers
    }
    
    //MARK: ENDPOINTS
  
    static func apod() -> Endpoint<Apod> {
        let urlEndpoint = urlEndpoint.apod
        return Endpoint(path: urlEndpoint.path,
                        method: .get,
                        queryParameters: urlEndpoint.queryParameters,
                        responseDecoder: JSONResponseDecoder())
    }
    
    static func epicImages() -> Endpoint<[EpicImage]> {
        let urlEndpoint = urlEndpoint.epicImages
        return Endpoint(path: urlEndpoint.path,
                        method: .get,
                        queryParameters: urlEndpoint.queryParameters,
                        responseDecoder: JSONResponseDecoder())
    }
    
    //MARK: Images Downloading URL
    
//    static func epicImageUrl(image: EpicImage) -> URL? {
//
//        guard let datePath = (image.date.split(separator: " ").first)?.replacingOccurrences(of: "-", with: "/") else {
//            return nil
//        }
//
//        let basePath = "/" + EPIC_IMAGE_PATH
//        let fileExtPath = "/png/"
//        let fileName = image.image + ".png"
//        let path = basePath + datePath + fileExtPath + fileName
//
//        var urlComponents = URLComponents()
//        urlComponents.scheme = SCHEME
//        urlComponents.host = HOST
//        urlComponents.path = path
//        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: API_KEY)]
//
//        return urlComponents.url
//
//    }
    
    static func epicImageUrl(image: EpicImage) -> Endpoint<Void> {
        let urlEndpoint = urlEndpoint.epicImageUrl(image)
        return Endpoint(path: urlEndpoint.path,
                        queryParameters: urlEndpoint.queryParameters)
    }
    
}
