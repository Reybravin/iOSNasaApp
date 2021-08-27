//
//  ConnectionError.swift
//  Satang Pro
//
//  Created by Sergiy Sachuk on 12.05.2020.
//  Copyright © 2020 Sergiy Sachuk. All rights reserved.
//

import Foundation

public protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

public extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }

    var isNetworkError : Bool {
        if let error = self as? DataTransferError {
            if case .networkFailure(_) = error {
                    return true
            }
        }
        return false
    }
    
}
