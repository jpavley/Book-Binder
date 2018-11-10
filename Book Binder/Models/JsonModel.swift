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
    
    var selectedVolume: JsonVolume {
        return volumes[selectedVolumeIndex]
    }
    
    var selectedWork: JsonVolume.JsonWork {
        return selectedVolume.works[selectedVolume.selectedWorkIndex]
    }
    
    var selectedWorksCount: Int {
        return selectedVolume.works.count
    }
}
