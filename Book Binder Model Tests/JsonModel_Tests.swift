//
//  JsonModel_Tests.swift
//  Book Binder Model Tests
//
//  Created by John Pavley on 10/4/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class JsonModel_Tests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateJson() {
        let jsonString = """
            {
                "seriesPublisher": "Marvel Entertainment",
                "seriesTitle": "Daredevil",
                "seriesEra": 2017,
                "seriesFirstIssue": 595,
                "seriesCurrentIssue": 608,
                "seriesSkippedIssues": 0,
                "seriesExtraIssues": 0,
                "books":
                [
                    {
                        "issueNumber": 605,
                        "variantLetter": "",
                        "isOwned": true,
                        "coverImageID": ""
                    }
                 ]
            }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let jsonModel = try! decoder.decode(JsonModel.self, from: jsonData)
        
        XCTAssertNotNil(jsonModel)
        XCTAssertEqual(jsonModel.seriesPublisher, "Marvel Entertainment")
        XCTAssertEqual(jsonModel.seriesTitle, "Daredevil")
        XCTAssertEqual(jsonModel.seriesEra, 2017)
        XCTAssertEqual(jsonModel.seriesFirstIssue, 595)
        XCTAssertEqual(jsonModel.seriesCurrentIssue, 608)
        XCTAssertEqual(jsonModel.seriesSkippedIssues, 0)
        XCTAssertEqual(jsonModel.seriesExtraIssues, 0)
        
        let book = jsonModel.books.first!
        
        XCTAssertNotNil(book)
        XCTAssertEqual(book.issueNumber, 605)
        XCTAssertEqual(book.variantLetter, "")
        XCTAssertEqual(book.isOwned, true)
    }
    
    func testCreateSeriesArray() {
        let jsonString = """
            [{
                "seriesPublisher": "Marvel Entertainment",
                "seriesTitle": "Daredevil",
                "seriesEra": 2017,
                "seriesFirstIssue": 595,
                "seriesCurrentIssue": 608,
                "seriesSkippedIssues": 0,
                "seriesExtraIssues": 0,
                "books":
                [
                    {
                        "issueNumber": 605,
                        "variantLetter": "",
                        "isOwned": true,
                        "coverImageID": ""
                    }
                 ]
            },
            {
                "seriesPublisher": "DC Comics",
                "seriesTitle": "Superman",
                "seriesEra": 2000,
                "seriesFirstIssue": 100,
                "seriesCurrentIssue": 1000,
                "seriesSkippedIssues": 2,
                "seriesExtraIssues": 10,
                "books":
                [
                    {
                        "issueNumber": 123,
                        "variantLetter": "c",
                        "isOwned": false,
                        "coverImageID": ""
                    },
                    {
                        "issueNumber": 345,
                        "variantLetter": "e",
                        "isOwned": true,
                        "coverImageID": ""
                    }
                 ]
            }]
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let jsonModel = try! decoder.decode([JsonModel].self, from: jsonData)
        
        XCTAssertNotNil(jsonModel)
        XCTAssertEqual(jsonModel.count, 2)
        XCTAssertEqual(jsonModel[1].seriesTitle, "Superman")
        XCTAssertEqual(jsonModel[1].books[1].issueNumber, 345)
    }
    
    
}
