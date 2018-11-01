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
    
    /// The number of this work
    var issueNumber: Int
    
    /// The variants associated with this work.
    var variants: [BookBinderURI: WorkVarient]
    
    // Trackable properties
    
    var tags: Set<String>
    var dateStamp: Date
    var guid: UUID
    
    init() {
        tags = []
        dateStamp = Date()
        guid = UUID()
        seriesURI = BookBinderURI(fromURIString: BookBinderURI.emptyURIString)!
        issueNumber = 0
        variants = [:]
    }
    
    convenience init(seriesURI: BookBinderURI, issueNumber: Int, variants: [BookBinderURI: WorkVarient]) {
        self.init()
        self.seriesURI = seriesURI
        self.issueNumber = issueNumber
        self.variants = variants
    }
    
    /// initalization from a full URI
    /// - Publisher/Series/Era/Volume/Printing/Issue/Variant
    convenience init(fromURI: BookBinderURI, isOwned: Bool, coverImageID: String) {
        self.init()
        self.seriesURI = Series(uri: fromURI, firstIssue: 0, currentIssue: 0).uri
        self.issueNumber = Int(fromURI.issuePart) ?? 0
        let printing = Int(fromURI.printingPart) ?? 0
        let letter = fromURI.variantPart
        let key = BookBinderURI(fromURIString: "\(seriesURI.publisherPart)/\(seriesURI.titlePart)/\(seriesURI.eraPart)/\(seriesURI.volumePart)/\(printing)/\(issueNumber)/\(letter)")!
        let variant = WorkVarient(printing: printing, letter: letter, coverImageID: coverImageID, isOwned: isOwned)
        self.variants[key] = variant
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
    
    var anyOwned: [String] {
        let ownedVariants = variants.map { $0.value.isOwned ? "\(issueNumber)\($0.value.letter)" : "" }
        return ownedVariants.sorted()
    }
}

extension Work: Trackable {
    
    /// Returns work URI
    /// - Series URI:      Publisher/Series/Era/Volume///
    /// - Work URI:        Publisher/Series/Era/Volume//Issue/
    /// - WorkVariant URI: Publisher/Series/Era/Volume/Printing/Issue/Variant
    var uri: BookBinderURI {
        get {
            return BookBinderURI(fromURIString: "\(seriesURI.publisherPart)/\(seriesURI.titlePart)/\(seriesURI.eraPart)/\(seriesURI.volumePart)//\(issueNumber)/\("")")!
        }
        set {
            seriesURI = newValue.seriesPart
            let printing = Int(newValue.printingPart) ?? 0
            issueNumber = Int(newValue.issuePart) ?? 0
            let letter = newValue.variantPart
            
            let key = BookBinderURI(fromURIString: "\(seriesURI.publisherPart)/\(seriesURI.titlePart)/\(seriesURI.eraPart)/\(seriesURI.volumePart)/\(printing)/\(issueNumber)/\(letter)")!
            let variant = WorkVarient(printing: printing, letter: newValue.variantPart, coverImageID: "", isOwned: false)
            variants[key] = variant
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
