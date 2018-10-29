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
                    "seriesSkippedIssues": [1],
                    "books":
                    [
                        {
                            "issueNumber": 605,
                            "variants":
                            [
                                {
                                    "printing": 1,
                                    "letter": "",
                                    "isOwned": true,
                                    "coverImageID": ""
                                }
                            ]
                        },
                        {
                            "issueNumber": 606,
                            "variants":
                            [
                                {
                                    "printing": 1,
                                    "letter": "c",
                                    "isOwned": true,
                                    "coverImageID": ""
                                }
                            ]
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
                    "seriesSkippedIssues": [],
                    "books":
                    [
                        {
                            "issueNumber": 7,
                            "variants":
                            [
                                {
                                    "printing": 1,
                                    "letter": "",
                                    "isOwned": true,
                                    "coverImageID": ""
                                }
                            ]
                        },
                        {
                            "issueNumber": 8,
                            "variants":
                            [
                                {
                                    "printing": 1,
                                    "letter": "c",
                                    "isOwned": true,
                                    "coverImageID": ""
                                }
                            ]
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
        XCTAssertEqual(series.seriesSkippedIssues, [1])
        
        let book = series.books.first!
        
        XCTAssertNotNil(book)
        XCTAssertEqual(book.issueNumber, 605)
        XCTAssertEqual(book.variants.first!.letter, "")
        XCTAssertEqual(book.variants.first!.isOwned, true)
        XCTAssertEqual(book.variants.first!.printing, 1)
        XCTAssertEqual(book.variants.first!.coverImageID, "")
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
        let jsonWorkVariant1 = JsonModel.JsonSeries.JsonBook.JsonVariant(printing: 1, variantLetter: "", isOwned: true, coverImageID: "the-amory-wars-v2-i2")
        let jsonBook1 = JsonModel.JsonSeries.JsonBook(issueNumber: 2, variants: [jsonWorkVariant1])
        
        let jsonWorkVariant2 = JsonModel.JsonSeries.JsonBook.JsonVariant(printing: 1, variantLetter: "", isOwned: true, coverImageID: "the-amory-wars-v2-i3")
        let jsonBook2 = JsonModel.JsonSeries.JsonBook(issueNumber: 3, variants: [jsonWorkVariant2])

        let jsonSeries = JsonModel.JsonSeries(publisher: "Image", title: "The Amory Wars", era: 2008, volumeNumber: 1, firstIssue: 1, currentIssue: 5, skippedIssues: [Int](), books: [jsonBook1, jsonBook2])
        
        XCTAssertNotNil(jsonSeries)
        XCTAssertEqual(jsonSeries.books.count, 2)
        
        let testBook = jsonSeries.books[0]
        XCTAssertEqual(testBook.variants.first!.coverImageID, "the-amory-wars-v2-i2")
    }
    
    func testInitFromSeriesArray() {
        let jsonWorkVariant1 = JsonModel.JsonSeries.JsonBook.JsonVariant(printing: 1, variantLetter: "", isOwned: true, coverImageID: "the-amory-wars-v2-i2")
        let jsonBook1 = JsonModel.JsonSeries.JsonBook(issueNumber: 2, variants: [jsonWorkVariant1])
        
        let jsonWorkVariant2 = JsonModel.JsonSeries.JsonBook.JsonVariant(printing: 1, variantLetter: "", isOwned: true, coverImageID: "the-amory-wars-v2-i3")
        let jsonBook2 = JsonModel.JsonSeries.JsonBook(issueNumber: 3, variants: [jsonWorkVariant2])
        
        let jsonSeries = JsonModel.JsonSeries(publisher: "Image", title: "The Amory Wars", era: 2008, volumeNumber: 1, firstIssue: 1, currentIssue: 5, skippedIssues: [Int](), books: [jsonBook1, jsonBook2])
        
        let jsonModel = JsonModel(series: [jsonSeries], selectedSeriesIndex: 0, selectedBookIndex: 0)
        
        XCTAssertNotNil(jsonModel)
        XCTAssertEqual(jsonModel.selectedBookIndex, 0)
        XCTAssertEqual(jsonModel.series[0].books[0].issueNumber, 2)
    }
}
