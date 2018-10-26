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
        let testString1 = "Marvel Entertainment/DoctorStrange/2018/1/1/1/v"
        let uri1 = BookBinderURI(fromURIString: testString1)
        
        XCTAssertEqual(uri1!.publisherPart, "Marvel Entertainment")
        XCTAssertEqual(uri1!.titlePart, "DoctorStrange")
        XCTAssertEqual(uri1!.eraPart, "2018")
        XCTAssertEqual(uri1!.volumePart, "1")
        XCTAssertEqual(uri1!.printingPart, "1")
        XCTAssertEqual(uri1!.issuePart, "1")
        XCTAssertEqual(uri1!.variantPart, "v")
    }
    
    func testNoVariantURI() {
        let testString1 = "Ziff Davis/GI Joe/1950/1//10/"
        let uri1 = BookBinderURI(fromURIString: testString1)
        
        XCTAssertTrue(uri1!.publisherPart == "Ziff Davis")
        XCTAssertTrue(uri1!.titlePart == "GI Joe")
        XCTAssertTrue(uri1!.eraPart == "1950")
        XCTAssertTrue(uri1!.issuePart == "10")
        XCTAssertTrue(uri1!.variantPart == "")
    }
    
    func testNoBookURI() {
        let testString1 = "DC/Superman/2005/1///"
        let uri1 = BookBinderURI(fromURIString: testString1)
        
        XCTAssertEqual(uri1!.publisherPart, "DC")
        XCTAssertEqual(uri1!.titlePart, "Superman")
        XCTAssertEqual(uri1!.eraPart, "2005")
        XCTAssertEqual(uri1!.issuePart, "")
        XCTAssertEqual(uri1!.variantPart, "")
    }
    
    func testMissingPartsURI() {
        let testString1 = "Marvel Entertainment//2018/1/1/1/"
        let uri1 = BookBinderURI(fromURIString: testString1)
        
        XCTAssertTrue(uri1!.publisherPart == "Marvel Entertainment")
        XCTAssertTrue(uri1!.titlePart == "")
        XCTAssertTrue(uri1!.eraPart == "2018")
        XCTAssertTrue(uri1!.issuePart == "1")
        XCTAssertTrue(uri1!.variantPart == "")
        XCTAssertEqual(uri1!.description, testString1)
    }
    
    func testURIDescription() {
        let testString1 = "Marvel Comics Group/ROM Spaceknight/1983/1/1/43/a"
        let uri1 = BookBinderURI(fromURIString: testString1)
        XCTAssertEqual(uri1!.description, testString1)
    }
    
    func testEmptyURIDescription() {
        let testString1 = BookBinderURI.emptyURIString
        let uri1 = BookBinderURI(fromURIString: testString1)
        XCTAssertEqual(uri1!.description, testString1)
    }
    
    func testFullURIDescription() {
        let testString1 = "Publisher/Series/Era/Volume/Printing/Issue/variant"
        let uri1 = BookBinderURI(fromURIString: testString1)
        XCTAssertEqual(uri1!.description, testString1)
    }
    
    func testPartFromURIString() {
        let testString1 = "Marvel Entertainment/DoctorStrange/2018/1/1/1/v"
        let testURI = BookBinderURI.init(fromURIString: testString1)
        
        let publisherPart = BookBinderURI.part(fromURIString: testString1, partID: .publisher)
        XCTAssertEqual(publisherPart, "Marvel Entertainment")
        XCTAssertEqual(publisherPart, testURI!.publisherPart)
        
        let seriesPart = BookBinderURI.part(fromURIString: testString1, partID: .title)
        XCTAssertEqual(seriesPart, "DoctorStrange")
        XCTAssertEqual(seriesPart, testURI!.titlePart)
        
        let eraPart = BookBinderURI.part(fromURIString: testString1, partID: .era)
        XCTAssertEqual(eraPart, "2018")
        XCTAssertEqual(eraPart, testURI!.eraPart)

        let issuePart = BookBinderURI.part(fromURIString: testString1, partID: .issue)
        XCTAssertEqual(issuePart, "1")
        XCTAssertEqual(issuePart, testURI!.issuePart)
        
        let variantPart = BookBinderURI.part(fromURIString: testString1, partID: .variant)
        XCTAssertEqual(variantPart, "v")
        XCTAssertEqual(variantPart, testURI!.variantPart)
    }
    
    func testPartFromURIStringWithMissingParts() {
        let testString1 = "Marvel Entertainment//2018///1/"
        let testURI = BookBinderURI.init(fromURIString: testString1)
        
        let publisherPart = BookBinderURI.part(fromURIString: testString1, partID: .publisher)
        XCTAssertEqual(publisherPart, "Marvel Entertainment")
        XCTAssertEqual(publisherPart, testURI!.publisherPart)
        
        let seriesPart = BookBinderURI.part(fromURIString: testString1, partID: .title)
        XCTAssertEqual(seriesPart, "")
        XCTAssertEqual(seriesPart, testURI!.titlePart)
        
        let eraPart = BookBinderURI.part(fromURIString: testString1, partID: .era)
        XCTAssertEqual(eraPart, "2018")
        XCTAssertEqual(eraPart, testURI!.eraPart)
        
        let issuePart = BookBinderURI.part(fromURIString: testString1, partID: .issue)
        XCTAssertEqual(issuePart, "1")
        XCTAssertEqual(issuePart, testURI!.issuePart)
        
        let variantPart = BookBinderURI.part(fromURIString: testString1, partID: .variant)
        XCTAssertEqual(variantPart, "")
        XCTAssertEqual(variantPart, testURI!.variantPart)
    }
    
    func testPartFromURIStringWrongURI() {
        let testString1 = "DC/Superman/2005/1///"
        
        let publisherPart = BookBinderURI.part(fromURIString: testString1, partID: .publisher)
        XCTAssertEqual(publisherPart, "DC")
        
        let seriesPart = BookBinderURI.part(fromURIString: testString1, partID: .title)
        XCTAssertEqual(seriesPart, "Superman")
        
        let eraPart = BookBinderURI.part(fromURIString: testString1, partID: .era)
        XCTAssertEqual(eraPart, "2005")
        
        let issuePart = BookBinderURI.part(fromURIString: testString1, partID: .issue)
        XCTAssertEqual(issuePart, "")
        
        let variantPart = BookBinderURI.part(fromURIString: testString1, partID: .variant)
        XCTAssertEqual(variantPart, "")
    }
    
    func testExtractSeriesURI() {
        let testString1 = "Marvel Entertainment/DoctorStrange/2018/1/1/1/v"
        let extractedURIString = BookBinderURI.extractSeriesURI(fromURIString: testString1)
        XCTAssertEqual(extractedURIString, "Marvel Entertainment/DoctorStrange/2018/1///")
        
        let testString2 = BookBinderURI.emptyURIString
        let extractedURIString2 = BookBinderURI.extractSeriesURI(fromURIString: testString2)
        XCTAssertEqual(extractedURIString2, "//////")
    }
    
    func testSeriesPart() {
        
        let testString1 = "Marvel Entertainment/DoctorStrange/2018/1/1/1/v"
        let uri = BookBinderURI(fromURIString: testString1)
        let seriesPart = uri?.seriesPart
        XCTAssertEqual(seriesPart?.description, "Marvel Entertainment/DoctorStrange/2018/1///")
        
        let extractedURIString = BookBinderURI.extractSeriesURI(fromURIString: testString1)
        XCTAssertEqual(seriesPart?.description, extractedURIString)

    }

}
