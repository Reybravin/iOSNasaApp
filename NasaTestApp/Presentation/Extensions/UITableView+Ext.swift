//
//  UITableView+Ext.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 25.07.2021.
//

import UIKit

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

internal extension UITableView {
    
    func registerNib<T: UITableViewCell>(cellClass: T.Type) {
        let reuseIdentifier = String(describing: cellClass)
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(cellClass: T.Type) {
        let reuseIdentifier = String(describing: cellClass)
        register(cellClass, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueReusableCell<T>(indexPath: IndexPath) -> T where T: UITableViewCell {
        let reuseIdentifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T
            else {
                fatalError("\(reuseIdentifier) can't find")
        }
        return cell
    }
    
}

import UIKit

protocol NibInstantiatable {
    static var nib: UINib { get }
    static var nibName: String { get }

    static func instanstiateFromNib() -> Self
}

extension NibInstantiatable {

    static var nibName: String {
        return String(describing: Self.self)
    }

    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }

    static func instanstiateFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Could not instanstiate view \(nibName) from nib")
        }

        return view
    }
}
