//
//  PhotoCellViewModelTests.swift
//  NasaTestAppTests
//
//  Created by Serhii Sachuk on 21.09.2021.
//

import XCTest
@testable import NasaTestApp

class PhotoCellViewModelTests: XCTestCase {

    var sut : PhotoCellViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let model = EpicImage(image: "image", date: "date", caption: "caption")
        sut = PhotoCellViewModel(model: model)
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func test_title() throws {
        let title = "caption"
        XCTAssertEqual(sut.title, title)
    }
    
    func test_subtitle() throws {
        let date = "date"
        XCTAssertEqual(sut.subtitle, date)
    }
    
    func test_imageUrl() throws {
        let imageUrl = URL(string: "https://api.nasa.gov/EPIC/archive/natural/date/png/image.png?api_key=KK2KcxX66KsS1jjiVH7gQDdJWcBHSxyE1S93QMOL")!
        XCTAssertEqual(sut.imageUrl, imageUrl)
    }

}
