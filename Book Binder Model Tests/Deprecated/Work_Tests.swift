//
//  Work_Tests.swift
//  Book Binder Model Tests
//
//  Created by John Pavley on 9/24/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class Work_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateBookModelFromProperies() {
        let testString1 = "Marvel Entertainment/Doctor Strange/2018/1///"
        let seriesURI = BookBinderURI(fromURIString: testString1)
        let workVariant = WorkVarient(printing: 1, letter: "a", coverImageID: "x-men-101", isOwned: true)
        let work = Work(seriesURI: seriesURI!, issueNumber: 1, variants: [workVariant])
        
        XCTAssertEqual(work.seriesURI.description, testString1)
        XCTAssertEqual(work.issueNumber, 1)
        XCTAssertEqual(work.variants.count, 1)
        XCTAssertEqual(work.defaultVariant.letter, work.variants[0].letter)
        XCTAssertEqual(work.defaultVariant.letter, "a")
        XCTAssertEqual(work.defaultVariant.isOwned, true)
        XCTAssertEqual(work.defaultVariant.coverImageID, "x-men-101")

    }
    
    func testCreateBookModelFromURI() {
        let testString1 = "Marvel Entertainment/DoctorStrange/2018/1/1/1/v"
        let bookURI = BookBinderURI(fromURIString: testString1)
        let work = Work(fromURI: bookURI!, isOwned: true, coverImageID: "x-men-101")
        
        XCTAssertEqual(work.uri.description, testString1)
        XCTAssertEqual(work.issueNumber, 1)
        XCTAssertEqual(work.variants.count, 1)
        XCTAssertEqual(work.defaultVariant.letter, work.variants[0].letter)
        XCTAssertEqual(work.defaultVariant.letter, "v")
        XCTAssertEqual(work.defaultVariant.printing, 1)
        XCTAssertEqual(work.defaultVariant.isOwned, true)
        XCTAssertEqual(work.defaultVariant.coverImageID, "x-men-101")
    }
    
    func testComputedProperties() {
        let testString1 = "Marvel Entertainment/Doctor Strange/2018/1///"
        let seriesURI = BookBinderURI(fromURIString: testString1)
        let workVariant = WorkVarient(printing: 1, letter: "a", coverImageID: "x-men-101", isOwned: true)
        let work = Work(seriesURI: seriesURI!, issueNumber: 1, variants: [workVariant])
        let testString2 = "Marvel Entertainment/Doctor Strange/2018/1/1/1/a"
        
        XCTAssertEqual(work.uri.description, testString2)
        XCTAssertEqual(work.bookPublisher, "Marvel Entertainment")
        XCTAssertEqual(work.bookTitle, "Doctor Strange")
        XCTAssertEqual(work.bookEra, "2018")
        XCTAssertEqual(work.anyOwned.count, 1)
        XCTAssertEqual(work.defaultVariant.letter, "a")
    }
}
