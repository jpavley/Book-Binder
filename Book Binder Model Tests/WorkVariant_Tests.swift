//
//  WorkVariant_Tests.swift
//  Book Binder Model Tests
//
//  Created by John Pavley on 10/27/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class WorkVariant_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateComicBookVariant() {
        let comicBookVariant = WorkVarient(printing: 1, letter: "a", coverImageID: "x-men-101", isOwned: true)
        
        XCTAssertNotNil(comicBookVariant)
        XCTAssertEqual(comicBookVariant.printing, 1)
        XCTAssertEqual(comicBookVariant.letter, "a")
        XCTAssertEqual(comicBookVariant.coverImageID, "x-men-101")
        XCTAssertEqual(comicBookVariant.isOwned, true)
    }


}
