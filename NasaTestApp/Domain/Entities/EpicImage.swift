//
//  EpicImagesResponse.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 25.08.2021.
//

import Foundation

struct EpicImage : Decodable {
    let image : String
    let date : String
    let caption : String
}
