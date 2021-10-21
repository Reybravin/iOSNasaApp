//
//  PhotoListViewModel.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 26.08.2021.
//

import UIKit
import Combine

protocol PhotoListViewModelInput {
    func viewDidAppear()
}

protocol PhotoListViewModelOutput {
    var isLoading : Observable<Bool> { get }
    var errorText : Observable<String> { get }
    //var headerImageUrl : Observable<URL?> { get }
    var cellViewModels : Observable<[PhotoCellViewModel]> { get }
    var headerImageUrlPublisher: Published<URL?>.Publisher { get }
}

protocol PhotoListViewModelInterface : PhotoListViewModelInput, PhotoListViewModelOutput {}

final class PhotoListViewModel : PhotoListViewModelInterface {
    
    private let nasaDataRepository: NasaDataRepositoryInterface!
    
    private var apodDataTask : Cancellable?
    private var epicImagesDataTask : Cancellable?
    private var epicImages : [EpicImage] = []

    @Published var headerImageUrl : URL? = nil
    var headerImageUrlPublisher: Published<URL?>.Publisher { $headerImageUrl }
    
    init(nasaDataRepository: NasaDataRepositoryInterface){
        self.nasaDataRepository = nasaDataRepository
    }
    
    //MARK: Input
        
    func viewDidAppear() {
        fetchApod()
        fetchEpicImages()
    }
    
    //MARK: Output
    
    //let headerImageUrl : Observable<URL?> = Observable(nil)
    let cellViewModels : Observable<[PhotoCellViewModel]> = Observable([])
    let isLoading : Observable<Bool> = Observable(false)
    let errorText : Observable<String> = Observable("")

}


//MARK: API request

extension PhotoListViewModel {
    
    private func fetchApod() {
        
        isLoading.value = true
        
        apodDataTask?.cancel()
        
        apodDataTask = nasaDataRepository.fetchApod() { [weak self] result in
            
            defer {
                self?.isLoading.value = false
                self?.apodDataTask = nil
            }
            
            switch result {
            case .success(let response):
                self?.processApodSuccessResponse(response: response)
            case .failure(let error):
                self?.errorText.value = error.localizedDescription
            }
        }
    }

    private func processApodSuccessResponse(response: Apod) {
        if let url = URL(string: response.url) {
            self.headerImageUrl = url
        }
    }
    
    private func fetchEpicImages() {
        
        isLoading.value = true
        
        epicImagesDataTask?.cancel()

        epicImagesDataTask = nasaDataRepository.fetchEpicImages() { [weak self] result in
            
            defer {
                self?.epicImagesDataTask = nil
                self?.isLoading.value = false
            }
            
            switch result {
            case .success(let response):
                self?.processEpicImagesSuccessResponse(response: response)
            case .failure(let error):
                self?.errorText.value = error.localizedDescription
            }
        }
    }
    
    private func processEpicImagesSuccessResponse(response: [EpicImage]) {
        self.epicImages = response
        self.cellViewModels.value = response.map({ PhotoCellViewModel(model: $0, nasaDataRepository: nasaDataRepository) })
    }
    
    
}
