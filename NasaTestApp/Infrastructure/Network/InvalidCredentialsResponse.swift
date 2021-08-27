//
//  InvalidCredentialsResponse.swift
//  Satang Pro
//
//  Created by Sergiy Sachuk on 11.05.2020.
//  Copyright © 2020 Sergiy Sachuk. All rights reserved.
//

import Foundation

struct InvalidCredentialsResponse : Decodable {
    let status: String
    let message : String
}
