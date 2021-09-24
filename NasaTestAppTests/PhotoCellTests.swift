//
//  PhotoCellTests.swift
//  NasaTestAppTests
//
//  Created by Serhii Sachuk on 21.09.2021.
//

import XCTest
@testable import NasaTestApp

class PhotoCellTests: XCTestCase {

    var sut : PhotoCell!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = Bundle.main.loadNibNamed("PhotoCell", owner: nil, options: nil)?.first as? PhotoCell
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testExample() throws {
        let model = EpicImage(image: "image", date: "date", caption: "caption")
        let url = URL(string: "https://api.nasa.gov/EPIC/archive/natural/date/png/image.png?api_key=KK2KcxX66KsS1jjiVH7gQDdJWcBHSxyE1S93QMOL")
        let viewModel = PhotoCellViewModel(model: model)
        sut.configureView(with: viewModel)
        XCTAssertEqual(viewModel.imageUrl, url)
        XCTAssertEqual(sut.photoTitleLabel.text, viewModel.title)
        XCTAssertEqual(sut.photoSubtitleLabel.text, viewModel.subtitle)
    }

}
