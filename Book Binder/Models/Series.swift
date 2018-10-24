//
//  Series.swift
//  Book Binder
//
//  Created by John Pavley on 10/22/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

class Series {
    
    // class properties
    
    var publisher: String
    var title: String
    var era: Int
    var volumeNumber: Int
    
    var firstIssue: Int {
        didSet {
            updatePublishedIssues()
        }
    }
    
    var currentIssue: Int {
        didSet {
            updatePublishedIssues()
        }
    }
    var skippedIssues: [Int]
    var extraIssues: [Int]
    var publishedIssues: [Int]
    
    var works: [BookModel]
    
    // Trackable properties
    
    var tags: Set<String>
    var dateStamp: Date
    var guid: UUID
    
    // initalization
    
    init() {
        tags = []
        dateStamp = Date()
        guid = UUID()
        
        publisher = ""
        title = ""
        era = 0
        volumeNumber = 0
        
        firstIssue = 0
        currentIssue = 0
        
        skippedIssues = [Int]()
        extraIssues = [Int]()
        publishedIssues = [Int]()
        
        works = [BookModel]()
    }
    
    convenience init(uri: BookBinderURI, firstIssue: Int, currentIssue: Int) {
        self.init()
        self.publisher = BookBinderURI.part(fromURIString: uri.description, partID: .publisher)
        self.title = BookBinderURI.part(fromURIString: uri.description, partID: .title)
        self.era = Int(BookBinderURI.part(fromURIString: uri.description, partID: .era)) ?? 0
        self.volumeNumber = Int(BookBinderURI.part(fromURIString: uri.description, partID: .volume)) ?? 0
        self.firstIssue = firstIssue
        self.currentIssue = currentIssue
    }
}

// Calculated Vars

extension Series {
    
    /// Number of possible issues if no numbers are skipped
    var publishedIssueCount: Int {
        // TODO: update to work with arrays for published, extra and skipped issues
        let sequentialIssues = currentIssue - (firstIssue - 1)
        return sequentialIssues + extraIssues.count - skippedIssues.count
    }
}


// Methods

extension Series {
    
    func updatePublishedIssues() {
        
        if firstIssue > currentIssue {
            return
        }
        
        publishedIssues = [Int]()
        
        for n in firstIssue...currentIssue {
            publishedIssues.append(n)
        }
        
        publishedIssues += extraIssues
        publishedIssues = publishedIssues.filter { !skippedIssues.contains($0) }
    }
}

// Trackable

extension Series: Trackable {
    
    /// Publisher\Title\Era\Volume
    var uri: BookBinderURI {
        get {
            return BookBinderURI(fromURIString: "\(publisher)/\(title)/\(era)/\(volumeNumber)")!
        }
        set {
            publisher = newValue.publisherPart
            title = newValue.titlePart
            era = Int(newValue.eraPart)!
            volumeNumber = Int(newValue.volumePart)!
        }
    }
    
    
    var description: String {
        return "\(uri.description)"
    }
    
    var debugDescription: String {
        return "uri \(uri.description), dateStamp: \(dateStamp), guid \(guid), tags: \(tags)"
    }
    
    static func == (lhs: Series, rhs: Series) -> Bool {
        return lhs.uri == rhs.uri
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(guid)
    }
}
