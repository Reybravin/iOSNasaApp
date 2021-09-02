//
//  Alertable.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 02.09.2021.
//

import UIKit

public protocol Alertable {}

public extension Alertable where Self: UIViewController {
    
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, actionHandler: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: actionHandler))
        self.present(alert, animated: true, completion: completion)
    }
}


public protocol Asyncable {}

public extension Asyncable where Self: UIViewController {
    
    func showActivityIndicator(onView view : UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 50.0),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50.0),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0)
        ])
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    func hideActivityIndicator(_ activityIndicator: inout UIActivityIndicatorView?) {
        if activityIndicator != nil {
            activityIndicator?.stopAnimating()
            activityIndicator = nil
        }
    }
    
}
