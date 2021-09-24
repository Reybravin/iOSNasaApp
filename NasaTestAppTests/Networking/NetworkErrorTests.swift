//
//  NetworkErrorTests.swift
//  NasaTestAppTests
//
//  Created by Serhii Sachuk on 21.09.2021.
//

import XCTest
@testable import NasaTestApp

class NetworkErrorTests: XCTestCase {
    
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_generic() throws {
        let error = NSError(domain: "", code: 500, userInfo: nil)
        let sut = NetworkError.generic(error)
        XCTAssertEqual(sut.underlyingError.localizedDescription, error.localizedDescription)
    }
    
    func test_cancelled() throws {
        let error = NSError(domain: "", code: 600, userInfo: nil)
        let sut = NetworkError.cancelled(error)
        XCTAssertEqual(sut.underlyingError.localizedDescription, error.localizedDescription)
    }

    func test_notConnected() throws {
        let error = NSError(domain: "", code: 700, userInfo: nil)
        let sut = NetworkError.notConnected(error)
        XCTAssertEqual(sut.underlyingError.localizedDescription, error.localizedDescription)
    }
    
    func test_urlGeneration() throws {
        let error = NSError(domain: "", code: 800, userInfo: nil)
        let sut = NetworkError.urlGeneration(error)
        XCTAssertEqual(sut.underlyingError.localizedDescription, error.localizedDescription)
    }
    
    func test_error_noData() throws {
        let error = NSError(domain: "NetworkError", code: 900, userInfo: nil)
        let sut = NetworkError.error(statusCode: 900, data: nil)
        XCTAssertEqual(sut.underlyingError.localizedDescription, error.localizedDescription)
    }
    
    func test_error_withData() throws {
        let data = "some data".data(using: .utf8)!
        let dataString = String(data: data, encoding: .utf8)!
        let error = NSError(domain: "NetworkError", code: 1000, userInfo: ["errorKey" : dataString])
        let sut = NetworkError.error(statusCode: 1000, data: data)
        XCTAssertEqual(sut.underlyingError.localizedDescription, error.localizedDescription)
    }

}
