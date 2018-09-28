//
//  SeriesModel_Tests.swift
//  Book Binder Model Tests
//
//  Created by John Pavley on 9/24/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class SeriesModel_Tests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateSeriesModel() {
        let testString1 = "Ziff Davis/GI Joe/1950"
        let seriesModel = SeriesModel(publisherName: "Ziff Davis", seriesTitle: "GI Joe", era: "1950")
        
        XCTAssertTrue(seriesModel.seriesURI.description == testString1)
        XCTAssertTrue(seriesModel.seriesTitle == "GI Joe")
        XCTAssertTrue(seriesModel.seriesEra == "1950")
        XCTAssertTrue(seriesModel.ownedBooks.count == 0)
    }
    
    func testSeriesIssueManagement() {
        let seriesModel = SeriesModel(publisherName: "Ziff Davis", seriesTitle: "GI Joe", era: "1950")
        
        XCTAssertEqual(seriesModel.firstIssueNumber, 1)
        XCTAssertEqual(seriesModel.currentIssueNumber, 1)
    }
    
    func testAddBooksToSeries() {
        let seriesModel = SeriesModel(publisherName: "Ziff Davis", seriesTitle: "GI Joe", era: "1950")
        
        let book1 = BookModel(seriesURI: seriesModel.seriesURI, issueNumber: 1, varientLetter: "", isOwned: false)
        let book2 = BookModel(seriesURI: seriesModel.seriesURI, issueNumber: 1, varientLetter: "a", isOwned: true)
        let book3 = BookModel(seriesURI: seriesModel.seriesURI, issueNumber: 2, varientLetter: "", isOwned: false)
        let book4 = BookModel(seriesURI: seriesModel.seriesURI, issueNumber: 3, varientLetter: "", isOwned: true)
        
        
        seriesModel.ownedBooks = [book1, book2, book3, book4]
        
        XCTAssertTrue(seriesModel.ownedBooks.count == 4)
        
        let testString1 = "Ziff Davis/GI Joe/1950/1"
        XCTAssertTrue(seriesModel.ownedBooks[0].issueNumber == 1)
        XCTAssertTrue(seriesModel.ownedBooks[0].varientLetter == "")
        XCTAssertTrue(seriesModel.ownedBooks[0].isOwned == false)
        XCTAssertTrue(seriesModel.ownedBooks[0].bookURI.description == testString1)
        
        let testString2 = "Ziff Davis/GI Joe/1950/1/a/owned"
        XCTAssertTrue(seriesModel.ownedBooks[1].issueNumber == 1)
        XCTAssertTrue(seriesModel.ownedBooks[1].varientLetter == "a")
        XCTAssertTrue(seriesModel.ownedBooks[1].isOwned == true)
        XCTAssertTrue(seriesModel.ownedBooks[1].bookURI.description == testString2)
    }
    
}
