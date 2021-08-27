//
//  NetworkErrorLogger.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//

import Foundation

public protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}
