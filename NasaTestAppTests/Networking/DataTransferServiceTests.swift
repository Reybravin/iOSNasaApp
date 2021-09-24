//
//  DataTransferServiceTests.swift
//  NasaTestAppTests
//
//  Created by Serhii Sachuk on 21.09.2021.
//

import XCTest
@testable import NasaTestApp

class DataTransferServiceTests: XCTestCase {

    var sut : DataTransferService!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = AppDIContainer().nasaApiDataTransferService
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testExample() throws {
        let endpoint = APIEndpoints.apod()
        let completion : ((Result<Decodable, Error>) -> Void) = { result in }
        //let result = sut.request(with: endpoint, completion: completion)
    }

}

