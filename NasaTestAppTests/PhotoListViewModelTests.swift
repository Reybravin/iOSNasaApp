//
//  PhotoListViewModelTests.swift
//  NasaTestAppTests
//
//  Created by Serhii Sachuk on 20.09.2021.
//

import XCTest
@testable import NasaTestApp

class PhotoListViewModelTests: XCTestCase {

    var sut : PhotoListViewModelInterface!
    var mockDataRepository : MockNasaDataRepository!
    
    override func setUpWithError() throws {
        super.setUp()
        mockDataRepository = MockNasaDataRepository()
        sut = PhotoListViewModel(nasaDataRepository: mockDataRepository)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockDataRepository = nil
        super.tearDown()
    }

    func test_fetch_apod() throws {
        sut.viewDidAppear()
        XCTAssertTrue(mockDataRepository.isFetchApodRequestCalled)
    }
    
    func test_fetch_apod_success() throws {
        let url = URL(string: "https://apple.com")!
        sut.viewDidAppear()
        mockDataRepository.fetchApodSuccess()
        XCTAssertEqual(sut.headerImageUrl.value, url)
    }
    
    func test_fetch_apod_fail() throws {
        let error = NSError.init(domain: "", code: 500, userInfo: nil)
        sut.viewDidAppear()
        mockDataRepository.fetchApodFail(error: error)
        XCTAssertEqual(sut.errorText.value, error.localizedDescription)
    }

    func test_fetch_epicImages_success() throws {
        let model = EpicImage(image: "image", date: "data", caption: "caption")
        let vm = [PhotoCellViewModel(model: model)]
        sut.viewDidAppear()
        mockDataRepository.fetchEpicaImagesSuccess()
        XCTAssertEqual(sut.cellViewModels.value.first?.title, vm.first?.title)
    }
    
    func test_fetch_epicaImages_fail() throws {
        let error = NSError.init(domain: "", code: 600, userInfo: nil)
        sut.viewDidAppear()
        mockDataRepository.fetchEpicImagesFail(error: error)
        XCTAssertEqual(sut.errorText.value, error.localizedDescription)
    }

}
