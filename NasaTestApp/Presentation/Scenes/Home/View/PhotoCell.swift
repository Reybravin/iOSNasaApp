//
//  PhotoCell.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 27.08.2021.
//

import UIKit

class PhotoCell: UITableViewCell {

    private var viewModel: PhotoCellViewModel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var photoSubtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureView(with viewModel: PhotoCellViewModel) {
        self.viewModel = viewModel
        if let imageUrl = viewModel.imageUrl {
            self.photoImageView?.setImage(with: imageUrl)
        }
        self.photoTitleLabel?.text = viewModel.title
        self.photoSubtitleLabel?.text = viewModel.subtitle
    }
    
}
