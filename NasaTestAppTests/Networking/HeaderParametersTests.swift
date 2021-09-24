//
//  HeaderParametersTests.swift
//  NasaTestAppTests
//
//  Created by Serhii Sachuk on 21.09.2021.
//

import XCTest
@testable import NasaTestApp

class HeaderParametersTests: XCTestCase {
    
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func test_contentType() throws {
        let sut = HeaderParameters.contentType
        let field = "content-type"
        XCTAssertEqual(sut.field, field)
    }
    
    func test_authorization() throws {
        let sut = HeaderParameters.authorization
        let field = "authorization"
        XCTAssertEqual(sut.field, field)
    }
    
    func test_userAgent() throws {
        let sut = HeaderParameters.userAgent
        let field = "User-Agent"
        XCTAssertEqual(sut.field, field)
    }
    
    func test_operationSystemVersion() throws {
        let sut = HeaderParameters.operationSystemVersion
        let field = "X-CLIENT-VERSION"
        XCTAssertEqual(sut.field, field)
    }
    
    func test_source() throws {
        let sut = HeaderParameters.source
        let field = "X-CLIENT-SOURCE"
        XCTAssertEqual(sut.field, field)
    }
    
    func test_value() throws {
        let sut = HeaderParameters.contentType
        let value = "application/json"
        XCTAssertEqual(sut.value, value)
    }
    
    func test_default_value() throws {
        let sut = HeaderParameters.authorization
        let value = ""
        XCTAssertEqual(sut.value, value)
    }

}
