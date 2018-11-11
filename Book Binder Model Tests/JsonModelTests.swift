//
//  JsonModelTests.swift
//  BookBinderLab2Tests
//
//  Created by John Pavley on 11/9/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class JsonModelTests: XCTestCase {
    
    // proptery based
    
    var testWork1: JsonModel.JsonVolume.JsonWork!
    var testWork2: JsonModel.JsonVolume.JsonWork!
    var testWork3: JsonModel.JsonVolume.JsonWork!
    
    var testVolume1: JsonModel.JsonVolume!
    var testVolume2: JsonModel.JsonVolume!
    var testVolume3: JsonModel.JsonVolume!

    var testModel1: JsonModel!
    
    // bundle based
    
    var testModel2: JsonModel!
    
    // ser defaults
    
    let defaultsKey = "savedJsonModel"
    
    private func initFromProperties() {
        testWork1 = JsonModel.JsonVolume.JsonWork(issueNumber: 1, variantLetter: "a", coverImage: "x", isOwned: true)
        testWork2 = JsonModel.JsonVolume.JsonWork(issueNumber: 2, variantLetter: "b", coverImage: "y", isOwned: false)
        testWork3 = JsonModel.JsonVolume.JsonWork(issueNumber: 3, variantLetter: "c", coverImage: "z", isOwned: true)
        
        testVolume1 = JsonModel.JsonVolume(publisherName: "a", seriesName: "x", era: 1, volumeNumber: 4, firstWorkNumber: 1, currentWorkNumber: 5, kind: "series", works: [testWork1, testWork2, testWork3], selectedWorkIndex: 0)
        testVolume2 = JsonModel.JsonVolume(publisherName: "b", seriesName: "y", era: 2, volumeNumber: 5, firstWorkNumber: 1, currentWorkNumber: 10, kind: "one-shot", works: [testWork1, testWork2, testWork3], selectedWorkIndex: 0)
        testVolume3 = JsonModel.JsonVolume(publisherName: "c", seriesName: "z", era: 3, volumeNumber: 6, firstWorkNumber: 1, currentWorkNumber: 15, kind: "annual", works: [testWork1, testWork2, testWork3], selectedWorkIndex: 0)
        
        testModel1 = JsonModel(volumes: [testVolume1, testVolume2, testVolume3], selectedVolumeIndex: 0)
    }
    
    
    
    /// Creates a JsonModel from a JSON resouce in the application bundle.
    ///
    /// - Parameters:
    ///   - forResource: Name of the JSON file.
    ///   - ofType: Type of the JSON file.
    ///
    /// - Returns: Nil or a JsonModel object.
    private func initFromBundle(forResource: String, ofType: String) -> JsonModel? {
        if let path = Bundle.main.path(forResource: forResource, ofType: ofType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(JsonModel.self, from: data)
                    
                } catch {
                    print(error)
                    return nil
                }
                
            } catch {
                print(error)
                return nil
            }
        } else {
            print("no resource named \(forResource) of type \(ofType) in path")
            return nil
        }
    }
    
    /// Deletes data associated with a key from local phone storage.
    ///
    /// - Parameter key: Name of the key assocated with the data.
    private func deleteUserDefaults(for key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaults.synchronize()
    }
    
    
    /// Saves a JsonModel to local phone storage associated with a key.
    ///
    /// - Parameters:
    ///   - key: Name of the key assocated with the data.
    ///   - model: The JSON object to save.
    private func saveUserDefaults(for key: String, with model: JsonModel) {
        let defaults = UserDefaults.standard
        
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(model)

            defaults.set(encoded, forKey: key)

        } catch {
            print(error)
        }
    }
    
    /// Reads data from local phone storage associated with a key and returns a JsonModel object.
    ///
    /// - Parameter key: Name of the key assocated with the data.
    /// - Returns: Nil or the JSON object read from storage.
    private func readUserDefaults(for key: String) -> JsonModel? {
        let defaults = UserDefaults.standard
        
        do {
            
            if let savedJsonModel = defaults.object(forKey: key) as? Data {
                
                let decoder = JSONDecoder()
                return try decoder.decode(JsonModel.self, from: savedJsonModel)

            } else {
                print("no data for key in user defaults")
                return nil
            }
            
        } catch {
            print(error)
            return nil
        }

    }

    override func setUp() {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        initFromProperties()
        testModel2 = initFromBundle(forResource: "sample1", ofType: "json")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        deleteUserDefaults(for: defaultsKey)
    }

    func testInitFromPropterties() {
        
        XCTAssertNotNil(testWork1)
        XCTAssertNotNil(testWork2)
        XCTAssertNotNil(testWork3)
        
        XCTAssertNotNil(testVolume1)
        XCTAssertNotNil(testVolume2)
        XCTAssertNotNil(testVolume3)
        
        XCTAssertNotNil(testModel1)
        
        XCTAssertEqual(testModel1.volumes.count, 3)
        XCTAssertEqual(testModel1.selectedVolumeIndex, 0)
        
        XCTAssertEqual(testModel1.volumes[testModel1.selectedVolumeIndex].volumeNumber, 4)
        XCTAssertEqual(testModel1.volumes[testModel1.selectedVolumeIndex].era, 1)
        XCTAssertEqual(testModel1.volumes[testModel1.selectedVolumeIndex].publisherName, "a")
        XCTAssertEqual(testModel1.volumes[testModel1.selectedVolumeIndex].works.count, 3)
        
        XCTAssertEqual(testModel1.volumes[testModel1.selectedVolumeIndex].works[testModel1.volumes[testModel1.selectedVolumeIndex].selectedWorkIndex].issueNumber, 1)
        XCTAssertEqual(testModel1.volumes[testModel1.selectedVolumeIndex].works[testModel1.volumes[testModel1.selectedVolumeIndex].selectedWorkIndex].variantLetter, "a")
        XCTAssertEqual(testModel1.volumes[testModel1.selectedVolumeIndex].works[testModel1.volumes[testModel1.selectedVolumeIndex].selectedWorkIndex].isOwned, true)
    }
    
    func testInitFromBundle() {
        XCTAssertNotNil(testModel2)
        
        XCTAssertEqual(testModel2.selectedVolume.publisherName, "Marble Entertainment")
        XCTAssertEqual(testModel2.selectedCollectedWork.issueNumber, 1)
        
        testModel2.selectedVolumeIndex = 3
        XCTAssertEqual(testModel2.selectedVolume.publisherName, "EKK Comics")
        XCTAssertEqual(testModel2.selectedCollectedWork.isOwned, true)
        
        testModel2.selectedVolume.selectedWorkIndex = 1
        XCTAssertEqual(testModel2.selectedCollectedWork.variantLetter, "a")
        
        testModel2.selectedVolumeIndex = 5
        XCTAssertEqual(testModel2.selectedVolume.seriesName, "Darling Dog")
        XCTAssertEqual(testModel2.selectedVolume.era, 1952)
        XCTAssertEqual(testModel2.selectedVolume.volumeNumber, 2)
        XCTAssertEqual(testModel2.selectedVolume.firstWorkNumber, 7)
        XCTAssertEqual(testModel2.selectedVolume.kind, "annual")
        XCTAssertEqual(testModel2.selectedVolume.selectedWorkIndex, 0)
        
        let issueList = [9, 11]
        let variantList = ["", "a"]
        let imageList = ["american-standard-ga", "american-standard-ga"]
        let ownList = [true, false]
        
        for i in 0..<testModel2.selectedVolume.works.count {
            testModel2.selectedVolume.selectedWorkIndex = i
            
            XCTAssertEqual(testModel2.selectedCollectedWork.issueNumber, issueList[i])
            XCTAssertEqual(testModel2.selectedCollectedWork.variantLetter, variantList[i])
            XCTAssertEqual(testModel2.selectedCollectedWork.coverImage, imageList[i])
            XCTAssertEqual(testModel2.selectedCollectedWork.isOwned, ownList[i])
        }

    }
    
    func testSelectionShortCutsPropertyInit() {
        XCTAssertEqual(testModel1.selectedVolume.volumeNumber, 4)
        XCTAssertEqual(testModel1.selectedVolume.era, 1)
        XCTAssertEqual(testModel1.selectedVolume.publisherName, "a")
        XCTAssertEqual(testModel1.selectedVolume.works.count, 3)
        
        XCTAssertEqual(testModel1.selectedCollectedWork.issueNumber, 1)
        XCTAssertEqual(testModel1.selectedCollectedWork.variantLetter, "a")
        XCTAssertEqual(testModel1.selectedCollectedWork.isOwned, true)
    }
    
    func testSaveAndLoadUserDefaults() {
        let defaults = UserDefaults.standard
        
        // no old data in user defaults
        let oldSavedData = defaults.object(forKey: defaultsKey)
        XCTAssertNil(oldSavedData)
        
        // orignal data is in model
        testModel2.selectedVolumeIndex = 5
        XCTAssertEqual(testModel2.selectedVolume.seriesName, "Darling Dog")
        XCTAssertEqual(testModel2.selectedVolume.era, 1952)

        saveUserDefaults(for: defaultsKey, with: testModel2)
        
        // something was saved
        let newSavedData = defaults.object(forKey: defaultsKey)
        XCTAssertNotNil(newSavedData)
        
        testModel2 = readUserDefaults(for: defaultsKey)
        // make user loaded data is same as saved data
        testModel2.selectedVolumeIndex = 5
        XCTAssertEqual(testModel2.selectedVolume.seriesName, "Darling Dog")
        XCTAssertEqual(testModel2.selectedVolume.era, 1952)

        
        // make changes
        testModel2.selectedVolume.seriesName = "Horrible Ugly Misrable Dog"
        testModel2.selectedVolume.era = 1992
        
        saveUserDefaults(for: defaultsKey, with: testModel2)
        testModel2 = readUserDefaults(for: defaultsKey)
        
        // see if loaded data refects changes
        XCTAssertEqual(testModel2.selectedVolume.seriesName, "Horrible Ugly Misrable Dog")
        XCTAssertEqual(testModel2.selectedVolume.era, 1992)
    }

    func testPublishedWorks() {
        let publishedWorks = testModel2.selectedVolumePublishedWorkIDs
        XCTAssertEqual(publishedWorks.count, 10)
        XCTAssertEqual(publishedWorks.first!, "1")
        XCTAssertEqual(publishedWorks.last!, "10")
    }
    
    func testCollectedWorks() {
        let collectedWorks = testModel2.selectedVolumeCollectedWorkIDs
        XCTAssertEqual(collectedWorks.count, 5)
        XCTAssertEqual(collectedWorks.first!, "1")
        XCTAssertEqual(collectedWorks.last!, "8b")
    }
    
    func testCompleteWorks() {
        let completeWorks = testModel2.completeWorks
        XCTAssertEqual(completeWorks.count, 13)
        XCTAssertEqual(completeWorks, ["1", "1a", "1b", "2", "3", "4", "5", "6", "7", "8", "8b", "9", "10"])
        print(completeWorks)
    }
    
    func testSelectedWork() {
        testModel2.selectedVolumeIndex = 1
        
        let issueList = [5, 6, 7, 8, 9, 10, 11, 11, 12, 12, 13, 13, 14, 15]
        let variantList = ["", "", "", "", "", "", "", "a", "", "b", "", "b", "", ""]
        let imageList = ["american-standard-dc",        // [0] 5
                         "american-standard-dc",        // [1] 6
                         "american-standard-dc",        // [2] 7
                         "american-standard-dc",        // [3] 8
                         "american-standard-dc",        // [4] 9
                         "american-standard-marvel",    // [5] 10 isOwned
                         "american-standard-dc",        // [6] 11
                         "american-standard-marvel",    // [7] 11a isOwned
                         "american-standard-dc",        // [8] 12
                         "american-standard-marvel",    // [9] 12b
                         "american-standard-marvel",    // [10] 13
                         "american-standard-marvel",    // [11] 13b isOwned
                         "american-standard-dc",        // [12] 14
                         "american-standard-dc"         // [13] 15
        ]
        let ownList = [false, false, false, false, false, true, false, true, false, false, false, true, false, false]

        
        for i in 0..<testModel2.completeWorks.count {
            testModel2.selectedVolume.selectedWorkIndex = i
            
            XCTAssertEqual(testModel2.selectedWork.issueNumber, issueList[i])
            XCTAssertEqual(testModel2.selectedWork.variantLetter, variantList[i])
            XCTAssertEqual(testModel2.selectedWork.coverImage, imageList[i])
            XCTAssertEqual(testModel2.selectedWork.isOwned, ownList[i])
            
        }
    }
}
