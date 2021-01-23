//
//  DataLoaderTests.swift
//  SupplierGoKitTests
//
//  Created by Alessandro Toschi on 23/01/2021.
//

import XCTest
@testable import SupplierGoKit

struct NonHTTPMockLoader: Loadable{
    static func load(fromURL url: URL, completionHandler: @escaping CompletionHandler) {
        completionHandler(nil, .NonHTTPResponse)
        return
    }
}

struct StatusCodeKO: Loadable{
    static func load(fromURL url: URL, completionHandler: @escaping CompletionHandler) {
        completionHandler(nil, .HTTPRStatusCodeKO)
        return
    }
}

class DataLoaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInvalidURL() throws{
        let exp = expectation(description: "Waiting for error closure")
        guard let emptyURL = URL(string: "hfghfghgfh")else{
            XCTFail()
            return
        }
        DataLoader.load(fromURL: emptyURL) { (data, error) in
            guard let error = error else{
                XCTFail("There should be an error")
                exp.fulfill()
                return
            }
            switch error{
            case .genericError(_):
                XCTAssertTrue(true)
            default:
                XCTFail()
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            if error != nil{
                XCTFail("Expectation failed")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    
    
    func testNoHTTP() throws{
        let exp = expectation(description: "Waiting for error closure")
        guard let emptyURL = URL(string: "sftp://ciao.prova")else{
            XCTFail()
            return
        }
        NonHTTPMockLoader.load(fromURL: emptyURL) { (data, error) in
            guard let error = error else{
                XCTFail("There should be an error")
                exp.fulfill()
                return
            }
            switch error{
            case .NonHTTPResponse:
                XCTAssertTrue(true)
            default:
                XCTFail()
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            if error != nil{
                XCTFail("Expectation failed")
                return
            }
            XCTAssertTrue(true)
        }
    }

    func testStatusCodeKO() throws{
        let exp = expectation(description: "Waiting for error closure")
        guard let emptyURL = URL(string: "sftp://ciao.prova")else{
            XCTFail()
            return
        }
        StatusCodeKO.load(fromURL: emptyURL) { (data, error) in
            guard let error = error else{
                XCTFail("There should be an error")
                exp.fulfill()
                return
            }
            switch error{
            case .HTTPRStatusCodeKO:
                XCTAssertTrue(true)
            default:
                XCTFail()
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            if error != nil{
                XCTFail("Expectation failed")
                return
            }
            XCTAssertTrue(true)
        }
    }
}
