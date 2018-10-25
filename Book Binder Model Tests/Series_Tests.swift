//
//  Series_Tests.swift
//  Book Binder Model Tests
//
//  Created by John Pavley on 10/24/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class Series_Tests: XCTestCase {
    
    var publisher: String!
    var title: String!
    var era: Int!
    var volumeNumber: Int!
    var testURIString: String!
    var testURI: BookBinderURI!
    var firstIssue: Int!
    var currentIssue: Int!
    var testSeries: Series!
    
    var testURIString2: String!
    var testURI2: BookBinderURI!
    var volumeNumber2: Int!
    var testSeries2: Series!
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        publisher = "Ziff Davis"
        title = "GI Joe"
        era = 1950
        volumeNumber = 1
        firstIssue = 1
        currentIssue = 10
        
        testURIString = "\(publisher!)/\(title!)/\(era!)/\(volumeNumber!)///"
        testURI = BookBinderURI(fromURIString: testURIString)
        testSeries = Series(uri: testURI, firstIssue: firstIssue, currentIssue: currentIssue)
        
        volumeNumber2 = 0
        testURIString2 = "\(publisher!)/\(title!)/\(era!)/\(volumeNumber2!)///"
        testURI2 = BookBinderURI(fromURIString: testURIString2)
        testSeries2 = Series(uri: testURI2, firstIssue: firstIssue, currentIssue: currentIssue)

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateSeries() {
        XCTAssertNotNil(testSeries)
        XCTAssertEqual(testSeries.uri.description, testURIString)
        XCTAssertEqual(testSeries.title, title)
        XCTAssertEqual(testSeries.era, era)
        XCTAssertEqual(testSeries.volumeNumber, volumeNumber)
        
        XCTAssertNotNil(testSeries2)
        XCTAssertEqual(testSeries2.uri.description, testURIString2)
        XCTAssertEqual(testSeries2.title, title)
        XCTAssertEqual(testSeries2.era, era)
        XCTAssertEqual(testSeries2.volumeNumber, volumeNumber2)
    }
    
    func testSeriesIssueManagement() {
        XCTAssertEqual(testSeries.firstIssue, firstIssue)
        XCTAssertEqual(testSeries.currentIssue, currentIssue)
        XCTAssertEqual(testSeries.skippedIssues.count, 0)
        XCTAssertEqual(testSeries.publishedIssueCount, currentIssue)
    }

    func testSeriesMutipleIssues() {
        
        testSeries.firstIssue = 1
        testSeries.currentIssue = 2
        XCTAssertEqual(testSeries.publishedIssueCount, 2)
        
        testSeries.firstIssue = 1
        testSeries.currentIssue = 3
        XCTAssertEqual(testSeries.publishedIssueCount, 3)
        
        testSeries.firstIssue = 2
        testSeries.currentIssue = 4
        XCTAssertEqual(testSeries.publishedIssueCount, 3)
        
        testSeries.firstIssue = 2
        testSeries.currentIssue = 5
        XCTAssertEqual(testSeries.publishedIssueCount, 4)
        
        testSeries.firstIssue = 2
        testSeries.currentIssue = 6
        XCTAssertEqual(testSeries.publishedIssueCount, 5)
    }
    
    func testSeriesOutOfSequeenceIssues() {
        
        testSeries.firstIssue = 1
        testSeries.currentIssue = 100
        XCTAssertEqual(testSeries.publishedIssueCount, 100)
        
        testSeries.skippedIssues.append(contentsOf: [11,12,13,14,15,16,17,18,19,20])
        XCTAssertEqual(testSeries.publishedIssueCount, 110)
        
        testSeries.firstIssue = 20
        XCTAssertEqual(testSeries.publishedIssueCount, 91)
    }

    func testPublishedIssues() {
        
        testSeries.firstIssue = 5
        testSeries.currentIssue = 10
        XCTAssertEqual(testSeries.publishedIssues, [5, 6, 7, 8, 9, 10])
    }
    
    func testSetBookBinderURI() {
        testSeries.uri = BookBinderURI(fromURIString: "a/b/c/d/e/f/g")!
        XCTAssertEqual(testSeries.publisher, "a")
        XCTAssertEqual(testSeries.title, "b")
        XCTAssertEqual(testSeries.era, 0)
        XCTAssertEqual(testSeries.volumeNumber, 0)
   }
    
    func testDescriptions() {
        XCTAssertEqual(testSeries.description, "Series \(testURIString!)")
    }
}
