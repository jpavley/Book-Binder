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
class JsonModel: Codable {
    
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
        var selectedWorkIndex: Int
        
        init(publisherName: String, seriesName: String, era: Int, volumeNumber: Int, firstWorkNumber: Int, currentWorkNumber: Int, kind: String, works: [JsonWork], selectedWorkIndex: Int) {
            
            self.publisherName = publisherName
            self.seriesName = seriesName
            self.era = era
            self.volumeNumber = volumeNumber
            self.firstWorkNumber = firstWorkNumber
            self.currentWorkNumber = currentWorkNumber
            self.kind = kind
            self.works = works
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
            
        }
    }
}

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
        }
        
        let unsorted = sharedWorks + rawWorks
        let sorted = unsorted.sorted {$0.localizedStandardCompare($1) == .orderedAscending}
        
        return sorted
    }
}
