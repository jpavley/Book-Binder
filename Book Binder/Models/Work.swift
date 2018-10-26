//
//  Work.swift
//  Book Binder
//
//  Created by John Pavley on 9/23/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// MVP 1: Just enough to get the Summary View displayed
class Work {
    
    /// Used to tie this book to a series
    var seriesURI: BookBinderURI
    
    var printing: Int
    
    /// The number of this book
    var issueNumber: Int
    
    /// The number of this issue's variant
    var variantLetter: String
    
    /// Does the user own this issue?
    var isOwned: Bool
    
    /// Is there are photo of this issue's cover?
    var coverImageID: String
    
    init(seriesURI: BookBinderURI, printing: Int, issueNumber: Int, variantLetter: String, isOwned: Bool, coverImageID: String) {
        self.seriesURI = seriesURI
        self.printing = printing
        self.issueNumber = issueNumber
        self.variantLetter = variantLetter
        self.isOwned = isOwned
        self.coverImageID = coverImageID
    }
    
    /// initalization from a full URI
    /// - Publisher/Series/Era/Issue/variant
    init(fromURI: BookBinderURI, isOwned: Bool, coverImageID: String) {
        self.seriesURI = Series(uri: fromURI, firstIssue: 0, currentIssue: 0).uri
        self.printing = Int(fromURI.printingPart)!
        self.issueNumber = Int(fromURI.issuePart)!
        self.variantLetter = fromURI.variantPart
        self.isOwned = isOwned
        self.coverImageID = coverImageID
    }
}

// MARK: Calculated Vars

extension Work {
    
    /// URI that identifies this book
    /// - Publisher/Series/Era/Volume/Printing/Issue/variant
    var bookURI: BookBinderURI {
        return BookBinderURI(fromURIString: "\(seriesURI.publisherPart)/\(seriesURI.titlePart)/\(seriesURI.eraPart)/\(seriesURI.volumePart)/\(printing)/\(issueNumber)/\(variantLetter)")!
    }
    
    var bookPublisher: String {
        return seriesURI.publisherPart
    }
    
    var bookTitle: String {
        return seriesURI.titlePart
    }
    
    var bookEra: String {
        return seriesURI.eraPart
    }
    
    var bookVolume: String {
        return seriesURI.volumePart
    }
}

extension Work: CustomDebugStringConvertible {
    var debugDescription: String {
        return "bookURI: \(bookURI.description), isOwned: \(isOwned), coverImageID: \(coverImageID)"
    }
    
    
}
