//
//  BookModel_Tests.swift
//  Book Binder Model Tests
//
//  Created by John Pavley on 9/24/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class BookModel_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateBookModelFromProperies() {
        let testString1 = "Marvel Entertainment/Doctor Strange/2018//"
        let seriesURI = BookBinderURI(fromURIString: testString1)
        let bookModel = BookModel(seriesURI: seriesURI, issueNumber: 1, variantLetter: "a", isOwned: true, coverImageID: "x-men-101")
        
        XCTAssertEqual(bookModel.seriesURI.description, testString1)
        XCTAssertEqual(bookModel.issueNumber, 1)
        XCTAssertEqual(bookModel.variantLetter, "a")
        XCTAssertEqual(bookModel.isOwned, true)
        XCTAssertEqual(bookModel.coverImageID, "x-men-101")

    }
    
    func testCreateBookModelFromURI() {
        let testString1 = "Marvel Entertainment/DoctorStrange/2018/1/v"
        let bookURI = BookBinderURI(fromURIString: testString1)
        let bookModel = BookModel(fromURI: bookURI, isOwned: true, coverImageID: "x-men-101")
        
        XCTAssertEqual(bookModel.bookURI.description, testString1)
        XCTAssertEqual(bookModel.issueNumber, 1)
        XCTAssertEqual(bookModel.variantLetter, "v")
        XCTAssertEqual(bookModel.isOwned, true)
    }
    
    func testComputedProperties() {
        let testString1 = "Marvel Entertainment/Doctor Strange/2018//"
        let seriesURI = BookBinderURI(fromURIString: testString1)
        let bookModel = BookModel(seriesURI: seriesURI, issueNumber: 1, variantLetter: "a", isOwned: true, coverImageID: "x-men-101")
        let testString2 = "Marvel Entertainment/Doctor Strange/2018/1/a"
        
        XCTAssertEqual(bookModel.bookURI.description, testString2)
        XCTAssertEqual(bookModel.bookPublisher, "Marvel Entertainment")
        XCTAssertEqual(bookModel.bookTitle, "Doctor Strange")
        XCTAssertEqual(bookModel.bookEra, "2018")
    }
    
    func testBookURIUnowned() {
        let testString1 = "Marvel Entertainment/Doctor Strange/2018//"
        let seriesURI = BookBinderURI(fromURIString: testString1)
        let bookModel = BookModel(seriesURI: seriesURI, issueNumber: 1, variantLetter: "a", isOwned: false, coverImageID: "x-men-101")
        let testString2 = "Marvel Entertainment/Doctor Strange/2018/1/a"

        XCTAssertEqual(bookModel.bookURI.description, testString2)

    }
}
