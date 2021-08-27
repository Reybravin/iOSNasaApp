//
//  DataTransferError.swift
//  Satang Pro
//
//  Created by Sergiy Sachuk on 12.05.2020.
//  Copyright © 2020 Sergiy Sachuk. All rights reserved.
//

import Foundation

public enum DataTransferError: Error {
    case noResponse
    case notFound
    case parsing(Error)
    case code202(String)
    case conflict
    case internalServerError
    case tooManyRequests
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
    case invalidParameters(String, String)
    case invalidCredentials(String)
    case missingUserCredentials
    case invalidToken(String)
    case missingAccessToken
    case emailAlreadyConfirmed (String)
    case biometricAuthError
    case genericError400
    case error422(String)
    case userCredentialsStorageError(String)

    var code : String {
        switch self {
        case .invalidParameters(let code, let message):
            if code.isEmpty {
                return "Error"
            } else {
                return code
            }
        default: return "Error"
        }
    }
    
    var message : String {
        switch self {
        case .notFound: return NSLocalizedString("404. Not found", comment: "")
        case .noResponse: return NSLocalizedString("No response", comment: "")
        case .parsing(_): return NSLocalizedString("Parsing error", comment: "")
        case .networkFailure(let err): return getNetworkFailureErrorDescription(err: err)
        case .resolvedNetworkFailure(_): return NSLocalizedString("Resolved Network Failure", comment: "")
        case .invalidParameters(let code, let message): return message
        case .invalidCredentials(let message): return message
        case .invalidToken(let message): return message
        case .emailAlreadyConfirmed(let message): return message
        case .conflict: return NSLocalizedString("Conflict", comment: "")
        case .internalServerError : return NSLocalizedString("Status Code 500. Internal Server Error", comment: "")
        case .biometricAuthError: return "Biometric auth error."
        case .genericError400: return NSLocalizedString("Error 400", comment: "")
        case .tooManyRequests: return NSLocalizedString("Too Many Requests", comment: "")
        case .missingAccessToken: return NSLocalizedString("Missing Accesss Token. Please sign out and sing in again.", comment: "")
        case .missingUserCredentials: return NSLocalizedString("Missing User Credentials. Please sign out and sing in again.", comment: "")
        case .code202(let message): return message
        case .error422(let message): return message
        case .userCredentialsStorageError(let message): return message
        }
    }
    
    private func getNetworkFailureErrorDescription(err: NetworkError) -> String {
        let underlyingError = err.underlyingError
        let result = "\((underlyingError as NSError).domain): \((underlyingError as NSError).code). \(underlyingError.localizedDescription)"
        return result
    }
    
    static var invalidTokenMessage : String {
        return "Invalid token"
    }
}

struct DataTransferErrorMapper {
    
    static func map(error: NetworkError) -> DataTransferError {
        switch error {
        case .error(let statusCode, let data):
            switch statusCode {
            case HTTPStatusCode.code400:
                if let data = data {
                    if let dataString = String(data: data, encoding: .utf8) {
                        debugPrint(dataString as Any)
                        return .invalidParameters("", dataString)
                    }
                } else {
                    return .genericError400 }
            case HTTPStatusCode.code401:
                if let data = data {
                    if let dataString = String(data: data, encoding: .utf8) {
                        return .invalidCredentials("Code 401." + dataString)
                    }
                }
                return .invalidCredentials("Code 401. Unknown error")

            case HTTPStatusCode.code422:
                if let data = data {
                    if let dataString = String(data: data, encoding: .utf8) {
                        return .error422("Code 422." + dataString)
                    }
                }
                return .error422("Code 422. Unknown error")
            case HTTPStatusCode.code404: return .notFound
            case HTTPStatusCode.code409:
                if let data = data {
                    if let dataString = String(data: data, encoding: .utf8) {
                        debugPrint(dataString as Any)
                        return .invalidParameters("Code 409", dataString)
                    }
                    return .invalidParameters("Code 409", "Unknown error")
                } else {
                    return .conflict
                }
            case HTTPStatusCode.code500 : return .internalServerError
            case HTTPStatusCode.code429: return .tooManyRequests
            default: break
            }
        default: break
        }
        return .networkFailure(error)
    }
    
}


extension Error {
    
    public var isAuthError : Bool {
        if let err = self as? DataTransferError {
            if case .invalidCredentials = err {
                return true
            }
        }
        return false
    }
    
}
