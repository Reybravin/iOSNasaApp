//
//  APIEndpoints.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//

import UIKit

fileprivate let apiKey : String = "KK2KcxX66KsS1jjiVH7gQDdJWcBHSxyE1S93QMOL"

fileprivate var baseURL : String {
    return "https://api.nasa.gov"
}

fileprivate let scheme = "https"
fileprivate let host = "api.nasa.gov"
fileprivate let epic = "/EPIC/api/natural/images"


struct APIEndpoints {
    
    private enum urlEndpoint {
        
        case apod
        case epicImages
        
        var path : String {
            switch self {
            case .apod: return "planetary/apod"
            case .epicImages : return "EPIC/api/natural/images"
            }
        }
        
        var queryParameters : [String: Any] {
            switch self {
            case .apod : return ["api_key" : apiKey,
                                 "thumbs" : "\(true)"]
            case .epicImages : return ["api_key" : apiKey]
            default: return ["" : ""]
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
}
