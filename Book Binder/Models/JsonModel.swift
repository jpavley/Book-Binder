//
//  JsonModel.swift
//  BookBinderLab2
//
//  Created by John Pavley on 11/9/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// Models a serializable collection of collectiables as a list of `Volumes` which contain a list of
/// `works` in JSON. In a UICollectionView volumes are equalent to sections and works are equavalent
/// to items.
/// - Note:
///     - A collected work is in a volume's works list.
///     - An uncollected work is not in a volume's works list but was published based on firstWorkNumber and currentWorkNumber.
///     - A published work may or may not be in a volume's works list but was published based on firstWorkNumber and currentWorkNumber.
final class JsonModel: Codable {
    
    var volumes: [JsonVolume]
    var selectedVolumeIndex: Int
    
    init(volumes: [JsonVolume], selectedVolumeIndex: Int = 0) {
        
        self.volumes = volumes
        self.selectedVolumeIndex = selectedVolumeIndex
    }
    
    class JsonVolume: Codable {
        
        var publisherName: String
        var seriesName: String
        var era: Int
        var volumeNumber: Int
        var firstWorkNumber: Int
        var currentWorkNumber: Int
        var kind: String
        var works: [JsonWork]
        var defaultCoverID: String
        var selectedWorkIndex: Int
        
        init(publisherName: String, seriesName: String, era: Int, volumeNumber: Int, firstWorkNumber: Int, currentWorkNumber: Int, kind: String, works: [JsonWork], defaultCoverID: String, selectedWorkIndex: Int) {
            
            self.publisherName = publisherName
            self.seriesName = seriesName
            self.era = era
            self.volumeNumber = volumeNumber
            self.firstWorkNumber = firstWorkNumber
            self.currentWorkNumber = currentWorkNumber
            self.kind = kind
            self.works = works
            self.defaultCoverID = defaultCoverID
            self.selectedWorkIndex = selectedWorkIndex
        }
        
        class JsonWork: Codable {
            
            var issueNumber: Int
            var variantLetter: String
            var coverImage: String
            var isOwned: Bool
            
            init(issueNumber: Int, variantLetter: String, coverImage: String, isOwned: Bool) {
                
                self.issueNumber = issueNumber
                self.variantLetter = variantLetter
                self.coverImage = coverImage
                self.isOwned = isOwned
            }
            
            var id: String {
                return "\(issueNumber)\(variantLetter)"
            }
            
        }
    }
}

// MARK: - JsonModel Computed Variables

extension JsonModel {
    
    
    /// The currently selected volume by selectedVolumeIndex.
    var selectedVolume: JsonVolume {
        return volumes[selectedVolumeIndex]
    }
    
    /// The currently selected work in the collection of the currently selected volume by selectedVolumeIndex and selectedWorkIndex.
    var selectedVolumeSelectedCollectedWork: JsonVolume.JsonWork {
        return selectedVolume.works[selectedVolume.selectedWorkIndex]
    }
    
    
    /// The currently selected work from the complete list of collection and uncollected works of the currently selected volume by selectedVolumeIndex and selectedWorkIndex.
    /// If a work is not in the works list a new work is created and returned.
    var selectedVolumeSelectedWork: JsonVolume.JsonWork {
        
        // return either a published work or collected work based in selectedWorkIndex
        
        let selectedWorkID = selectedVolumeCompleteWorkIDs[selectedVolume.selectedWorkIndex]
        
        for work in selectedVolume.works {
            let workID = "\(work.issueNumber)\(work.variantLetter)"
            if selectedWorkID == workID {
                return work
            }
        }
        
        // if a collected work is not found return an uncollected work
        let issueNumber = Int(selectedWorkID)!
        
        let uncollectedWork = JsonVolume.JsonWork(issueNumber: issueNumber, variantLetter: "", coverImage: "american-standard-dc", isOwned: false)
        return uncollectedWork
    }
    
    /// The number of works in the collection of the currently selected volume by selectedVolumeIndex.
    var selectedVolumeWorksCount: Int {
        return selectedVolume.works.count
    }
    
    /// A list of IDs (issue numbers as strings) from the list of published works of the currently selected volume by selectedVolumeIndex.
    var selectedVolumePublishedWorkIDs: [String] {
        var result = [String]()
        for i in selectedVolume.firstWorkNumber...selectedVolume.currentWorkNumber {
            result.append("\(i)")
        }
        
        return result
    }
    
    /// A list of IDs (issue numbers and variant letters as strings) from the list of collected works of the currently selected volume by selectedVolumeIndex.
    var selectedVolumeCollectedWorkIDs: [String] {
        var result = [String]()
        
        for work in selectedVolume.works {
            result.append("\(work.issueNumber)\(work.variantLetter)")
        }
        
        return result
    }
    
    var selectedVolumeOwnedWorkIDs: [String] {
        var result = [String]()
        
        for work in selectedVolume.works {
            if work.isOwned {
                result.append("\(work.issueNumber)\(work.variantLetter)")
            }
        }
        
        return result
    }
    
    /// A list of IDs (issue numbers and variant letters as strings) from the complete list of collected and uncollected works of the currently selected volume by selectedVolumeIndex.
    var selectedVolumeCompleteWorkIDs: [String] {
        
        let rawWorks = selectedVolumePublishedWorkIDs
        var sharedWorks = [String]()
        
        for work in selectedVolume.works {
            
            // if a variant has the same number as a published work
            // but doesn't have a variant letter...
            
            if rawWorks.contains("\(work.issueNumber)") && work.variantLetter != "" {
                sharedWorks.append("\(work.issueNumber)\(work.variantLetter)")
            }
            
            // TODO: User added a new work to collected works but the number is greater than currentWorkNumber
            //       - New issue (currentWorkNumber + 1)
            //       - Random issue (any number outside the range of firstWorkNumber...currentWorkNumber
            //       - If we add it do we have to update currentWorkNumber? 1...10 + 11 yes, but 1...10 + 100 ??
        }
        
        let unsorted = sharedWorks + rawWorks
        let sorted = unsorted.sorted {$0.localizedStandardCompare($1) == .orderedAscending}
        
        return sorted
    }
}

// MARK:- JsonModel Functions

extension JsonModel {
    
    func addWorkToSelectedVolume(_ w: JsonVolume.JsonWork) {
        
        if w.issueNumber > selectedVolume.currentWorkNumber {
            selectedVolume.currentWorkNumber = w.issueNumber
        }
        
        if !selectedVolumeCollectedWorkIDs.contains(w.id) {
            selectedVolume.works.append(w)
        }
    }
    
    func removeWorkFromSelectedVolume(_ w: JsonVolume.JsonWork) {
        if selectedVolumeCollectedWorkIDs.contains(w.id) {
            
            let filteredWorks = selectedVolume.works.filter { $0.id != w.id }
            selectedVolume.works = filteredWorks
            
            // if there was a variant letter select the prev work
            
            if w.variantLetter != "" {
                selectedVolume.selectedWorkIndex -= 1
                if selectedVolume.selectedWorkIndex < 0 {
                    selectedVolume.selectedWorkIndex = 0
                }
            }
        }
    }
    
    func addNextWork(for volumeID: Int) {
        
        selectedVolumeIndex = volumeID
        
        selectedVolume.currentWorkNumber += 1
        let currentWorkNumber = selectedVolume.currentWorkNumber
        
        let currentWork = JsonVolume.JsonWork(issueNumber: currentWorkNumber, variantLetter: "", coverImage: "", isOwned: true)
        
        selectedVolume.works.append(currentWork)
    }
    
    func addVariantWork(volumeIndex: Int, workIndex: Int, letter: String) -> JsonModel.JsonVolume.JsonWork? {
        
        // variant letter must be at least a single character
        if letter.count < 1 {
            return nil
        }
        
        selectedVolumeIndex = volumeIndex
        selectedVolume.selectedWorkIndex = workIndex
        
        let baseWork = selectedVolumeSelectedWork
        
        let variantWork = JsonVolume.JsonWork(issueNumber: baseWork.issueNumber, variantLetter: letter, coverImage: baseWork.coverImage, isOwned: true)
        
        
        // varliant letter mist not create a duplicate variant
        if selectedVolumeCompleteWorkIDs.contains(variantWork.id) {
            return nil
        }
        
        var works = selectedVolume.works
        works.append(variantWork)
        selectedVolume.works = works.sorted(by: { w1, w2 in
            return w1.id < w2.id
        })
        
        return variantWork
    }
    
//    func indexFor(volumeIndex: Int, workID: String) -> Int? {
//
//        selectedVolumeIndex = volumeIndex
//
//        for i in 0..<selectedVolumeCompleteWorkIDs.count {
//            if selectedVolumeCompleteWorkIDs[i] == workID {
//                return i
//            }
//        }
//
//        return nil
//    }
    
    func selectWork(work: JsonModel.JsonVolume.JsonWork) {
        for i in 0..<selectedVolumeCompleteWorkIDs.count {
            if selectedVolumeCompleteWorkIDs[i] == work.id {
                selectedVolume.selectedWorkIndex = i
            }
        }
    }
}
