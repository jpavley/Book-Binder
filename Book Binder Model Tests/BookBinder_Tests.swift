//
//  BookBinder_Tests.swift
//  Book Binder Model Tests
//
//  Created by John Pavley on 10/9/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class BookBinder_Tests: XCTestCase {
    
    var comicbooks = [Comicbook]()
    var seriesURIStrings = [String]()
    var bookURIStrings = [String]()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
            },
            {
                "seriesPublisher": "DC Comics",
                "seriesTitle": "Batman",
                "seriesEra": 1950,
                "seriesFirstIssue": 5,
                "seriesCurrentIssue": 8,
                "seriesSkippedIssues": 0,
                "seriesExtraIssues": 0,
                "books":
                [
                    {
                        "issueNumber": 7,
                        "variantLetter": "",
                        "isOwned": true
                    },
                     {
                        "issueNumber": 8,
                        "variantLetter": "c",
                        "isOwned": true
                    }
                ]
            }]
        """
        
        comicbooks = Comicbook.createFrom(jsonString: jsonString)!
        seriesURIStrings.append("Marvel Entertainment/Daredevil/2017///") // 0
        seriesURIStrings.append("DC Comics/Batman/1950///")               // 1

        bookURIStrings.append("Marvel Entertainment/Daredevil/2017/595//") // 0
        bookURIStrings.append("Marvel Entertainment/Daredevil/2017/596//") // 1
        bookURIStrings.append("Marvel Entertainment/Daredevil/2017/597//") // 2
        bookURIStrings.append("Marvel Entertainment/Daredevil/2017/598//") // 3
        bookURIStrings.append("Marvel Entertainment/Daredevil/2017/599//") // 4
        
        bookURIStrings.append("DC Comics/Batman/1950/5//")       // 5
        bookURIStrings.append("DC Comics/Batman/1950/6//")       // 6
        bookURIStrings.append("DC Comics/Batman/1950/7//owned")  // 7
        bookURIStrings.append("DC Comics/Batman/1950/8/c/owned") // 8


    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateBookBinder() {
        
        let bookBinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 0)
        
        XCTAssertEqual(bookBinder.comicbooks.count, comicbooks.count)
        XCTAssertEqual(bookBinder.comicbooks[0].series.seriesPublisher, comicbooks[0].series.seriesPublisher)
        XCTAssertEqual(bookBinder.selectedIssueIndex, 0)
        XCTAssertEqual(bookBinder.selectedComicbookIndex, 0)
    }
    
    func testGetSelectedComicbook() {
        let bookBinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 0)
        let selectedComicbook = bookBinder.getSelectedComicbook()
        
        XCTAssertEqual(selectedComicbook.series.seriesURI.description, seriesURIStrings[0])
    }
    
    func testGetSelectedIssue() {
        let bookBinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 0)
        let selectedIssue = bookBinder.getSelectedIssue()
        
        XCTAssertEqual(selectedIssue.bookURI.description, bookURIStrings[0])
        
        let bookBinder2 = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 1)
        let selectedIssue2 = bookBinder2.getSelectedIssue()
        
        XCTAssertEqual(selectedIssue2.bookURI.description, bookURIStrings[1])
    }
    
    func testSelectNextComicbook() {
        let bookBinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 0)
        
        bookBinder.selectNextComicbook()
        let selectedComicbook = bookBinder.getSelectedComicbook()
        XCTAssertEqual(selectedComicbook.series.seriesURI.description, seriesURIStrings[1])
        
        bookBinder.selectNextComicbook()
        let selectedComicbook2 = bookBinder.getSelectedComicbook()
        XCTAssertEqual(selectedComicbook2.series.seriesURI.description, seriesURIStrings[0])
    }
    
    func testSelectPreviousComicbook() {
        let bookBinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 0)
        
        bookBinder.selectPreviousComicbook()
        let selectedComicbook = bookBinder.getSelectedComicbook()
        XCTAssertEqual(selectedComicbook.series.seriesURI.description, seriesURIStrings[1])
        
        bookBinder.selectPreviousComicbook()
        let selectedComicbook2 = bookBinder.getSelectedComicbook()
        XCTAssertEqual(selectedComicbook2.series.seriesURI.description, seriesURIStrings[0])
    }
    
    func testSelectNextIssue() {
        let bookbinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 1)
        
        bookbinder.selectNextIssue()
        let selectedIssue = bookbinder.getSelectedIssue()
        XCTAssertEqual(selectedIssue.bookURI.description, bookURIStrings[2])
        
        bookbinder.selectNextComicbook()
        let selectedComicbook = bookbinder.getSelectedComicbook()
        XCTAssertEqual(selectedComicbook.series.seriesURI.description, seriesURIStrings[1])

        var selectedIssue3: BookModel
        
        for i in 0...3 {
            selectedIssue3 = bookbinder.getSelectedIssue()
            XCTAssertEqual(selectedIssue3.bookURI.description, bookURIStrings[5 + i])
            bookbinder.selectNextIssue()
        }
        
    }
    
    func testSelectPreviousIssue() {
        let bookbinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 1)
        
        bookbinder.selectPreviousIssue()
        let selectedIssue = bookbinder.getSelectedIssue()
        XCTAssertEqual(selectedIssue.bookURI.description, bookURIStrings[0])
        
        bookbinder.selectPreviousComicbook()
        let selectedComicbook = bookbinder.getSelectedComicbook()
        XCTAssertEqual(selectedComicbook.series.seriesURI.description, seriesURIStrings[1])
        
        var selectedIssue3: BookModel
        bookbinder.selectedIssueIndex = 3
        
        for i in (0...3).reversed() {
            selectedIssue3 = bookbinder.getSelectedIssue()
            XCTAssertEqual(selectedIssue3.bookURI.description, bookURIStrings[5 + i])
            bookbinder.selectPreviousIssue()
        }
        
    }




}