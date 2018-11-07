//
//  WorkVariant.swift
//  Book Binder
//
//  Created by John Pavley on 10/27/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

class WorkVarient: Trackable {
    
    var bookURI: BookBinderURI
    
    /// - Full URI: publisher/title/era/volume/printing/issue/variant
    var uri: BookBinderURI {
        get {
            return BookBinderURI(fromURIString: "\(bookURI.publisherPart)/\(bookURI.titlePart)/\(bookURI.eraPart)/\(bookURI.volumePart)/\(printing)/\(bookURI.issuePart)/\(letter)")!
        }
        set {
            self.bookURI = newValue.bookPart
            self.printing = Int(newValue.printingPart) ?? 0
            self.letter = newValue.variantPart
        }
    }
    
    // Trackable

    var tags: Set<String>
    var dateStamp: Date
    var guid: UUID
    
    // Debuging
    
    var description: String {
        return "WorkVariant: uri \(uri.description), coverImageID \(coverImageID), isOwned \(isOwned) "
    }
    
    var debugDescription: String {
        return "variantURI: \(uri.description), dateStamp: \(dateStamp), guid \(guid), tags: \(tags)"
    }

    // Hashing
    
    static func == (lhs: WorkVarient, rhs: WorkVarient) -> Bool {
        return lhs.uri == rhs.uri
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(guid)
    }
    
    // Varient Properties
    
    var printing: Int
    var letter: String
    var coverImageID: String
    var isOwned: Bool
    
    // initalization
    
    init() {
        tags = []
        dateStamp = Date()
        guid = UUID()
        bookURI = BookBinderURI(fromURIString: BookBinderURI.emptyURIString)!
        printing = 0
        letter = ""
        coverImageID = ""
        isOwned = false
    }
    
    convenience init(printing: Int, letter: String, coverImageID: String, isOwned: Bool) {
        self.init()
        self.printing = printing
        self.letter = letter
        self.coverImageID = coverImageID
        self.isOwned = isOwned
    }
}
