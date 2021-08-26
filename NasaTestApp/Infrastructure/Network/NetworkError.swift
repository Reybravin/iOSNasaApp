//
//  NetworkError.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//

import Foundation

enum NetworkError : Error {
    case notHTTPResponse
    case serverResponse(Int)
}
