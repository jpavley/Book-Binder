//
//  ComicBookCollectible.swift
//  BookBinderLab1
//
//  Created by John Pavley on 11/6/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/**
 A comic book as a flat object with all its properties, pulled out of its hierarchy
 */
struct ComicBookCollectible {
    
    let publisher: JsonModel.JsonPublisher
    let series: JsonModel.JsonPublisher.JsonSeries
    let volume: JsonModel.JsonPublisher.JsonSeries.JsonVolume
    let work: JsonModel.JsonPublisher.JsonSeries.JsonVolume.JsonWork
    let variant: JsonModel.JsonPublisher.JsonSeries.JsonVolume.JsonWork.JsonVariant
    
    // MARK:- Calculated Properties
    
    var uri: BookBinderURI {
        return BookBinderURI(versionPart: "1", publisherPart: publisher.name, seriesPart: series.title, volumePart: "\(volume.era)", issuePart: "\(work.number)", variantPart: "\(variant.letter)")
    }
    
    var isOwned: Bool {
        return variant.dateCollected != ""
    }
    
    var wasRead: Bool {
        return variant.dateConsumed != ""
    }
}
