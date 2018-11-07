//
//  JsonModelTests.swift
//  BookBinderLab1Tests
//
//  Created by John Pavley on 11/5/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class JsonModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitFromProperites() {
        let testVariant = JsonModel.JsonPublisher.JsonSeries.JsonVolume.JsonWork.JsonVariant(datePublished: "1/1/11", kind: "thing", printing: 1, letter: "a", coverID: "photo", dateCollected: "1/1/11", DateConsumed: "1/1/11")
        let testWork = JsonModel.JsonPublisher.JsonSeries.JsonVolume.JsonWork(number: 1, variants: [testVariant])
        let testVolume = JsonModel.JsonPublisher.JsonSeries.JsonVolume(kind: "thing", era: 1, number: 1, firstWorkNumber: 1, currentWorkNumber: 1, skippedWorkNumbers: [Int](), works: [testWork])
        let testSeries = JsonModel.JsonPublisher.JsonSeries(title: "series", characters: ["person"], volumes: [testVolume])
        let testPublisher = JsonModel.JsonPublisher(name: "publisher", series: [testSeries])
        let testModel = JsonModel(selectedURI: "1/publisher/series/1/1/a", publishers: [testPublisher])
        
        XCTAssertNotNil(testModel)
        XCTAssertEqual(testModel.publishers[0].name, "publisher")
        XCTAssertEqual(testModel.publishers.count, 1)
        XCTAssertEqual(testModel.publishers[0].series[0].title, "series")
        XCTAssertEqual(testModel.publishers[0].series[0].volumes[0].era, 1)
        XCTAssertEqual(testModel.publishers[0].series[0].volumes[0].works[0].number, 1)
        XCTAssertEqual(testModel.publishers[0].series[0].volumes[0].works[0].variants[0].letter, "a")
        XCTAssertEqual(testModel.selectedURI, "1/publisher/series/1/1/a")
        
        let testModelURI = BookBinderURI(from: testModel.selectedURI)
        XCTAssertNotNil(testModelURI)
    }
    
    /// This test shows how to load Json from a file in the Xcode project (bundle)
    func testInitFromJsonSchema() {
        if let path = Bundle.main.path(forResource: "schema", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                XCTAssertNotNil(data)
                
                do {
                    let decoder = JSONDecoder()
                    let jsonModel = try decoder.decode(JsonModel.self, from: data)
                    
                    // tests succeeding -> data loaded and decoded!
                    XCTAssertNotNil(jsonModel)
                    XCTAssertEqual(jsonModel.publishers.count, 1)
                    XCTAssertEqual(jsonModel.publishers[0].name, "")
                    XCTAssertEqual(jsonModel.publishers[0].series[0].title, "")
                    XCTAssertEqual(jsonModel.publishers[0].series[0].volumes[0].era, 0)
                    XCTAssertEqual(jsonModel.publishers[0].series[0].volumes[0].works[0].number, 0)
                    XCTAssertEqual(jsonModel.publishers[0].series[0].volumes[0].works[0].variants[0].letter, "")
                    XCTAssertEqual(jsonModel.selectedURI, "version-number/publisher-name/series-title/volume-era/work-number/variant-letter")
                    
                    let jsonModelURI = BookBinderURI(from: jsonModel.selectedURI)
                    XCTAssertNil(jsonModelURI)
                    
                } catch {
                    // tests failing -> can't decode!
                    XCTAssertNil(error)
                    print(error)
                }
                
            } catch {
                // test failing -> can't load data!
                XCTAssertNil(error)
                print(error)
            }
        }
    }
    
    /// This test shows how to load Json from a file in the Xcode project (bundle)
    func testInitFromJsonSample1() {
        if let path = Bundle.main.path(forResource: "sample1", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                XCTAssertNotNil(data)
                
                do {
                    let decoder = JSONDecoder()
                    let jsonModel = try decoder.decode(JsonModel.self, from: data)
                    
                    // tests succeeding -> data loaded and decoded!
                    XCTAssertNotNil(jsonModel)
                    XCTAssertEqual(jsonModel.publishers.count, 2)
                    XCTAssertEqual(jsonModel.publishers[0].name, "Marble Entertainment")
                    XCTAssertEqual(jsonModel.publishers[0].series.count, 2)
                    XCTAssertEqual(jsonModel.publishers[0].series[0].title, "The People Under The Chair")
                    XCTAssertEqual(jsonModel.publishers[0].series[0].volumes.count, 2)
                    XCTAssertEqual(jsonModel.publishers[0].series[0].volumes[0].era, 1950)
                    XCTAssertEqual(jsonModel.publishers[0].series[0].volumes[0].works.count, 2)
                    XCTAssertEqual(jsonModel.publishers[0].series[0].volumes[0].works[0].number, 1)
                    XCTAssertEqual(jsonModel.publishers[0].series[0].volumes[0].works[0].variants.count, 1)
                    XCTAssertEqual(jsonModel.publishers[0].series[0].volumes[0].works[0].variants[0].letter, "")
                    XCTAssertEqual(jsonModel.selectedURI, "1/Marble Entertainment/The People Under The Chair/1950/3/b")
                    
                    let jsonModelURI = BookBinderURI(from: jsonModel.selectedURI)
                    XCTAssertNotNil(jsonModelURI)
                    
                } catch {
                    // tests failing -> can't decode!
                    XCTAssertNil(error)
                    print(error)
                }
                
            } catch {
                // test failing -> can't load data!
                XCTAssertNil(error)
                print(error)
            }
        }
    }
}
