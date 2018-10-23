//
//  JsonModel_Tests.swift
//  Book Binder Model Tests
//
//  Created by John Pavley on 10/4/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class JsonModel_Tests: XCTestCase {
    
    var jsonString = ""
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        jsonString = """
        {
            "series":
            [
                {
                    "seriesPublisher": "Marvel Entertainment",
                    "seriesTitle": "Daredevil",
                    "seriesEra": 2017,
                    "seriesVolume": 1,
                    "seriesFirstIssue": 595,
                    "seriesCurrentIssue": 608,
                    "seriesSkippedIssues": 1,
                    "seriesExtraIssues": 1,
                    "books":
                    [
                        {
                            "printing": 1,
                            "issueNumber": 605,
                            "variantLetter": "",
                            "isOwned": true,
                            "coverImageID": ""
                        },
                        {
                            "printing": 1,
                            "issueNumber": 606,
                            "variantLetter": "c",
                            "isOwned": true,
                            "coverImageID": ""
                        }
                    ]
                },
                {
                    "seriesPublisher": "DC Comics",
                    "seriesTitle": "Batman",
                    "seriesEra": 1950,
                    "seriesVolume": 1,
                    "seriesFirstIssue": 5,
                    "seriesCurrentIssue": 8,
                    "seriesSkippedIssues": 0,
                    "seriesExtraIssues": 0,
                    "books":
                    [
                        {
                            "printing": 1,
                            "issueNumber": 7,
                            "variantLetter": "",
                            "isOwned": true,
                            "coverImageID": ""
                        },
                        {
                            "printing": 1,
                            "issueNumber": 8,
                            "variantLetter": "c",
                            "isOwned": true,
                            "coverImageID": ""
                        }
                    ]
                }
            ],
            "selectedSeriesIndex": 0,
            "selectedBookIndex": 0
        }
        """

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateJson() {
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let jsonModel = try! decoder.decode(JsonModel.self, from: jsonData)
        let series = jsonModel.series.first!
        
        XCTAssertNotNil(jsonModel)
        XCTAssertEqual(series.seriesPublisher, "Marvel Entertainment")
        XCTAssertEqual(series.seriesTitle, "Daredevil")
        XCTAssertEqual(series.seriesEra, 2017)
        XCTAssertEqual(series.seriesFirstIssue, 595)
        XCTAssertEqual(series.seriesCurrentIssue, 608)
        XCTAssertEqual(series.seriesSkippedIssues, 1)
        XCTAssertEqual(series.seriesExtraIssues, 1)
        
        let book = series.books.first!
        
        XCTAssertNotNil(book)
        XCTAssertEqual(book.issueNumber, 605)
        XCTAssertEqual(book.variantLetter, "")
        XCTAssertEqual(book.isOwned, true)
    }
    
    func testCreateSeriesArray() {
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let jsonModel = try! decoder.decode(JsonModel.self, from: jsonData)
        
        XCTAssertNotNil(jsonModel)
        XCTAssertEqual(jsonModel.series.count, 2)
        XCTAssertEqual(jsonModel.series[1].seriesTitle, "Batman")
        XCTAssertEqual(jsonModel.series[1].books[1].issueNumber, 8)
    }
    
    func testInitFromProperties() {
        let jsonBook1 = JsonModel.JsonSeries.JsonBook(printing: 1, issueNumber: 2, variantLetter: "", isOwned: true, coverImageID: "the-amory-wars-v2-i2")
        let jsonBook2 = JsonModel.JsonSeries.JsonBook(printing: 1, issueNumber: 3, variantLetter: "", isOwned: true, coverImageID: "the-amory-wars-v2-i3")
        let jsonSeries = JsonModel.JsonSeries(seriesPublisher: "Image", seriesTitle: "The Amory Wars", seriesEra: 2008, seriesVolume: 1, seriesFirstIssue: 1, seriesCurrentIssue: 5, seriesSkippedIssues: 0, seriesExtraIssues: 0, books: [jsonBook1, jsonBook2])
        
        XCTAssertNotNil(jsonSeries)
        XCTAssertEqual(jsonSeries.books.count, 2)
        
        let testBook = jsonSeries.books[0]
        XCTAssertEqual(testBook.coverImageID, "the-amory-wars-v2-i2")
    }
    
    func testInitFromSeriesArray() {
        let jsonBook1 = JsonModel.JsonSeries.JsonBook(printing: 1, issueNumber: 2, variantLetter: "", isOwned: true, coverImageID: "the-amory-wars-v2-i2")
        let jsonBook2 = JsonModel.JsonSeries.JsonBook(printing: 1, issueNumber: 3, variantLetter: "", isOwned: true, coverImageID: "the-amory-wars-v2-i3")
        let jsonSeries = JsonModel.JsonSeries(seriesPublisher: "Image", seriesTitle: "The Amory Wars", seriesEra: 2008, seriesVolume: 1, seriesFirstIssue: 1, seriesCurrentIssue: 5, seriesSkippedIssues: 0, seriesExtraIssues: 0, books: [jsonBook1, jsonBook2])
        
        let jsonModel = JsonModel(series: [jsonSeries], selectedSeriesIndex: 0, selectedBookIndex: 0)
        
        XCTAssertNotNil(jsonModel)
        XCTAssertEqual(jsonModel.selectedBookIndex, 0)
        XCTAssertEqual(jsonModel.series[0].books[0].issueNumber, 2)
    }
}
