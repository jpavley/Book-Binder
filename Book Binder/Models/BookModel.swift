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
    var bookURI: BookBinderURI
    
    /// The number of this book
    var issueNumber: Int
    
    /// The number of this issue's varient
    var varientLetter: String
    
    /// Does the user own this issue?
    var isOwned: Bool
    
    init(seriesURI: BookBinderURI, issueNumber: Int, varientLetter: String, isOwned: Bool) {
        self.issueNumber = issueNumber
        self.varientLetter = varientLetter
        self.isOwned = isOwned
        
        bookURI = BookBinderURI(fromURIString: "\(seriesURI.publisherID)/\(seriesURI.seriesID)//\(seriesURI.eraID)\(issueNumber)/\(varientLetter)")
    }
}
