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
    
    // Trackable properties
    
    var tags: Set<String>
    var dateStamp: Date
    var guid: UUID
    
    init() {
        tags = []
        dateStamp = Date()
        guid = UUID()
        seriesURI = BookBinderURI(fromURIString: BookBinderURI.emptyURIString)!
        printing = 0
        issueNumber = 0
        variantLetter = ""
        isOwned = false
        coverImageID = ""
    }
    
    convenience init(seriesURI: BookBinderURI, printing: Int, issueNumber: Int, variantLetter: String, isOwned: Bool, coverImageID: String) {
        self.init()
        self.seriesURI = seriesURI
        self.printing = printing
        self.issueNumber = issueNumber
        self.variantLetter = variantLetter
        self.isOwned = isOwned
        self.coverImageID = coverImageID
    }
    
    /// initalization from a full URI
    /// - Publisher/Series/Era/Issue/variant
    convenience init(fromURI: BookBinderURI, isOwned: Bool, coverImageID: String) {
        self.init()
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

extension Work: Trackable {
    var uri: BookBinderURI {
        get {
            return BookBinderURI(fromURIString: "\(seriesURI.publisherPart)/\(seriesURI.titlePart)/\(seriesURI.eraPart)/\(seriesURI.volumePart)/\(printing)/\(issueNumber)/\(variantLetter)")!
        }
        set {
            self.seriesURI = newValue.seriesPart
            self.printing = Int(newValue.printingPart) ?? 0
            self.issueNumber = Int(newValue.issuePart) ?? 0
            self.variantLetter = newValue.variantPart
        }
    }
    
    
    var description: String {
        return "Work: uri \(uri.description), isOwned: \(isOwned), coverImageID: \(coverImageID) "
    }
    
    var debugDescription: String {
        return "bookURI: \(uri.description), dateStamp: \(dateStamp), guid \(guid), tags: \(tags)"
    }
    
    static func == (lhs: Work, rhs: Work) -> Bool {
        return lhs.uri == rhs.uri
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(guid)
    }
}
