//
//  AppDIContainer.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//

import UIKit


final class AppDIContainer {
    
    lazy var appConfigurations = AppConfiguration()
    
    // MARK: - Network
    
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfigurations.apiBaseURL)!)
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    lazy var nasaDataRepository : NasaDataRepositoryInterface = {
        return NasaDataRepository(dataTransferService: apiDataTransferService)
    }()
    

    // DIContainers of scenes
    
    func makeHomeDIContainer() -> HomeDIContainer {
        let dependencies = HomeDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            nasaDataRepository: nasaDataRepository)
        return HomeDIContainer(dependencies: dependencies)
    }
}
