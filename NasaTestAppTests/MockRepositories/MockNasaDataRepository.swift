//
//  MockNasaDataRepository.swift
//  NasaTestAppTests
//
//  Created by Serhii Sachuk on 20.09.2021.
//

import Foundation
@testable import NasaTestApp

protocol NasaDataRepositoryFailingInterface {}

class MockNasaDataRepository : NasaDataRepositoryInterface {
    
    var isFetchApodRequestCalled : Bool = false
    var completeApodClosure: ((Result<Apod, Error>) -> Void)!
    
    var isFetchEpicaImagesRequestCalled : Bool = false
    var completeEpicImagesClosure: ((Result<[EpicImage], Error>) -> Void)!

    //MARK: Public API methods
    
    func fetchApod(completion: @escaping (Result<Apod, Error>) -> Void) -> Cancellable? {
        isFetchApodRequestCalled = true
        completeApodClosure = completion
        return nil
    }
    
    func fetchEpicImages(completion: @escaping (Result<[EpicImage], Error>) -> Void) -> Cancellable? {
        isFetchEpicaImagesRequestCalled = true
        completeEpicImagesClosure = completion
        return nil
    }
    
    //MARK:
    
    func fetchApodSuccess(){
        let apod = Apod(copyright: "", date: "", explanation: "", mediaType: "", serviceVersion: "", thumbnailUrl: "", title: "", url: "https://apple.com")
        completeApodClosure(.success(apod))
    }
    
    func fetchApodFail(error : Error){
        completeApodClosure(.failure(error))
    }
    
    func fetchEpicaImagesSuccess(){
        let images : [EpicImage] = [EpicImage(image: "image", date: "date", caption: "caption")]
        completeEpicImagesClosure(.success(images))
    }
    
    func fetchEpicImagesFail(error : Error){
        completeEpicImagesClosure(.failure(error))
    }

}
