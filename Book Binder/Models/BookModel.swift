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
    
    init(seriesURI: BookBinderURI, issueNumber: Int, variantLetter: String, isOwned: Bool) {
        self.seriesURI = seriesURI
        self.issueNumber = issueNumber
        self.variantLetter = variantLetter
        self.isOwned = isOwned
    }
}

// MARK: Calculated Vars

extension BookModel {
    
    /// URI that identifies this book
    /// - Publisher/Series/Era/Issue/variant/consumption
    var bookURI: BookBinderURI {
        
        let ownerShip = isOwned ? "owned" : ""
        
        return BookBinderURI(fromURIString: "\(seriesURI.publisherID)/\(seriesURI.seriesID)/\(seriesURI.eraID)/\(issueNumber)/\(variantLetter)/\(ownerShip)")
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

