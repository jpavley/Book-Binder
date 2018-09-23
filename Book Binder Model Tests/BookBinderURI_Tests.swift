//
//  BookBinderURI_Tests.swift
//  Book Binder URI Tests
//
//  Created by John Pavley on 9/23/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class BookBinderURI_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCompleteURI() {
        let testString1 = "Marvel Entertainment/DoctorStrange/2018/1/v"
        let uri1 = BookBinderURI(fromURIString: testString1)
        
        XCTAssertTrue(uri1.publisherID == "Marvel Entertainment")
        XCTAssertTrue(uri1.seriesID == "DoctorStrange")
        XCTAssertTrue(uri1.eraID == "2018")
        XCTAssertTrue(uri1.issueID == "1")
        XCTAssertTrue(uri1.varientID == "v")
    }
    
    func testNoVarientURI() {
        let testString1 = "Ziff Davis/GI Joe/1950/10"
        let uri1 = BookBinderURI(fromURIString: testString1)
        
        XCTAssertTrue(uri1.publisherID == "Ziff Davis")
        XCTAssertTrue(uri1.seriesID == "GI Joe")
        XCTAssertTrue(uri1.eraID == "1950")
        XCTAssertTrue(uri1.issueID == "10")
        XCTAssertTrue(uri1.varientID == "")
    }
    
    func testNoSeriesURI() {
        let testString1 = "DC/Superman/2005"
        let uri1 = BookBinderURI(fromURIString: testString1)
        
        XCTAssertTrue(uri1.publisherID == "DC")
        XCTAssertTrue(uri1.seriesID == "Superman")
        XCTAssertTrue(uri1.eraID == "2005")
        XCTAssertTrue(uri1.issueID == "")
        XCTAssertTrue(uri1.varientID == "")
    }
    
    func testURIDescription() {
        let testString1 = "Marvel Comics Group/ROM Spaceknight/1983/43"
        let uri1 = BookBinderURI(fromURIString: testString1)
        XCTAssertTrue(uri1.description == testString1)
    }


}
