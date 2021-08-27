//
//  PhotoListViewModel.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//

import UIKit

protocol PhotoListViewModelInput {
    func viewDidLoad()
    func viewDidAppear()
}

protocol PhotoListViewModelOutput {
    var headerImageUrl : Observable<URL?> { get }
    var cellViewModels : Observable<[PhotoCellViewModel]> { get }
}

protocol PhotoListViewModelInterface : PhotoListViewModelInput, PhotoListViewModelOutput {}

final class PhotoListViewModel : PhotoListViewModelInterface {
    
    private let nasaDataRepository: NasaDataRepositoryInterface!
    
    private var apodDataTask : Cancellable?
    private var epicImagesDataTask : Cancellable?
    private var epicImages : [EpicImage] = []

    init(nasaDataRepository: NasaDataRepositoryInterface){
        self.nasaDataRepository = nasaDataRepository
    }
    
    //MARK: Input
    
    func viewDidLoad() {}
    
    func viewDidAppear() {
        fetchApod()
        fetchEpicImages()
    }
    
    //MARK: Output
    let headerImageUrl : Observable<URL?> = Observable(nil)
    let cellViewModels : Observable<[PhotoCellViewModel]> = Observable([])


}


//MARK: API request

extension PhotoListViewModel {
    
    private func fetchApod() {
        
        apodDataTask?.cancel()
        
        apodDataTask = nasaDataRepository.fetchApod() { [weak self] result in
            
            defer {
                self?.apodDataTask = nil
            }
            
            switch result {
            case .success(let response):
                self?.processApodSuccessResponse(response: response)
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func processApodSuccessResponse(response: Apod) {
        if let url = URL(string: response.url) {
            self.headerImageUrl.value = url
        }
    }
    
    private func fetchEpicImages() {
        
        epicImagesDataTask?.cancel()

        epicImagesDataTask = nasaDataRepository.fetchEpicImages() { [weak self] result in
            
            defer {
                self?.epicImagesDataTask = nil
            }
            
            switch result {
            case .success(let response):
                print(response)
                self?.processEpicImagesSuccessResponse(response: response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func processEpicImagesSuccessResponse(response: [EpicImage]) {
        self.epicImages = response
        self.cellViewModels.value = response.map({ PhotoCellViewModel(model: $0) })
    }
    
    
}
