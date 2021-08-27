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
        imageView.backgroundColor = .red
        self.addSubview(imageView)
        self.imageView = imageView
        //let button = UIButton(frame: CGRect(x: 15, y: 15, width: 50, height: 30))
        //button.setImage(UIImage(), for: .normal)
        //button.setTitleColor(.black, for: .normal)
        //button.titleLabel?.font = DefaultStyle.Fonts.customFont(type: .ttiMedium, size: 16)
        //button.titleLabel?.textAlignment = .left
        //button.contentHorizontalAlignment = .left
        //button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        //headerView.addSubview(button)
    }
    
    func setImage(withUrl url: URL) {
        imageView?.setImage(with: url)
    }
}

    
