//
//  Comicbook_Tests.swift
//  Book Binder Model Tests
//
//  Created by John Pavley on 10/5/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class Comicbook_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateComicbook() {
        let jsonString = """
            {
                "seriesPublisher": "Marvel Entertainment",
                "seriesTitle": "Daredevil",
                "seriesEra": 2017,
                "seriesFirstIssue": 595,
                "seriesCurrentIssue": 608,
                "seriesSkippedIssues": 1,
                "seriesExtraIssues": 1,
                "books":
                [
                    {
                        "issueNumber": 605,
                        "variantLetter": "",
                        "isOwned": true
                    },
                     {
                        "issueNumber": 606,
                        "variantLetter": "c",
                        "isOwned": false
                    }
                ]
            }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let jsonModel = try! decoder.decode(JsonModel.self, from: jsonData)
        
        let testURIString = "\(jsonModel.seriesPublisher)/\(jsonModel.seriesTitle)/\(jsonModel.seriesEra)"
        let testURI = BookBinderURI(fromURIString: testURIString)
        
        let comicbook = Comicbook(seriesURI: testURI)
        comicbook.series.seriesFirstIssue = jsonModel.seriesFirstIssue
        comicbook.series.seriesCurrentIssue = jsonModel.seriesCurrentIssue
        comicbook.series.seriesSkippedIssues = jsonModel.seriesSkippedIssues
        comicbook.series.seriesExtraIssues = jsonModel.seriesExtraIssues
        
        XCTAssertNotNil(comicbook)
        
        for jsonBook in jsonModel.books {
            let book = BookModel(seriesURI: testURI, issueNumber: jsonBook.issueNumber, variantLetter: jsonBook.variantLetter, isOwned: jsonBook.isOwned)
            XCTAssertNotNil(book)
            comicbook.books.append(book)
        }
        
        XCTAssertEqual(comicbook.books.count, jsonModel.books.count)
        XCTAssertEqual(comicbook.series.publishedIssueCount, 14)
        XCTAssertEqual(comicbook.books[0].seriesURI.description, testURI.description)
        XCTAssertEqual(comicbook.books[1].seriesURI.description, testURI.description)
    }
    
    func testCreateComicbookFromFactory() {
        let jsonString = """
            [{
                "seriesPublisher": "Marvel Entertainment",
                "seriesTitle": "Daredevil",
                "seriesEra": 2017,
                "seriesFirstIssue": 595,
                "seriesCurrentIssue": 608,
                "seriesSkippedIssues": 1,
                "seriesExtraIssues": 1,
                "books":
                [
                    {
                        "issueNumber": 605,
                        "variantLetter": "",
                        "isOwned": true
                    },
                     {
                        "issueNumber": 606,
                        "variantLetter": "c",
                        "isOwned": false
                    }
                ]
            }]
        """
        
        let comicbook = Comicbook.createFrom(jsonString: jsonString)
        
        XCTAssertNotNil(comicbook)
        XCTAssertEqual(comicbook![0].books.count, 2)
        XCTAssertEqual(comicbook![0].series.publishedIssueCount, 14)
        XCTAssertEqual(comicbook![0].books[0].seriesURI.description, "Marvel Entertainment/Daredevil/2017")
        XCTAssertEqual(comicbook![0].books[1].seriesURI.description, "Marvel Entertainment/Daredevil/2017")
    }
    
    func testOwnedIssues() {
        let jsonString = """
            [{
                "seriesPublisher": "Marvel Entertainment",
                "seriesTitle": "Daredevil",
                "seriesEra": 2017,
                "seriesFirstIssue": 595,
                "seriesCurrentIssue": 608,
                "seriesSkippedIssues": 1,
                "seriesExtraIssues": 1,
                "books":
                [
                    {
                        "issueNumber": 605,
                        "variantLetter": "",
                        "isOwned": true
                    },
                     {
                        "issueNumber": 606,
                        "variantLetter": "c",
                        "isOwned": true
                    }
                ]
            }]
        """
        
        let comicbook = Comicbook.createFrom(jsonString: jsonString)
        XCTAssertEqual(comicbook![0].ownedIssues(), ["605", "606"])

    }
}
