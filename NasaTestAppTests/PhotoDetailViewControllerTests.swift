//
//  PhotoDetailViewControllerTests.swift
//  NasaTestAppTests
//
//  Created by Serhii Sachuk on 21.09.2021.
//

import XCTest
@testable import NasaTestApp

class PhotoDetailViewControllerTests: XCTestCase {

    var sut : PhotoDetailViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = PhotoDetailViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testExample() throws {
        sut.viewDidLoad()
    }


}
