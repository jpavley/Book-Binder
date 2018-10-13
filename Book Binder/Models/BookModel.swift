//
//  BookModel.swift
//  Book Binder
//
//  Created by John Pavley on 9/23/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// MVP 1: Just enough to get the Summary View displayed
class BookModel {
    
    /// Used to tie this book to a series
    var seriesURI: BookBinderURI
    
    /// The number of this book
    var issueNumber: Int
    
    /// The number of this issue's variant
    var variantLetter: String
    
    /// Does the user own this issue?
    var isOwned: Bool
    
    /// Is there are photo of this issue's cover?
    var coverImageID: String
    
    init(seriesURI: BookBinderURI, issueNumber: Int, variantLetter: String, isOwned: Bool, coverImageID: String) {
        self.seriesURI = seriesURI
        self.issueNumber = issueNumber
        self.variantLetter = variantLetter
        self.isOwned = isOwned
        self.coverImageID = coverImageID
    }
    
    /// initalization from a full URI
    /// - Publisher/Series/Era/Issue/variant
    init(fromURI: BookBinderURI, isOwned: Bool, coverImageID: String) {
        self.seriesURI = SeriesModel(fromURI: fromURI).seriesURI
        self.issueNumber = Int(fromURI.issueID)!
        self.variantLetter = fromURI.variantID
        self.isOwned = isOwned
        self.coverImageID = coverImageID
    }
}

// MARK: Calculated Vars

extension BookModel {
    
    /// URI that identifies this book
    /// - Publisher/Series/Era/Issue/variant/consumption
    var bookURI: BookBinderURI {
        
        let consumption = isOwned ? "owned" : ""
        
        return BookBinderURI(fromURIString: "\(seriesURI.publisherID)/\(seriesURI.seriesID)/\(seriesURI.eraID)/\(issueNumber)/\(variantLetter)/\(consumption)/\(coverImageID)")
    }
    
    var bookPublisher: String {
        return seriesURI.publisherID
    }
    
    var bookTitle: String {
        return seriesURI.seriesID
    }
    
    var bookEra: String {
        return seriesURI.eraID
    }
}

