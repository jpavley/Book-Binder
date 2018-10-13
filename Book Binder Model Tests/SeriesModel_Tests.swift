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
    
    func testCreateSeriesModelFromProperties() {
        let testString1 = "Ziff Davis/GI Joe/1950////"
        let seriesModel = SeriesModel(seriesPublisher: "Ziff Davis", seriesTitle: "GI Joe", seriesEra: "1950")
        
        XCTAssertEqual(seriesModel.seriesURI.description, testString1)
        XCTAssertEqual(seriesModel.seriesTitle, "GI Joe")
        XCTAssertEqual(seriesModel.seriesEra, "1950")
    }
    
    func testCreateSeriesModelFromURI() {
        let testString1 = "Ziff Davis/GI Joe/1950////"
        let testURI = BookBinderURI(fromURIString: testString1)
        let testSeriesModel = SeriesModel(fromURI: testURI)
        
        XCTAssertEqual(testSeriesModel.seriesURI.description, testString1)
        XCTAssertEqual(testSeriesModel.seriesTitle, "GI Joe")
        XCTAssertEqual(testSeriesModel.seriesEra, "1950")
    }
    
    func testSeriesIssueManagement() {
        let seriesModel = SeriesModel(seriesPublisher: "Ziff Davis", seriesTitle: "GI Joe", seriesEra: "1950")
        
        XCTAssertEqual(seriesModel.seriesFirstIssue, 1)
        XCTAssertEqual(seriesModel.seriesCurrentIssue, 1)
        XCTAssertEqual(seriesModel.seriesSkippedIssues, 0)
        XCTAssertEqual(seriesModel.seriesExtraIssues, 0)
        XCTAssertEqual(seriesModel.publishedIssueCount, 1)
    }
    
    func testSeriesMutipleIssues() {
        let seriesModel = SeriesModel(seriesPublisher: "Ziff Davis", seriesTitle: "GI Joe", seriesEra: "1950")
        
        seriesModel.seriesFirstIssue = 1
        seriesModel.seriesCurrentIssue = 2
        XCTAssertEqual(seriesModel.publishedIssueCount, 2)
        
        seriesModel.seriesFirstIssue = 1
        seriesModel.seriesCurrentIssue = 3
        XCTAssertEqual(seriesModel.publishedIssueCount, 3)
        
        seriesModel.seriesFirstIssue = 2
        seriesModel.seriesCurrentIssue = 4
        XCTAssertEqual(seriesModel.publishedIssueCount, 3)
        
        seriesModel.seriesFirstIssue = 2
        seriesModel.seriesCurrentIssue = 5
        XCTAssertEqual(seriesModel.publishedIssueCount, 4)
        
        seriesModel.seriesFirstIssue = 2
        seriesModel.seriesCurrentIssue = 6
        XCTAssertEqual(seriesModel.publishedIssueCount, 5)
    }
    
    func testSeriesOutOfSequeenceIssues() {
        let seriesModel = SeriesModel(seriesPublisher: "Ziff Davis", seriesTitle: "GI Joe", seriesEra: "1950")
        seriesModel.seriesFirstIssue = 1
        seriesModel.seriesCurrentIssue = 100
        XCTAssertEqual(seriesModel.publishedIssueCount, 100)
        
        seriesModel.seriesSkippedIssues = 10
        seriesModel.seriesExtraIssues = 0
       XCTAssertEqual(seriesModel.publishedIssueCount, 90)

        seriesModel.seriesSkippedIssues = 5
        seriesModel.seriesExtraIssues = 5
        XCTAssertEqual(seriesModel.publishedIssueCount, 100)
        
        seriesModel.seriesFirstIssue = 20
        XCTAssertEqual(seriesModel.publishedIssueCount, 81)
    }
    
    func testPublishedIssues() {
        let seriesModel = SeriesModel(seriesPublisher: "Ziff Davis", seriesTitle: "GI Joe", seriesEra: "1950")
        seriesModel.seriesFirstIssue = 5
        seriesModel.seriesCurrentIssue = 10
        XCTAssertEqual(seriesModel.publishedIssues, [5, 6, 7, 8, 9, 10])

    }
}
