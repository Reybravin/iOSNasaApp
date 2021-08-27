//
//  PhotoCellViewModel.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 27.08.2021.
//

import UIKit

final class PhotoCellViewModel {
    
    let model : PhotoItem
    
    init(model: PhotoItem) {
        self.model = model
    }
    
}

struct PhotoItem {
    let image       : UIImage?
    let title       : String
    let subtitle    : String
}
