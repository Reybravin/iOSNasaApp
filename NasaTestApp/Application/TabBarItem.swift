//
//  TabBarItem.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//


import UIKit

enum TabBarItem {
    case home
    case second
    
    var title : String {
        switch self {
        case .home: return "Home"
        case .second : return "Second"
        }
    }
    
    var itemType : UITabBarItem.SystemItem {
        switch self {
        case .home:
            return .bookmarks
        case .second:
            return .favorites
        }
    }
    
    var tag : Int {
        switch self {
        case .home: return 0
        case .second: return 1
        }
    }
}

