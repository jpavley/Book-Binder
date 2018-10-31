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
    var variants: [WorkVarient]
    
    /// Every work has a "default variant" which represent the work in all its variant forms.
    var defaultVariantID: String  // TODO: instead of a default URI, I need a selected URI, so I know what to return when the Book URI is asked for.
    
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
        variants = [WorkVarient]()
        defaultVariantID = ""
    }
    
    convenience init(seriesURI: BookBinderURI, issueNumber: Int, variants: [WorkVarient]) {
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
        let variant = WorkVarient(printing: printing, letter: fromURI.variantPart, coverImageID: coverImageID, isOwned: isOwned)
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
    
    var anyOwned: [String] {
        let ownedVariants = variants.map { $0.isOwned ? "\(issueNumber)\($0.letter)" : "" }
        return ownedVariants.sorted()
    }
    
    var defaultVariant: WorkVarient {
        
        let found = variants.filter { $0.letter == defaultVariantID }.first
        
        if found != nil {
            
            // if the default varient exists, return it
            return found!
        } else if variants.count > 0 {
            
            // if not return the first variant
            return variants.first!
        } else {
            
            // if there are no variants create a default variant and return it
            let newVariant = WorkVarient(printing: 0, letter: "", coverImageID: "", isOwned: false)
            variants.append(newVariant)
            return newVariant
        }
    }
}

extension Work: Trackable {
    
    /// Returns work URI with default variant
    /// - Publisher/Series/Era/Volume/Printing/Issue/Variant
    var uri: BookBinderURI {
        get {
            return BookBinderURI(fromURIString: "\(seriesURI.publisherPart)/\(seriesURI.titlePart)/\(seriesURI.eraPart)/\(seriesURI.volumePart)/\(0)/\(issueNumber)/\("")")!
        }
        set {
            self.seriesURI = newValue.seriesPart
            let printing = Int(newValue.printingPart) ?? 0
            self.issueNumber = Int(newValue.issuePart) ?? 0
            let variant = WorkVarient(printing: printing, letter: newValue.variantPart, coverImageID: "", isOwned: false)
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
