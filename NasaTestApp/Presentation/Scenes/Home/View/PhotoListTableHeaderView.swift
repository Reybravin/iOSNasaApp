//
//  PhotoListTableHeaderView.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 27.08.2021.
//

import UIKit

class PhotoListTableHeaderView : UIView {
    
    private var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let imageView = UIImageView(frame: self.frame)
        self.addSubview(imageView)
        self.imageView = imageView
    }
    
    func setImage(withUrl url: URL) {
        imageView?.setImage(with: url)
    }
}

    
