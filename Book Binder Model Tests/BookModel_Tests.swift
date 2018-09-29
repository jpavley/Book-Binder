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
    
    func testCreateBookModel() {
        let testString1 = "Marvel Entertainment/Doctor Strange/2018"
        let seriesURI = BookBinderURI(fromURIString: testString1)
        let bookModel = BookModel(seriesURI: seriesURI, issueNumber: 1, varientLetter: "a", isOwned: true)
        let testString2 = "Marvel Entertainment/Doctor Strange/2018/1/a/owned"
        
        XCTAssertTrue(bookModel.bookURI.description == testString2)
        XCTAssertTrue(bookModel.issueNumber == 1)
        XCTAssertTrue(bookModel.variantLetter == "a")
        XCTAssertTrue(bookModel.isOwned == true)
    }
}
