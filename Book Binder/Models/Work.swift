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
    
    /// Used to tie this work to a series
    var seriesURI: BookBinderURI
    
    /// The printing number of this work
    var printing: Int
    
    /// The number of this work
    var issueNumber: Int
    
    /// The variants associated with this work
    /// Every work has a "default variant" with the empty string as it's variant letter
    var variants: [WorkVarient]
    
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
        variants = [WorkVarient]()
    }
    
    convenience init(seriesURI: BookBinderURI, printing: Int, issueNumber: Int, variantLetter: String, isOwned: Bool, coverImageID: String) {
        self.init()
        self.seriesURI = seriesURI
        self.printing = printing
        self.issueNumber = issueNumber
        let variant = WorkVarient(letter: variantLetter, coverImageID: coverImageID, isOwned: isOwned)
        self.variants.append(variant)
    }
    
    /// initalization from a full URI
    /// - Publisher/Series/Era/Volume/Printing/Issue/Variant
    convenience init(fromURI: BookBinderURI, isOwned: Bool, coverImageID: String) {
        self.init()
        self.seriesURI = Series(uri: fromURI, firstIssue: 0, currentIssue: 0).uri
        self.printing = Int(fromURI.printingPart)!
        self.issueNumber = Int(fromURI.issuePart)!
        let variant = WorkVarient(letter: fromURI.variantPart, coverImageID: coverImageID, isOwned: isOwned)
        self.variants.append(variant)
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
    
    /// Returns work URI with default variant
    /// - Publisher/Series/Era/Volume/Printing/Issue/Variant
    var uri: BookBinderURI {
        get {
            return BookBinderURI(fromURIString: "\(seriesURI.publisherPart)/\(seriesURI.titlePart)/\(seriesURI.eraPart)/\(seriesURI.volumePart)/\(printing)/\(issueNumber)/\("")")!
        }
        set {
            self.seriesURI = newValue.seriesPart
            self.printing = Int(newValue.printingPart) ?? 0
            self.issueNumber = Int(newValue.issuePart) ?? 0
            let variant = WorkVarient(letter: newValue.variantPart, coverImageID: "", isOwned: false)
            self.variants.append(variant)
        }
    }
    
    
    var description: String {
        return "Work: uri \(uri.description), variants \(variants) "
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
