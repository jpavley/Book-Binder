//
//  BookBinder_Tests.swift
//  Book Binder Model Tests
//
//  Created by John Pavley on 10/9/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class BookBinder_Tests: XCTestCase {
    
    var comicbooks = [ComicbookSeries]()
    var selectedSeriesIndex = 0
    var selectedBookIndex = 0
    var seriesURIStrings = [String]()
    var bookURIStrings = [String]()
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
        
        (comicbooks, selectedSeriesIndex, selectedBookIndex) = ComicbookSeries.createFrom(jsonString: jsonString)!
        seriesURIStrings.append("Marvel Entertainment/Daredevil/2017/1///") // 0
        seriesURIStrings.append("DC Comics/Batman/1950/0///")               // 1

        bookURIStrings.append("Marvel Entertainment/Daredevil/2017/1/0/595/") // 0
        bookURIStrings.append("Marvel Entertainment/Daredevil/2017/1/0/596/") // 1
        bookURIStrings.append("Marvel Entertainment/Daredevil/2017/1/0/597/") // 2
        bookURIStrings.append("Marvel Entertainment/Daredevil/2017/1/0/598/") // 3
        bookURIStrings.append("Marvel Entertainment/Daredevil/2017/1/0/599/") // 4
        
        bookURIStrings.append("DC Comics/Batman/1950/0/0/5/")  // 5
        bookURIStrings.append("DC Comics/Batman/1950/0/0/6/")  // 6
        bookURIStrings.append("DC Comics/Batman/1950/0/0/7/")  // 7
        bookURIStrings.append("DC Comics/Batman/1950/0/0/8/c") // 8


    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateBookBinder() {
        
        let bookBinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: selectedSeriesIndex, selectedIssueIndex: selectedBookIndex)
        
        XCTAssertEqual(bookBinder.comicbooks.count, comicbooks.count)
        XCTAssertEqual(bookBinder.comicbooks[0].publisher, comicbooks[0].publisher)
        XCTAssertEqual(bookBinder.selectedIssueIndex, 0)
        XCTAssertEqual(bookBinder.selectedComicbookIndex, 0)
    }
    
    func testGetSelectedComicbook() {
        let bookBinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 0)
        let selectedComicbook = bookBinder.getSelectedComicbookSeries()
        
        XCTAssertEqual(selectedComicbook.uri.description, seriesURIStrings[0])
    }
    
    func testGetSelectedIssue() {
        let bookBinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 0)
        let selectedIssue = bookBinder.getSelectedIssue()
        
        XCTAssertEqual(selectedIssue.uri.description, bookURIStrings[0])
        
        let bookBinder2 = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 1)
        let selectedIssue2 = bookBinder2.getSelectedIssue()
        
        XCTAssertEqual(selectedIssue2.uri.description, bookURIStrings[1])
    }
    
    func testSelectNextComicbook() {
        let bookBinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 0)
        
        bookBinder.selectNextComicbook()
        let selectedComicbook = bookBinder.getSelectedComicbookSeries()
        XCTAssertEqual(selectedComicbook.uri.description, seriesURIStrings[1])
        
        bookBinder.selectNextComicbook()
        let selectedComicbook2 = bookBinder.getSelectedComicbookSeries()
        XCTAssertEqual(selectedComicbook2.uri.description, seriesURIStrings[0])
    }
    
    func testSelectPreviousComicbook() {
        let bookBinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 0)
        
        bookBinder.selectPreviousComicbook()
        let selectedComicbook = bookBinder.getSelectedComicbookSeries()
        XCTAssertEqual(selectedComicbook.uri.description, seriesURIStrings[1])
        
        bookBinder.selectPreviousComicbook()
        let selectedComicbook2 = bookBinder.getSelectedComicbookSeries()
        XCTAssertEqual(selectedComicbook2.uri.description, seriesURIStrings[0])
    }
    
    func testSelectNextIssue() {
        let bookbinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 1)
        
        bookbinder.selectNextIssue()
        let selectedIssue = bookbinder.getSelectedIssue()
        XCTAssertEqual(selectedIssue.uri.description, bookURIStrings[2])
        
        bookbinder.selectNextComicbook()
        let selectedComicbook = bookbinder.getSelectedComicbookSeries()
        XCTAssertEqual(selectedComicbook.uri.description, seriesURIStrings[1])

        var selectedIssue3: Work
        
        for i in 0...3 {
            selectedIssue3 = bookbinder.getSelectedIssue()
            XCTAssertEqual(selectedIssue3.uri.description, bookURIStrings[5 + i])
            bookbinder.selectNextIssue()
        }
        
    }
    
    func testSelectPreviousIssue() {
        let bookbinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 1)
        
        bookbinder.selectPreviousIssue()
        let selectedIssue = bookbinder.getSelectedIssue()
        XCTAssertEqual(selectedIssue.uri.description, bookURIStrings[0])
        
        bookbinder.selectPreviousComicbook()
        let selectedComicbook = bookbinder.getSelectedComicbookSeries()
        XCTAssertEqual(selectedComicbook.uri.description, seriesURIStrings[1])
        
        var selectedIssue3: Work
        bookbinder.selectedIssueIndex = 3
        
        for i in (0...3).reversed() {
            selectedIssue3 = bookbinder.getSelectedIssue()
            XCTAssertEqual(selectedIssue3.uri.description, bookURIStrings[5 + i])
            bookbinder.selectPreviousIssue()
        }
        
    }
    
    func testUpdateBook() {
        let bookbinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 1)
        let selectedComicbook = bookbinder.getSelectedComicbookSeries()
        let bookToBeUpdated = selectedComicbook.works[BookBinderURI(fromURIString: "Marvel Entertainment/Daredevil/2017/1/1/606/c")!]

        XCTAssertEqual(selectedComicbook.works.count, 2)
        XCTAssertEqual(bookToBeUpdated?.variants[0].isOwned, true)
        XCTAssertEqual(bookToBeUpdated?.variants[0].coverImageID, "")
        
        let testURI = BookBinderURI(fromURIString: "Marvel Entertainment/Daredevil/2017/1/1/606/c")!
        let testBook = Work(fromURI: testURI, isOwned: false, coverImageID: "x-men-101")
        let testVariant = WorkVarient(printing: Int(testURI.printingPart) ?? 0, letter: testURI.variantPart, coverImageID: "x-men-101", isOwned: false)
        
        bookbinder.updateBooks(with: testBook, and: testVariant)
        
        let bookThatWasUpdated = selectedComicbook.works[BookBinderURI(fromURIString: "Marvel Entertainment/Daredevil/2017/1/1/606/c")!]
        XCTAssertEqual(selectedComicbook.works.count, 2)
        XCTAssertEqual(bookThatWasUpdated?.variants[0].isOwned, false)
        XCTAssertEqual(bookThatWasUpdated?.variants[0].coverImageID, "x-men-101")
    }
    
    func testJsonModelComputedVar() {
        let bookbinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 1)
        let computedJsonModel = bookbinder.jsonModel
        XCTAssertNotNil(computedJsonModel)
        XCTAssertEqual(computedJsonModel.selectedBookIndex, 1)
        XCTAssertEqual(computedJsonModel.selectedSeriesIndex, 0)
        XCTAssertEqual(computedJsonModel.series[0].seriesTitle, "Daredevil")
    }




}
