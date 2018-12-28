//
//  JsonModelTests.swift
//  BookBinderLab2Tests
//
//  Created by John Pavley on 11/9/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest
@testable import Book_Binder

class JsonModelTests: XCTestCase {
    
    // MARK:- Setup data and objects for testing
    
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
        
        testVolume1 = JsonModel.JsonVolume(publisherName: "a", seriesName: "x", era: 1, volumeNumber: 4, kind: "series", works: [testWork1, testWork2, testWork3], defaultCoverID: "e", selectedWorkIndex: 0)
        testVolume2 = JsonModel.JsonVolume(publisherName: "b", seriesName: "y", era: 2, volumeNumber: 5, kind: "one-shot", works: [testWork1, testWork2, testWork3], defaultCoverID: "e", selectedWorkIndex: 0)
        testVolume3 = JsonModel.JsonVolume(publisherName: "c", seriesName: "z", era: 3, volumeNumber: 6, kind: "annual", works: [testWork1, testWork2, testWork3], defaultCoverID: "e", selectedWorkIndex: 0)
        
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
    
    // MARK:- Test object creation

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
        XCTAssertEqual(testModel1.volumes[testModel1.selectedVolumeIndex].defaultCoverID, "e")

        XCTAssertEqual(testModel1.volumes[testModel1.selectedVolumeIndex].works[testModel1.volumes[testModel1.selectedVolumeIndex].selectedWorkIndex].issueNumber, 1)
        XCTAssertEqual(testModel1.volumes[testModel1.selectedVolumeIndex].works[testModel1.volumes[testModel1.selectedVolumeIndex].selectedWorkIndex].variantLetter, "a")
        XCTAssertEqual(testModel1.volumes[testModel1.selectedVolumeIndex].works[testModel1.volumes[testModel1.selectedVolumeIndex].selectedWorkIndex].isOwned, true)
    }
    
    func testInitFromBundle() {
        XCTAssertNotNil(testModel2)
        
        XCTAssertEqual(testModel2.selectedVolume.publisherName, "Marble Entertainment")
        XCTAssertEqual(testModel2.selectedVolumeSelectedWork.issueNumber, 1)
        
        XCTAssertEqual(testModel2.selectedVolume.defaultCoverID, "american-standard-marvel")

        
        testModel2.selectedVolumeIndex = 3
        XCTAssertEqual(testModel2.selectedVolume.publisherName, "EKK Comics")
        XCTAssertEqual(testModel2.selectedVolumeSelectedWork.isOwned, true)
        
        testModel2.selectedVolume.selectedWorkIndex = 1
        XCTAssertEqual(testModel2.selectedVolumeSelectedWork.variantLetter, "b")
        
        testModel2.selectedVolumeIndex = 5
        XCTAssertEqual(testModel2.selectedVolume.seriesName, "Darling Dog")
        XCTAssertEqual(testModel2.selectedVolume.era, 1952)
        XCTAssertEqual(testModel2.selectedVolume.volumeNumber, 2)
        XCTAssertEqual(testModel2.selectedVolume.kind, "annual")
        XCTAssertEqual(testModel2.selectedVolume.selectedWorkIndex, 0)
        
        let issueList = [7, 8, 9, 10, 11, 12]
        let variantList = ["", "b", "", "", "a", ""]
        let imageList = ["american-standard-ga", "american-standard-ga", "american-standard-ga", "american-standard-ga", "american-standard-ga", "american-standard-ga"]
        let ownList = [false, true, true, false, false, false]
        
        for i in 0..<testModel2.selectedVolume.works.count {
            testModel2.selectedVolume.selectedWorkIndex = i
            
            XCTAssertEqual(testModel2.selectedVolumeSelectedWork.issueNumber, issueList[i])
            XCTAssertEqual(testModel2.selectedVolumeSelectedWork.variantLetter, variantList[i])
            XCTAssertEqual(testModel2.selectedVolumeSelectedWork.coverImage, imageList[i])
            XCTAssertEqual(testModel2.selectedVolumeSelectedWork.isOwned, ownList[i])
        }
    }
    
    // MARK:- serialization and deserialization
    
    
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
    
    // MARK:- computed properties
    
    func testSelectedVolume() {
        XCTAssertEqual(testModel1.selectedVolume.volumeNumber, 4)
        XCTAssertEqual(testModel1.selectedVolume.era, 1)
        XCTAssertEqual(testModel1.selectedVolume.publisherName, "a")
        XCTAssertEqual(testModel1.selectedVolume.works.count, 3)
    }
    
    func testSelectedVolumeSelectedCollectedWork() {
        XCTAssertEqual(testModel1.selectedVolumeSelectedWork.issueNumber, 1)
        XCTAssertEqual(testModel1.selectedVolumeSelectedWork.variantLetter, "a")
        XCTAssertEqual(testModel1.selectedVolumeSelectedWork.isOwned, true)
    }
    
    func testSelectedVolumeSelectedWork1() {
        
        testModel2.selectedVolume.selectedWorkIndex = 2
        
        XCTAssertEqual(testModel2.selectedVolumeSelectedWork.issueNumber, 2)
        XCTAssertEqual(testModel2.selectedVolumeSelectedWork.variantLetter, "")
        XCTAssertEqual(testModel2.selectedVolumeSelectedWork.coverImage, "american-standard-marvel")
        XCTAssertEqual(testModel2.selectedVolumeSelectedWork.isOwned, false)
    }
    
    func testSelectedVolumeSelectedWork2() {
        testModel2.selectedVolumeIndex = 1
        
        let issueList = [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        let variantList = ["", "", "", "", "", "", "a", "b", "b", "", ""]
        let imageList = ["american-standard-marvel",        // [0] 5
            "american-standard-marvel",        // [1] 6
            "american-standard-marvel",        // [2] 7
            "american-standard-marvel",        // [3] 8
            "american-standard-marvel",        // [4] 9
            "american-standard-marvel",    // [5] 10 isOwned
            "american-standard-marvel",        // [6] 11a isOWned
            "american-standard-marvel",        // [8] 12b
            "american-standard-marvel",    // [11] 13b isOwned
            "american-standard-marvel",        // [12] 14
            "american-standard-marvel"         // [13] 15
        ]
        let ownList = [false, false, false, false, false, true, true, false, true, false, false]
        
        
        for i in 0..<testModel2.selectedVolumeCollectedWorkIDs.count {
            testModel2.selectedVolume.selectedWorkIndex = i
            
            XCTAssertEqual(testModel2.selectedVolumeSelectedWork.issueNumber, issueList[i])
            XCTAssertEqual(testModel2.selectedVolumeSelectedWork.variantLetter, variantList[i])
            XCTAssertEqual(testModel2.selectedVolumeSelectedWork.coverImage, imageList[i])
            XCTAssertEqual(testModel2.selectedVolumeSelectedWork.isOwned, ownList[i])
            
        }
    }

    
    func testSelectedVolumeWorksCount() {
        
        let workCounts = [11, 11, 9, 3, 6, 6]
        
        for i in 0..<testModel1.volumes.count {
            testModel2.selectedVolumeIndex = i
            XCTAssertEqual(testModel2.selectedVolumeWorksCount, workCounts[i])
        }
    }
    
    func testSelectedVolumeCollectedWorkIDs() {
        let collectedWorks = testModel2.selectedVolumeCollectedWorkIDs
        XCTAssertEqual(collectedWorks.count, 11)
        XCTAssertEqual(collectedWorks.first!, "1a")
        XCTAssertEqual(collectedWorks.last!, "10b&w")
    }
    
    func testSelectedVolumeOwnedWorkIDs() {
        let ownedWorks = testModel2.selectedVolumeOwnedWorkIDs
        XCTAssertEqual(ownedWorks, ["1a", "8b", "9", "10b&w"])
    }
    
    func testWorkID() {
        testModel2.selectedVolumeIndex = 1
        testModel2.selectedVolume.selectedWorkIndex = 7
        
        XCTAssertEqual(testModel2.selectedVolumeSelectedWork.id, "12b")
    }
    
    // MARK:- Test Functions
    
    func testWorkExists() {
        let testWorkIDs = ["1a", "1b", "2", "3", "3x", "5", "6max", "7", "7qqq", "8b", "9", "10b&w"]
        
        let bogusWorkIDIndexes = [4, 8]
        
        for i in 0 ..< testModel2.selectedVolume.works.count {
            XCTAssertEqual(testModel2.workExists(workID: testWorkIDs[i]), !bogusWorkIDIndexes.contains(i))
        }
    }
    
    func testUpdateSelectedWorkOfSelectedVolume() {
        let beforeUpdate = testModel2.selectedVolumeSelectedWork
        
        XCTAssertEqual(beforeUpdate.isOwned, true)
        XCTAssertEqual(beforeUpdate.coverImage, "american-standard-marvel")
        
        testModel2.updateSelectedWorkOfSelectedVolume(isOwned: false, coverImage: "catdog")
        
        let afterUpdate = testModel2.selectedVolumeSelectedWork
        
        XCTAssertEqual(afterUpdate.isOwned, false)
        XCTAssertEqual(afterUpdate.coverImage, "catdog")

    }
    
    func testAddWorkToSelectedVolume() {
        let newWork = JsonModel.JsonVolume.JsonWork(issueNumber: 100, variantLetter: "z", coverImage: "image123", isOwned: true)
        let newWorkID = "\(newWork.issueNumber)\(newWork.variantLetter)"
        XCTAssertFalse(testModel2.selectedVolumeCollectedWorkIDs.contains(newWorkID))
        
        testModel2.addWorkToSelectedVolume(newWork)
        XCTAssertTrue(testModel2.selectedVolumeCollectedWorkIDs.contains(newWorkID))
        XCTAssertTrue(testModel2.selectedVolumeOwnedWorkIDs.contains(newWorkID))
    }
    
    func testRemoveWorkFromSelectedVolume() {
        
        XCTAssertEqual(testModel2.selectedVolumeOwnedWorkIDs, ["1a", "8b", "9", "10b&w"])
        
        testModel2.selectedVolumeIndex = 0
        for work in testModel2.selectedVolume.works {
            work.isOwned = true
        }
        
        XCTAssertEqual(testModel2.selectedVolumeOwnedWorkIDs, ["1a", "1b", "2", "3", "4", "5", "6max", "7", "8b", "9", "10b&w"])
        
        let work1 = testModel2.selectedVolume.works[1]
        XCTAssertEqual(work1.id, "1b")
        
        testModel2.selectWork(work: work1)
        testModel2.removeSelectedWorkFromSelectedVolume()
        XCTAssertEqual(testModel2.selectedVolumeOwnedWorkIDs, ["1a", "2", "3", "4", "5", "6max", "7", "8b", "9", "10b&w"])
        XCTAssertEqual(testModel2.selectedVolume.selectedWorkIndex, 0)
        
        let work2 = testModel2.selectedVolume.works[2]
        XCTAssertEqual(work2.id, "3")
        
        let work0 = testModel2.selectedVolume.works[0]
        testModel2.selectWork(work: work0)
        testModel2.removeSelectedWorkFromSelectedVolume()
        XCTAssertEqual(testModel2.selectedVolumeOwnedWorkIDs, ["2", "3", "4", "5", "6max", "7", "8b", "9", "10b&w"])
        XCTAssertEqual(testModel2.selectedVolume.selectedWorkIndex, 0)

    }
    
    func testAddNexWork() {
        XCTAssertEqual(testModel2.selectedVolumeCollectedWorkIDs, ["1a", "1b", "2", "3", "4", "5", "6max", "7", "8b", "9", "10b&w"])
        
        testModel2.addNextWork(for: 0)
        XCTAssertEqual(testModel2.selectedVolumeCollectedWorkIDs, ["1a", "1b", "2", "3", "4", "5", "6max", "7", "8b", "9", "10b&w", "11"])
        
        let addedWork = testModel2.selectedVolume.works.last!
        XCTAssertEqual(addedWork.isOwned, true)
        XCTAssertEqual(addedWork.coverImage, "american-standard-marvel")
    }
    
    func testSelectWork() {
        XCTAssertEqual(testModel2.selectedVolumeCollectedWorkIDs, ["1a", "1b", "2", "3", "4", "5", "6max", "7", "8b", "9", "10b&w"])
        
        let currentIndex = testModel2.selectedVolume.selectedWorkIndex
        let currentWork = testModel2.selectedVolume.works[currentIndex]
        XCTAssertEqual(testModel2.selectedVolumeSelectedWork.id, currentWork.id)
        
        let newWork = testModel2.addNextWork(for: 0)
        testModel2.selectWork(work: newWork)
        XCTAssertEqual(testModel2.selectedVolume.selectedWorkIndex, 11)
        
        XCTAssertEqual(testModel2.selectedVolumeCollectedWorkIDs, ["1a", "1b", "2", "3", "4", "5", "6max", "7", "8b", "9", "10b&w", "11"])
    }
    
    // MARK:- Navigation
    
    func testNextWork() {
        let testIDs = ["1a", "1b", "2", "3", "4", "5", "6max", "7", "8b", "9", "10b&w"]
        
        for i in 0..<testModel2.selectedVolume.works.count {
            XCTAssertEqual(testModel2.selectedVolumeSelectedWork.id, testIDs[i])
            testModel2.selectNextWork()
        }
    }
    
    func testPrevWork() {
        let testIDs = ["10b&w", "9", "8b", "7", "6max", "5", "4", "3", "2", "1b", "1a"]
        
        testModel2.selectedVolume.selectedWorkIndex = 10
        
        for i in 0..<testModel2.selectedVolume.works.count {
            XCTAssertEqual(testModel2.selectedVolumeSelectedWork.id, testIDs[i])
            testModel2.selectPreviousWork()
        }
    }
    
    func testNextVolume() {
        let testSeriesNames = ["Limo Man", "Atomic Woman", "Atomic Woman", "Massive Cat Attack", "Darling Dog", "Darling Dog"]
        
        testModel2.selectedVolumeIndex = 0
        
        for i in 0..<testModel2.volumes.count {
            XCTAssertEqual(testModel2.selectedVolume.seriesName, testSeriesNames[i])
            testModel2.selectNextVolume()
        }
    }
    
    func testPrevVolume() {
        let testSeriesNames = ["Darling Dog", "Darling Dog", "Massive Cat Attack", "Atomic Woman", "Atomic Woman", "Limo Man"]
        
        testModel2.selectedVolumeIndex = 5
        
        for i in 0..<testModel2.volumes.count {
            XCTAssertEqual(testModel2.selectedVolume.seriesName, testSeriesNames[i])
            testModel2.selectPreviousVolume()
        }
    }
    
    func testVolumeID() {
        let testVolumeIDs = [ "Marble Entertainment/Limo Man/1950",
                              "Marble Entertainment/Atomic Woman/1990",
                              "Marble Entertainment/Atomic Woman/2010",
                              "EKK Comics/Massive Cat Attack/2011",
                              "EKK Comics/Darling Dog/1942",
                              "EKK Comics/Darling Dog/1952"
        ]
        
        testModel2.selectedVolumeIndex = 0
        
        for i in 0..<testModel2.volumes.count {
            XCTAssertEqual(testModel2.selectedVolume.id, testVolumeIDs[i])
            testModel2.selectNextVolume()
        }
    }
    
    func testVolumeExists() {
        let testVolumeIDs = [ "Marble Entertainment/Limo Man/1950",
                              "Marble Entertainment/Atomic Woman/1990",
                              "Marble Entertainment/Atomic Woman/2010",
                              "Man/Bear/Pig",
                              "EKK Comics/Massive Cat Attack/2011",
                              "EKK Comics/Darling Dog/1942",
                              "EKK Comics/Darling Dog/1952",
                              "Cat/Dog/Cow"
        ]
        
        let bogusIDIndexes = [3, 7]
        testModel2.selectedVolumeIndex = 0
        
        for i in 0 ..< testModel2.volumes.count {
            XCTAssertEqual(testModel2.volumeExists(volumeID: testVolumeIDs[i]), !bogusIDIndexes.contains(i))
        }
    }
    
    func testSortVolumes() {
        
        // before sorting

        let testVolumeIDsUnsorted = [
            "Marble Entertainment/Limo Man/1950",
            "Marble Entertainment/Atomic Woman/1990",
            "Marble Entertainment/Atomic Woman/2010",
            "EKK Comics/Massive Cat Attack/2011",
            "EKK Comics/Darling Dog/1942",
            "EKK Comics/Darling Dog/1952",
            ]
        
        XCTAssertEqual(testVolumeIDsUnsorted, testModel2.volumeIDs)
        
        // after sorting
        
        let testVolumeIDsSorted = [
            "EKK Comics/Darling Dog/1942",
            "EKK Comics/Darling Dog/1952",
            "EKK Comics/Massive Cat Attack/2011",
            "Marble Entertainment/Atomic Woman/1990",
            "Marble Entertainment/Atomic Woman/2010",
            "Marble Entertainment/Limo Man/1950"
        ]
        
        testModel2.sortVolumes()
        
        XCTAssertEqual(testVolumeIDsSorted, testModel2.volumeIDs)
    }
    
    func testAddVolume() {
        
        // add existing volume
        
        let testVolume1 = testModel2.volumes.first!
        let result1 = testModel2.addVolume(testVolume1)
        XCTAssertNil(result1)
        XCTAssertEqual(testModel2.volumes.count, 6)
        XCTAssertEqual(testModel2.selectedVolumeIndex, 0)

        // add new volume
        
        let testWork1 = JsonModel.JsonVolume.JsonWork(issueNumber: 1, variantLetter: "z", coverImage: "file not found", isOwned: true)
        
        let testVolume2 = JsonModel.JsonVolume(publisherName: "Zebra", seriesName: "Dog", era: 2018, volumeNumber: 1, kind: "graphic novel", works: [testWork1], defaultCoverID: "return to sender", selectedWorkIndex: 0)
        
        let result2 = testModel2.addVolume(testVolume2)
        XCTAssertNotNil(result2)
        XCTAssertEqual(testModel2.volumes.count, 7)
        XCTAssertEqual(testModel2.selectedVolumeIndex, 6)
    }
    
    func testSelectVolume() {
        
        // before selection
        
        XCTAssertEqual(testModel2.selectedVolumeIndex, 0)
        
        // select existing volume
        
        let testVolume1 = testModel2.volumes.last!
        let result1 = testModel2.selectVolume(testVolume1)
        XCTAssertNotNil(result1)
        XCTAssertEqual(testModel2.volumes[result1!].id, testVolume1.id)
        
        // selected nonexistant volume
        
        let testWork1 = JsonModel.JsonVolume.JsonWork(issueNumber: 1, variantLetter: "z", coverImage: "file not found", isOwned: true)
        
        let testVolume2 = JsonModel.JsonVolume(publisherName: "Cat", seriesName: "Dog", era: 2018, volumeNumber: 1, kind: "graphic novel", works: [testWork1], defaultCoverID: "return to sender", selectedWorkIndex: 0)
        
        let result2 = testModel2.selectVolume(testVolume2)
        XCTAssertNil(result2)
        XCTAssertEqual(testModel2.selectedVolumeIndex, 5)
    }
}
