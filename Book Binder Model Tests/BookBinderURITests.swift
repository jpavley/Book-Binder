//
//  BookBinderURITests.swift
//  BookBinderLab1Tests
//
//  Created by John Pavley on 11/1/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class BookBinderURITests: XCTestCase {
    
    let emptyString = ""
    let badURI   = "/////"
    let emptyURI = "1/////"
    let testURIString1 = "1/publisher/series/volume/issue/variant"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit() {
        let uriUT1 = BookBinderURI()
        XCTAssertNotNil(uriUT1)
    }
    
    func testInitFromProperties() {
        let uriUT1 = BookBinderURI(versionPart: "1", publisherPart: "publisher", seriesPart: "series",
                                   volumePart: "volume", issuePart: "issue", variantPart: "variant")
        XCTAssertNotNil(uriUT1)

        XCTAssertEqual(BookBinderURI.part(from: uriUT1.description, partID: .version), "1")
        XCTAssertEqual(BookBinderURI.part(from: uriUT1.description, partID: .publisher), "publisher")
        XCTAssertEqual(BookBinderURI.part(from: uriUT1.description, partID: .series), "series")
        XCTAssertEqual(BookBinderURI.part(from: uriUT1.description, partID: .volume), "volume")
        XCTAssertEqual(BookBinderURI.part(from: uriUT1.description, partID: .issue), "issue")

    }
    
    func testInitFromString() {
        let uriUT1 = BookBinderURI(from: emptyString)
        XCTAssertNil(uriUT1)
        
        let uriUT2 = BookBinderURI(from: badURI)
        XCTAssertNil(uriUT2)
        
        let uriUT3 = BookBinderURI(from: emptyURI)
        XCTAssertNotNil(uriUT3)
        XCTAssertEqual(uriUT3?.description, emptyURI)
        
        let uriUT4 = BookBinderURI(from: testURIString1)
        XCTAssertNotNil(uriUT4)
        XCTAssertEqual(uriUT4?.description, testURIString1)
    }
    
    func testPartFromURIString() {
        
        XCTAssertEqual(BookBinderURI.part(from: testURIString1, partID: .version), "1")
        XCTAssertEqual(BookBinderURI.part(from: testURIString1, partID: .publisher), "publisher")
        XCTAssertEqual(BookBinderURI.part(from: testURIString1, partID: .series), "series")
        XCTAssertEqual(BookBinderURI.part(from: testURIString1, partID: .volume), "volume")
        XCTAssertEqual(BookBinderURI.part(from: testURIString1, partID: .issue), "issue")
        XCTAssertEqual(BookBinderURI.part(from: testURIString1, partID: .variant), "variant")
        
        XCTAssertEqual(BookBinderURI.part(from: emptyURI, partID: .version), "1")
        XCTAssertEqual(BookBinderURI.part(from: emptyURI, partID: .publisher), "")
        XCTAssertEqual(BookBinderURI.part(from: emptyURI, partID: .series), "")
        XCTAssertEqual(BookBinderURI.part(from: emptyURI, partID: .volume), "")
        XCTAssertEqual(BookBinderURI.part(from: emptyURI, partID: .issue), "")
        XCTAssertEqual(BookBinderURI.part(from: emptyURI, partID: .variant), "")

        XCTAssertEqual(BookBinderURI.part(from: badURI, partID: .version), nil)
        XCTAssertEqual(BookBinderURI.part(from: badURI, partID: .publisher), nil)
        XCTAssertEqual(BookBinderURI.part(from: badURI, partID: .series), nil)
        XCTAssertEqual(BookBinderURI.part(from: badURI, partID: .volume), nil)
        XCTAssertEqual(BookBinderURI.part(from: badURI, partID: .issue), nil)
        XCTAssertEqual(BookBinderURI.part(from: badURI, partID: .variant), nil)
    }
    
    func testHashable() {
        let uriUT1 = BookBinderURI(from: testURIString1)
        let uriUT2 = BookBinderURI(from: "1/publisher1/series/volume/issue/variant")
        let uriUT3 = BookBinderURI(from: testURIString1)
        
        XCTAssertTrue(uriUT1 == uriUT3)
        XCTAssertFalse(uriUT1 == uriUT2)
        
        var dictionary1: [BookBinderURI:String] = [:]
        dictionary1[uriUT1!] = "one"
        dictionary1[uriUT2!] = "two"
        
        XCTAssertEqual(dictionary1[uriUT1!], "one")
        XCTAssertEqual(dictionary1[uriUT2!], "two")
    }


}
