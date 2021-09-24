//
//  PhotoListViewControllerTests.swift
//  NasaTestAppTests
//
//  Created by Serhii Sachuk on 21.09.2021.
//

import XCTest
@testable import NasaTestApp


class PhotoListViewControllerTests: XCTestCase {
    
    var sut : PhotoListViewController!
    var viewModel : PhotoListViewModelInterface!

    override func setUpWithError() throws {
        super.setUp()
        let diContainer = AppDIContainer().makeHomeDIContainer()
        let viewModel = MockPhotoListViewModel()
        sut = PhotoListViewController.create(with: viewModel, viewControllersFactory: diContainer)
        self.viewModel = viewModel
    }

    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        super.tearDown()
    }

    func test_viewDidAppear() throws {
        sut.viewDidAppear(true)
        XCTAssertTrue(viewModel.isLoading.value)
    }

    func test_isLoading() throws {
        viewModel.isLoading.value = false
        XCTAssertFalse(viewModel.isLoading.value)
    }
    
    func test_error() throws {
        let error = "Some error"
        viewModel.errorText.value = error
    }
    
    func test_error_empty() throws {
        let error = ""
        viewModel.errorText.value = error
    }
    
}


class MockPhotoListViewModel : PhotoListViewModelInterface {
    
    func viewDidAppear() {
        isLoading.value = true
    }
    
    let isLoading: Observable<Bool> = Observable(false)
    let errorText: Observable<String> = Observable("")
    let headerImageUrl: Observable<URL?> = Observable(nil)
    let cellViewModels: Observable<[PhotoCellViewModel]> = Observable([])
    
}
