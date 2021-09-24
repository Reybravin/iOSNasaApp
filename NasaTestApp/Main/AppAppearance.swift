//
//  AppAppearance.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 27.08.2021.
//

import UIKit

final class AppAppearance {
    
    static func setupAppearance(window: UIWindow?) {
        
        UITabBar.appearance().tintColor = .systemBlue
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().barTintColor = .systemBlue
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

    }
}

extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
