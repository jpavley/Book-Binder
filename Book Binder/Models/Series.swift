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
    var volume: Int
    var firstIssue: Int
    var currentIssue: Int
    var skippedIssues: [Int]
    var extraIssues: [Int]
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
        volume = 0
        firstIssue = 0
        currentIssue = 0
        skippedIssues = [Int]()
        extraIssues = [Int]()
        works = [BookModel]()
    }
    
    convenience init(uri: BookBinderURI, firstIssue: Int, currentIssue: Int) {
        self.init()
        self.publisher = BookBinderURI.part(fromURIString: uri.description, partID: .publisher)
        self.title = BookBinderURI.part(fromURIString: uri.description, partID: .title)
        self.era = Int(BookBinderURI.part(fromURIString: uri.description, partID: .era))!
        self.volume = Int(BookBinderURI.part(fromURIString: uri.description, partID: .volume))!
        self.firstIssue = firstIssue
        self.currentIssue = currentIssue
    }
}

extension Series: Trackable {
    
    var uri: BookBinderURI {
        get {
            return BookBinderURI(fromURIString: "\(publisher)/\(title)/\(era)/\(volume)")!
        }
        set {
            publisher = newValue.publisherPart
            title = newValue.titlePart
            era = Int(newValue.eraPart)!
            volume = Int(newValue.volumePart)!
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
