//
//  PhotoListTableHeaderViewTests.swift
//  NasaTestAppTests
//
//  Created by Serhii Sachuk on 22.09.2021.
//

import XCTest
@testable import NasaTestApp

class PhotoListTableHeaderViewTests: XCTestCase {

    var sut : PhotoListTableHeaderView!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = PhotoListTableHeaderView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 300)))
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testExample() throws {
        //
    }
    
}
