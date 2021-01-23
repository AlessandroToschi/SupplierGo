//
//  SupplierGoKitTests.swift
//  SupplierGoKitTests
//
//  Created by Alessandro Toschi on 23/01/2021.
//

import XCTest
@testable import SupplierGoKit

class SupplierGoKitTests: XCTestCase {
    var bundle: Bundle!
    var dateFormatter: DateFormatter!
    var jsonDecoder: JSONDecoder!
    
    override func setUpWithError() throws {
        self.bundle = Bundle(for: type(of: self))
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.dateDecodingStrategy = .formatted(self.dateFormatter)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSupplierCodable() throws{
        guard let jsonUrl = self.bundle.url(forResource: "supplier", withExtension: "json") else{
            XCTFail("Cannot find the json file.")
            return
        }
        guard let jsonData = try? Data(contentsOf: jsonUrl) else{
            XCTFail("Cannot load the json file")
            return
        }
        
        guard let supplier = try? self.jsonDecoder.decode(Supplier.self, from: jsonData) else{
            XCTFail("Supplier not parsed")
            return
        }
        
        XCTAssertEqual(supplier.id, 1)
        XCTAssertEqual(supplier.fullname, "Matteo Hamill")
        XCTAssertEqual(supplier.avatar.endpoint, "https://gaiago-static-files-prod.s3-eu-west-1.amazonaws.com/statics/mockAvatar/avatar.png")
        XCTAssertEqual(supplier.phone, "1-789-686-0305")
        XCTAssertEqual(supplier.company, "Murphy, Kerluke and Swift")
        XCTAssertEqual(supplier.email, "Laurianne.Bashirian68@yahoo.com")
        XCTAssertEqual(supplier.creationDate, Date(timeIntervalSince1970: 1611220276.04))
    }
    
    func testSupplierXCodable() throws{
        guard let jsonUrl = self.bundle.url(forResource: "supplierx", withExtension: "json") else{
            XCTFail("Cannot find the json file.")
            return
        }
        guard let jsonData = try? Data(contentsOf: jsonUrl) else{
            XCTFail("Cannot load the json file")
            return
        }
        
        guard let supplier = try? self.jsonDecoder.decode(Supplier.self, from: jsonData) else{
            XCTFail("Supplier not parsed")
            return
        }
        
        XCTAssertEqual(supplier.id, 2)
        XCTAssertEqual(supplier.fullname, "Kallie Gusikowski")
        XCTAssertEqual(supplier.avatar.endpoint, "https://gaiago-static-files-prod.s3-eu-west-1.amazonaws.com/statics/mockAvatar/avatar-1.png")
        XCTAssertEqual(supplier.phone, "273.797.1657 x073")
        XCTAssertEqual(supplier.company, "Dicki, Schulist and Hauck")
        XCTAssertEqual(supplier.email, "May.Schneider@gmail.com")
        XCTAssertEqual(supplier.creationDate, Date(timeIntervalSince1970: 1611168591.479))
    }
    
    func testEmptyData() throws{
        let jsonData = Data()
        XCTAssertThrowsError(try self.jsonDecoder.decode(Supplier.self, from: jsonData))
    }
    
    func testMissingField() throws{
        guard let jsonUrl = self.bundle.url(forResource: "missingfield", withExtension: "json") else{
            XCTFail("Cannot find the json file.")
            return
        }
        guard let jsonData = try? Data(contentsOf: jsonUrl) else{
            XCTFail("Cannot load the json file")
            return
        }
        XCTAssertThrowsError(try self.jsonDecoder.decode(Supplier.self, from: jsonData))
    }
    
    func testMispelledField() throws{
        guard let jsonUrl = self.bundle.url(forResource: "mispelledfield", withExtension: "json") else{
            XCTFail("Cannot find the json file.")
            return
        }
        guard let jsonData = try? Data(contentsOf: jsonUrl) else{
            XCTFail("Cannot load the json file")
            return
        }
        XCTAssertThrowsError(try self.jsonDecoder.decode(Supplier.self, from: jsonData))
    }
    
    func testArray() throws{
        guard let jsonUrl = self.bundle.url(forResource: "array", withExtension: "json") else{
            XCTFail("Cannot find the json file.")
            return
        }
        guard let jsonData = try? Data(contentsOf: jsonUrl) else{
            XCTFail("Cannot load the json file")
            return
        }
        
        guard let supplierArray = try? self.jsonDecoder.decode([Supplier].self, from: jsonData) else{
            XCTFail()
            return
        }
        
        XCTAssertEqual(supplierArray.count, 2)
        XCTAssertEqual(supplierArray[0].id, 1)
        XCTAssertEqual(supplierArray[0].fullname, "Matteo Hamill")
        XCTAssertEqual(supplierArray[0].avatar.endpoint, "https://gaiago-static-files-prod.s3-eu-west-1.amazonaws.com/statics/mockAvatar/avatar.png")
        XCTAssertEqual(supplierArray[0].phone, "1-789-686-0305")
        XCTAssertEqual(supplierArray[0].company, "Murphy, Kerluke and Swift")
        XCTAssertEqual(supplierArray[0].email, "Laurianne.Bashirian68@yahoo.com")
        XCTAssertEqual(supplierArray[0].creationDate, Date(timeIntervalSince1970: 1611220276.04))
        
        XCTAssertEqual(supplierArray[1].id, 2)
        XCTAssertEqual(supplierArray[1].fullname, "Kallie Gusikowski")
        XCTAssertEqual(supplierArray[1].avatar.endpoint, "https://gaiago-static-files-prod.s3-eu-west-1.amazonaws.com/statics/mockAvatar/avatar-1.png")
        XCTAssertEqual(supplierArray[1].phone, "273.797.1657 x073")
        XCTAssertEqual(supplierArray[1].company, "Dicki, Schulist and Hauck")
        XCTAssertEqual(supplierArray[1].email, "May.Schneider@gmail.com")
        XCTAssertEqual(supplierArray[1].creationDate, Date(timeIntervalSince1970: 1611168591.479))
    }
}
