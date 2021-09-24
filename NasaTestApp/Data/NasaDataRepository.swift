//
//  NasaDataRepository.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 25.08.2021.
//

import Foundation

protocol NasaDataRepositoryInterface {
    
    @discardableResult
    func fetchApod(completion: @escaping (Result<Apod, Error>) -> Void) -> Cancellable?
    
    @discardableResult
    func fetchEpicImages(completion: @escaping (Result<[EpicImage], Error>) -> Void) -> Cancellable?
    
    func epicImageUrl(image : EpicImage) -> URL?
    
}

final class NasaDataRepository : NasaDataRepositoryInterface {
    
    private let dataTransferService: DataTransferService
    
    private typealias apiEndpoints = APIEndpoints
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    private let defaultSession = URLSession(configuration: .default)
    
    private var errorMessage : String = ""
    private var tracks = ""
    
}

extension NasaDataRepository {
    
    func fetchApod(completion: @escaping (Result<Apod, Error>) -> Void) -> Cancellable? {
        let endpoint = apiEndpoints.apod()
        let networkTask = self.dataTransferService.request(with: endpoint, completion: completion)
        return RepositoryTask(networkTask: networkTask)
    }
    
    func fetchEpicImages(completion : @escaping (Result<[EpicImage], Error>) -> Void) -> Cancellable? {
        let endpoint = apiEndpoints.epicImages()
        let networkTask = self.dataTransferService.request(with: endpoint, completion: completion)
        return RepositoryTask(networkTask: networkTask)
    }
        
    func epicImageUrl(image: EpicImage) -> URL? {
        let endpoint = apiEndpoints.epicImageUrl(image: image)
        let url = self.dataTransferService.url(endPoint: endpoint)
        return url
    }

}
