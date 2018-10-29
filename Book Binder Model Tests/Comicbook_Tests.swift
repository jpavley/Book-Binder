//
//  Comicbook_Tests.swift
//  Book Binder Model Tests
//
//  Created by John Pavley on 10/5/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class Comicbook_Tests: XCTestCase {
    
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
    
    func testCreateComicbook() {
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let jsonModel = try! decoder.decode(JsonModel.self, from: jsonData)
        let series = jsonModel.series.first!
        
        let testURIString = "\(series.seriesPublisher)/\(series.seriesTitle)/\(series.seriesEra)/\(series.seriesVolume)///"
        let testURI = BookBinderURI(fromURIString: testURIString)
        
        let comicbook = ComicbookSeries(seriesURI: testURI!)
        comicbook.firstIssue = series.seriesFirstIssue
        comicbook.currentIssue = series.seriesCurrentIssue
        comicbook.skippedIssues = series.seriesSkippedIssues
        
        XCTAssertNotNil(comicbook)
        
        var workVariantList = [WorkVarient]()
        for jsonBook in series.books {
            
            for variant in jsonBook.variants {
                let workVariant = WorkVarient(printing: variant.printing, letter: variant.letter, coverImageID: variant.coverImageID, isOwned: variant.isOwned)
                XCTAssertNil(workVariant)
                workVariantList.append(workVariant)
            }
            
            let book = Work(seriesURI: testURI!, issueNumber: jsonBook.issueNumber, variants: workVariantList)
            XCTAssertNotNil(book)
            comicbook.works[book.uri] = book
        }
        
        XCTAssertEqual(comicbook.works.count, series.books.count)
        XCTAssertEqual(comicbook.publishedIssueCount, 14)
        
        for (_,value) in comicbook.works {
            XCTAssertEqual(value.seriesURI.description, testURI!.description)
        }
        
    }
    
    func testCreateComicbookFromFactory() {
        
        let (comicbook, selectedSeriesIndex, selectedBookIndex) = ComicbookSeries.createFrom(jsonString: jsonString)!
        let testURIString = "Marvel Entertainment/Daredevil/2017/1///"
        let testURI = BookBinderURI(fromURIString: testURIString)

        XCTAssertNotNil(comicbook)
        XCTAssertEqual(comicbook[0].works.count, 2)
        XCTAssertEqual(comicbook[0].publishedIssueCount, 14)
        
        XCTAssertEqual(selectedSeriesIndex, 1)
        XCTAssertEqual(selectedBookIndex, 1)
        
        for (_,value) in comicbook[0].works {
            XCTAssertEqual(value.seriesURI.description, testURI!.description)
        }
    }
    
    func testOwnedIssues() {
        
        let (comicbook, _, _) = ComicbookSeries.createFrom(jsonString: jsonString)!
        XCTAssertEqual(comicbook[0].ownedIssues(), ["605", "606"])

    }
    
    func testGetBookBy() {
        
        let bookURI1 = BookBinderURI(fromURIString: "Marvel Entertainment/Daredevil/2017/1/1/605/")
        let bookURI2 = BookBinderURI(fromURIString: "Marvel Entertainment/Daredevil/2017/1/1/606/c")

        let (comicbooks, _, _) = ComicbookSeries.createFrom(jsonString: jsonString)!
        
        
        let comicbook = comicbooks[0]
        
        for (k,v) in comicbook.works {
            XCTAssertEqual("\(k.description)", "\(v.uri.description)")
        }
        
        let testBook1 = comicbook.works[bookURI1!]
        let testBook2 = comicbook.works[bookURI2!]
        
        let testBook3 = comicbook.getBookBy(issueNumber: 605).first!
        let testBook4 = comicbook.getBookBy(issueNumber: 606).first!
        
        XCTAssertEqual(testBook1?.uri.description, testBook3.uri.description)
        XCTAssertEqual(testBook2?.uri.description, testBook4.uri.description)

    }    
}
