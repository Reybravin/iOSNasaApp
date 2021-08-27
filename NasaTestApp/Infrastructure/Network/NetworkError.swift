//
//  NetworkError.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected(Error)
    case cancelled(Error)
    case generic(Error)
    case urlGeneration(Error)
    
    var underlyingError : Error {
        switch self {
        case .notConnected(let error): return error
        case .cancelled(let error): return error
        case .generic(let error): return error
        case .urlGeneration(let error) : return error
        case .error(statusCode: let code, data: let data):
            if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    return NSError(domain: "NetworkError", code: code, userInfo: ["errorKey" : dataString])
                }
            }
            return NSError(domain: "NetworkError", code: code, userInfo: nil)
        }
    }
}
