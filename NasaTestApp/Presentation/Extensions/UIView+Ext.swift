//
//  UIView+Ext.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 25.07.2021.
//


import UIKit

public extension UIView {
    
    func pinToEdges(view: UIView, padding : CGFloat = 0){
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    func pinToEdges(view: UIView, leading : CGFloat = 0, trailing : CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailing)
        ])
    }
    
    func pinToSafeArea(view: UIView, padding : CGFloat = 0){
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        ])
    }
    
}
