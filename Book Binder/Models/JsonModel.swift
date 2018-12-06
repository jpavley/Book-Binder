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
        var kind: String
        var works: [JsonWork]
        var defaultCoverID: String
        var selectedWorkIndex: Int
        
        init(publisherName: String, seriesName: String, era: Int, volumeNumber: Int, kind: String, works: [JsonWork], defaultCoverID: String, selectedWorkIndex: Int) {
            
            self.publisherName = publisherName
            self.seriesName = seriesName
            self.era = era
            self.volumeNumber = volumeNumber
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
    
    var selectedVolumeSelectedWork: JsonVolume.JsonWork {
        return selectedVolume.works[selectedVolume.selectedWorkIndex]
    }
    
    /// The number of works in the collection of the currently selected volume by selectedVolumeIndex.
    var selectedVolumeWorksCount: Int {
        return selectedVolume.works.count
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
}

// MARK:- JsonModel Functions

extension JsonModel {
    
    func addWorkToSelectedVolume(_ w: JsonVolume.JsonWork) {
        if !selectedVolumeCollectedWorkIDs.contains(w.id) {
            selectedVolume.works.append(w)
        }
    }
    
    func removeSelectedWorkFromSelectedVolume() {
        let w = selectedVolumeSelectedWork

        if selectedVolumeCollectedWorkIDs.contains(w.id) {
            
            let filteredWorks = selectedVolume.works.filter { $0.id != w.id }
            selectedVolume.works = filteredWorks
            selectedVolume.selectedWorkIndex -= 1
            
            if selectedVolume.selectedWorkIndex < 0 {
                selectedVolume.selectedWorkIndex = 0
            }
        }
    }
    
    @discardableResult
    func addNextWork(for volumeID: Int) -> JsonModel.JsonVolume.JsonWork {
        
        selectedVolumeIndex = volumeID
        
        let lastWorkNumber = selectedVolume.works.last!.issueNumber
        let currentWorkNumber = lastWorkNumber + 1
        
        let currentWork = JsonVolume.JsonWork(issueNumber: currentWorkNumber, variantLetter: "", coverImage: "", isOwned: true)
        
        selectedVolume.works.append(currentWork)
        return currentWork
    }
    
    @discardableResult
    func addVariantWork(workNumber: Int, letter: String) -> JsonModel.JsonVolume.JsonWork? {
        
        // variant letter must be at least a single character
        if letter.count < 1 {
            return nil
        }
        
        let variantWork = JsonVolume.JsonWork(issueNumber: workNumber, variantLetter: letter, coverImage: "", isOwned: true)
        
        
        // varliant letter mist not create a duplicate variant
        if selectedVolumeCollectedWorkIDs.contains(variantWork.id) {
            return nil
        }
        
        var works = selectedVolume.works
        works.append(variantWork)
        selectedVolume.works = works.sorted(by: { w1, w2 in
            return w1.id < w2.id
        })
        
        return variantWork
    }
    
    func selectWork(work: JsonModel.JsonVolume.JsonWork) {
        for i in 0..<selectedVolume.works.count {
            if selectedVolume.works[i].id == work.id {
                selectedVolume.selectedWorkIndex = i
            }
        }
    }
}
