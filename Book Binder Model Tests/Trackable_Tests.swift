//
//  Trackable_Tests.swift
//  Book Binder Model Tests
//
//  Created by John Pavley on 10/21/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class Trackable_Tests: XCTestCase {
    
    class TestObject: Trackable {
        var uri: BookBinderURI
        var tags: Set<String>
        var dateStamp: Date
        var guid: UUID
        
        var description: String {
            return ""
        }
        
        var debugDescription: String {
            return ""
        }
        
        static func == (lhs: Trackable_Tests.TestObject, rhs: Trackable_Tests.TestObject) -> Bool {
            return lhs.uri == rhs.uri
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(guid)
        }
        
        init() {
            uri = BookBinderURI(fromURIString: BookBinderURI.emptyURIString)!
            tags = []
            dateStamp = Date()
            guid = UUID()
        }
        
        convenience init(uri: BookBinderURI) {
            self.init()
            self.uri = uri
        }
    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateTrackableObject() {
        let testObject = TestObject()
        XCTAssertNotNil(testObject)
    }
    
    func testCreateFromUIR() {
        let testURI = BookBinderURI(fromURIString: "a/b/c/d/e/f/g")
        let testObject = TestObject(uri: testURI!)
        
        XCTAssertNotNil(testObject)
        XCTAssertEqual(testObject.uri, testURI)
    }
    
    func testTags() {
        let testURI = BookBinderURI(fromURIString: "a/b/c/d/e/f/g")
        let testObject = TestObject(uri: testURI!)
        let testTag1 = "cat"
        let testTag2 = "dog"
        let testTag3 = "cat"
        
        testObject.tags.insert(testTag1)
        testObject.tags.insert(testTag2)
        
        XCTAssertEqual(testObject.tags.count, 2)
        XCTAssertEqual(testObject.tags.contains(testTag1), true)
        XCTAssertEqual(testObject.tags.contains(testTag2), true)
        
        
        testObject.tags.insert(testTag3)
        XCTAssertEqual(testObject.tags.count, 2)
        XCTAssertEqual(testObject.tags.contains(testTag1), true)
        XCTAssertEqual(testObject.tags.contains(testTag2), true)
    }
    
    func testDateStamp() {
        let testURI = BookBinderURI(fromURIString: "a/b/c/d/e/f/g")
        let testObject = TestObject(uri: testURI!)
        
        XCTAssertNotNil(testObject.dateStamp)
        print("testObject.dateStamp \(testObject.dateStamp)")
    }
    
    func testGuid() {
        let testURI = BookBinderURI(fromURIString: "a/b/c/d/e/f/g")
        let testObject = TestObject(uri: testURI!)
        
        XCTAssertNotNil(testObject.guid)
        print("testObject.guid \(testObject.guid)")
    }
    
    func testHashing() {
        let testURI1 = BookBinderURI(fromURIString: "a/b/c/d/e/f/g")
        let testURI2 = BookBinderURI(fromURIString: "a/b/c/d/e/f/h")
        
        let testObject1 = TestObject(uri: testURI1!)
        let testObject2 = TestObject(uri: testURI2!)
        let testObject3 = TestObject(uri: testURI2!)
        
        XCTAssertNotEqual(testObject1 == testObject2, true)
        XCTAssertEqual(testObject2 == testObject3, true)
    }
    
    
}
