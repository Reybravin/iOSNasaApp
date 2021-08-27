//
//  HomeDIContainer.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//


import UIKit

final class HomeDIContainer {
    
    private let dependencies: Dependencies
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let nasaDataRepository: NasaDataRepositoryInterface
    }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeHomeViewController() -> UIViewController {
        return PhotoListViewController.create(with: makeHomeViewModel(),
                                              viewControllersFactory: self)
    }
    
    func makeHomeViewModel() -> PhotoListViewModelInterface {
        return PhotoListViewModel(nasaDataRepository: dependencies.nasaDataRepository)
    }
    
}


extension HomeDIContainer : HomeViewControllersFactory {
    
    func makeDetailViewController() -> UIViewController {
        let vc = UIViewController()
        return vc
    }

}

protocol HomeViewControllersFactory {
    func makeDetailViewController() -> UIViewController
}
