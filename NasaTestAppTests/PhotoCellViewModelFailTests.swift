//
//  PhotoCellViewModelFailTests.swift
//  NasaTestAppTests
//
//  Created by Serhii Sachuk on 21.09.2021.
//

import XCTest
@testable import NasaTestApp


class PhotoCellViewModelFailTests: XCTestCase {
    
    var sut : PhotoCellViewModel!

    override func setUpWithError() throws {
        super.setUp()
        let model = EpicImage(image: "", date: "", caption: "caption")
        sut = PhotoCellViewModel(model: model)
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func test_imageUrl_fail() throws {
        XCTAssertEqual(sut.imageUrl, nil)
    }

}
