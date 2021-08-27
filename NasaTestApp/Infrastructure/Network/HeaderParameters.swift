//
//  HeaderParameters.swift
//  Satang Pro
//
//  Created by Sergiy Sachuk on 13.05.2020.
//  Copyright © 2020 Sergiy Sachuk. All rights reserved.
//

import Foundation

enum HeaderParameters {
    
    case contentType
    case authorization
    case userAgent
    case operationSystemVersion
    case source
    
    var field : String {
        switch self {
        case .contentType: return "content-type"
        case .authorization: return "authorization"
        case .userAgent : return "User-Agent"
        case .operationSystemVersion : return "X-CLIENT-VERSION"
        case .source: return "X-CLIENT-SOURCE"
        }
    }
    
    var value: String {
        switch self {
        case .contentType: return "application/json"
        default: return ""
        }
    }
   
}
