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
        XCTAssertTrue(uri1.variantID == "v")
    }
    
    func testNoVariantURI() {
        let testString1 = "Ziff Davis/GI Joe/1950/10/"
        let uri1 = BookBinderURI(fromURIString: testString1)
        
        XCTAssertTrue(uri1.publisherID == "Ziff Davis")
        XCTAssertTrue(uri1.seriesID == "GI Joe")
        XCTAssertTrue(uri1.eraID == "1950")
        XCTAssertTrue(uri1.issueID == "10")
        XCTAssertTrue(uri1.variantID == "")
    }
    
    func testNoBookURI() {
        let testString1 = "DC/Superman/2005//"
        let uri1 = BookBinderURI(fromURIString: testString1)
        
        XCTAssertEqual(uri1.publisherID, "DC")
        XCTAssertEqual(uri1.seriesID, "Superman")
        XCTAssertEqual(uri1.eraID, "2005")
        XCTAssertEqual(uri1.issueID, "")
        XCTAssertEqual(uri1.variantID, "")
    }
    
    func testMissingPartsURI() {
        let testString1 = "Marvel Entertainment//2018/1/"
        let uri1 = BookBinderURI(fromURIString: testString1)
        
        XCTAssertTrue(uri1.publisherID == "Marvel Entertainment")
        XCTAssertTrue(uri1.seriesID == "")
        XCTAssertTrue(uri1.eraID == "2018")
        XCTAssertTrue(uri1.issueID == "1")
        XCTAssertTrue(uri1.variantID == "")
        XCTAssertEqual(uri1.description, testString1)
    }
    
    func testURIDescription() {
        let testString1 = "Marvel Comics Group/ROM Spaceknight/1983/43/"
        let uri1 = BookBinderURI(fromURIString: testString1)
        XCTAssertEqual(uri1.description, testString1)
    }
    
    func testEmptyURIDescription() {
        let testString1 = "////"
        let uri1 = BookBinderURI(fromURIString: testString1)
        XCTAssertEqual(uri1.description, testString1)
    }
    
    func testFullURIDescription() {
        let testString1 = "Publisher/Series/Era/Issue/variant"
        let uri1 = BookBinderURI(fromURIString: testString1)
        XCTAssertEqual(uri1.description, testString1)
    }
    
    func testPartFromURIString() {
        let testString1 = "Marvel Entertainment/DoctorStrange/2018/1/v"
        let testURI = BookBinderURI.init(fromURIString: testString1)
        
        let publisherPart = BookBinderURI.part(fromURIString: testString1, partID: .publisher)
        XCTAssertEqual(publisherPart, "Marvel Entertainment")
        XCTAssertEqual(publisherPart, testURI.publisherID)
        
        let seriesPart = BookBinderURI.part(fromURIString: testString1, partID: .series)
        XCTAssertEqual(seriesPart, "DoctorStrange")
        XCTAssertEqual(seriesPart, testURI.seriesID)
        
        let eraPart = BookBinderURI.part(fromURIString: testString1, partID: .era)
        XCTAssertEqual(eraPart, "2018")
        XCTAssertEqual(eraPart, testURI.eraID)

        let issuePart = BookBinderURI.part(fromURIString: testString1, partID: .issue)
        XCTAssertEqual(issuePart, "1")
        XCTAssertEqual(issuePart, testURI.issueID)
        
        let variantPart = BookBinderURI.part(fromURIString: testString1, partID: .variant)
        XCTAssertEqual(variantPart, "v")
        XCTAssertEqual(variantPart, testURI.variantID)
    }
    
    func testPartFromURIStringWithMissingParts() {
        let testString1 = "Marvel Entertainment//2018/1/"
        let testURI = BookBinderURI.init(fromURIString: testString1)
        
        let publisherPart = BookBinderURI.part(fromURIString: testString1, partID: .publisher)
        XCTAssertEqual(publisherPart, "Marvel Entertainment")
        XCTAssertEqual(publisherPart, testURI.publisherID)
        
        let seriesPart = BookBinderURI.part(fromURIString: testString1, partID: .series)
        XCTAssertEqual(seriesPart, "")
        XCTAssertEqual(seriesPart, testURI.seriesID)
        
        let eraPart = BookBinderURI.part(fromURIString: testString1, partID: .era)
        XCTAssertEqual(eraPart, "2018")
        XCTAssertEqual(eraPart, testURI.eraID)
        
        let issuePart = BookBinderURI.part(fromURIString: testString1, partID: .issue)
        XCTAssertEqual(issuePart, "1")
        XCTAssertEqual(issuePart, testURI.issueID)
        
        let variantPart = BookBinderURI.part(fromURIString: testString1, partID: .variant)
        XCTAssertEqual(variantPart, "")
        XCTAssertEqual(variantPart, testURI.variantID)
    }
    
    func testPartFromURIStringWrongURI() {
        let testString1 = "DC/Superman/2005//"
        
        let publisherPart = BookBinderURI.part(fromURIString: testString1, partID: .publisher)
        XCTAssertEqual(publisherPart, "DC")
        
        let seriesPart = BookBinderURI.part(fromURIString: testString1, partID: .series)
        XCTAssertEqual(seriesPart, "Superman")
        
        let eraPart = BookBinderURI.part(fromURIString: testString1, partID: .era)
        XCTAssertEqual(eraPart, "2005")
        
        let issuePart = BookBinderURI.part(fromURIString: testString1, partID: .issue)
        XCTAssertEqual(issuePart, "")
        
        let variantPart = BookBinderURI.part(fromURIString: testString1, partID: .variant)
        XCTAssertEqual(variantPart, "")
    }
    
    func testExtractSeriesURI() {
        let testString1 = "Marvel Entertainment/DoctorStrange/2018/1/v"
        let extractedURIString = BookBinderURI.extractSeriesURI(fromURIString: testString1)
        XCTAssertEqual(extractedURIString, "Marvel Entertainment/DoctorStrange/2018//")
        
        let testString2 = "/////"
        let extractedURIString2 = BookBinderURI.extractSeriesURI(fromURIString: testString2)
        XCTAssertEqual(extractedURIString2, "//")
    }

}
