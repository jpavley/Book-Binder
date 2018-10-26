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
                        "seriesSkippedIssues": [],
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
                        "seriesSkippedIssues": [],
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
                "selectedSeriesIndex": 1,
                "selectedBookIndex": 1
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
        
        let comicbook = Comicbook(seriesURI: testURI!)
        comicbook.series.firstIssue = series.seriesFirstIssue
        comicbook.series.currentIssue = series.seriesCurrentIssue
        comicbook.series.skippedIssues = series.seriesSkippedIssues
        
        XCTAssertNotNil(comicbook)
        
        for jsonBook in series.books {
            let book = Work(seriesURI: testURI!, printing: jsonBook.printing, issueNumber: jsonBook.issueNumber, variantLetter: jsonBook.variantLetter, isOwned: jsonBook.isOwned, coverImageID: jsonBook.coverImageID)
            XCTAssertNotNil(book)
            comicbook.books[book.bookURI] = book
        }
        
        XCTAssertEqual(comicbook.books.count, series.books.count)
        XCTAssertEqual(comicbook.series.publishedIssueCount, 14)
        
        for (_,value) in comicbook.books {
            XCTAssertEqual(value.seriesURI.description, testURI!.description)
        }
        
    }
    
    func testCreateComicbookFromFactory() {
        
        let (comicbook, selectedSeriesIndex, selectedBookIndex) = Comicbook.createFrom(jsonString: jsonString)!
        let testURIString = "Marvel Entertainment/Daredevil/2017/1///"
        let testURI = BookBinderURI(fromURIString: testURIString)

        XCTAssertNotNil(comicbook)
        XCTAssertEqual(comicbook[0].books.count, 2)
        XCTAssertEqual(comicbook[0].series.publishedIssueCount, 14)
        
        XCTAssertEqual(selectedSeriesIndex, 1)
        XCTAssertEqual(selectedBookIndex, 1)
        
        for (_,value) in comicbook[0].books {
            XCTAssertEqual(value.seriesURI.description, testURI!.description)
        }
    }
    
    func testOwnedIssues() {
        
        let (comicbook, _, _) = Comicbook.createFrom(jsonString: jsonString)!
        XCTAssertEqual(comicbook[0].ownedIssues(), ["605", "606"])

    }
    
    func testGetBookBy() {
        
        let bookURI1 = BookBinderURI(fromURIString: "Marvel Entertainment/Daredevil/2017/1/1/605/")
        let bookURI2 = BookBinderURI(fromURIString: "Marvel Entertainment/Daredevil/2017/1/1/606/c")

        let (comicbooks, _, _) = Comicbook.createFrom(jsonString: jsonString)!
        
        
        let comicbook = comicbooks[0]
        
        for (k,v) in comicbook.books {
            XCTAssertEqual("\(k.description)", "\(v.bookURI.description)")
        }
        
        let testBook1 = comicbook.books[bookURI1!]
        let testBook2 = comicbook.books[bookURI2!]
        
        let testBook3 = comicbook.getBookBy(issueNumber: 605).first!
        let testBook4 = comicbook.getBookBy(issueNumber: 606).first!
        
        XCTAssertEqual(testBook1?.bookURI.description, testBook3.bookURI.description)
        XCTAssertEqual(testBook2?.bookURI.description, testBook4.bookURI.description)

    }    
}
