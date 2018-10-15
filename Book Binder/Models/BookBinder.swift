//
//  BookBinder.swift
//  Book Binder
//
//  Created by John Pavley on 10/9/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

class BookBinder {
    var comicbooks: [Comicbook]
    var selectedComicbookIndex: Int
    var selectedIssueIndex: Int
    
    init(comicbooks: [Comicbook], selectedComicbookIndex: Int, selectedIssueIndex: Int) {
        self.comicbooks = comicbooks
        self.selectedComicbookIndex = selectedComicbookIndex
        self.selectedIssueIndex = selectedIssueIndex
    }
    
    /// Modifies the selected comicbook's books array by either updating an existing book
    /// or adding a book if it doesn't exist
    func updateBooks(with modifiedBook: BookModel) {
        let selectedComicbook = getSelectedComicbook()
        var books = selectedComicbook.books
        
        if selectedComicbook.series.seriesURI.description != modifiedBook.seriesURI.description {
            assert(true, "you can't add or modify a book with a series URI different from the comicbook's series URI!")
            return
        }
        
        if let oldValue = books.updateValue(modifiedBook, forKey: modifiedBook.bookURI) {
            assert(true, "the old value of \(oldValue.debugDescription) was replaced with \(modifiedBook.debugDescription)")
        } else {
            assert(true, "no old value for \(modifiedBook.debugDescription) was found so it was added as a new value")
        }
        
        selectedComicbook.books = books
    }
    
    func getSelectedComicbook() -> Comicbook {
        // TODO: nil and range checking
        return comicbooks[selectedComicbookIndex]
    }
    
    func getSelectedIssue() -> BookModel {
        // DUPE: 100 start
        let comicbook = getSelectedComicbook()
        let issueNumber = comicbook.series.publishedIssues[selectedIssueIndex]
        
        for (_, value) in comicbook.books {
            if issueNumber == value.issueNumber {
                // This ia a book the user owns or is tracking
                return value
            }
        }
        
        // This is a book the user doesn't own yet...
        return BookModel(seriesURI: comicbook.series.seriesURI, issueNumber: issueNumber, variantLetter: "", isOwned: false, coverImageID: "")
        // DUPE: 100 end
    }
    
    func selectNextComicbook() {
        
        var nextComicbookIndex = selectedComicbookIndex + 1
        if nextComicbookIndex >= comicbooks.count {
            nextComicbookIndex = 0
        }
        selectedComicbookIndex = nextComicbookIndex
        selectedIssueIndex = 0
    }
    
    func selectPreviousComicbook() {
        
        var previousComicbookIndex = selectedComicbookIndex - 1
        if previousComicbookIndex < 0 {
            previousComicbookIndex = comicbooks.count - 1
        }
        selectedComicbookIndex = previousComicbookIndex
        selectedIssueIndex = 0
    }
    
    func selectNextIssue() {
        let currentComicbook = getSelectedComicbook()
        var nextIssueIndex = selectedIssueIndex + 1
        if nextIssueIndex >= currentComicbook.series.publishedIssues.count {
            nextIssueIndex = 0
        }
        selectedIssueIndex = nextIssueIndex

    }
    
    func selectPreviousIssue() {
        let currentComicbook = getSelectedComicbook()
        var previousIssueIndex = selectedIssueIndex - 1
        if previousIssueIndex < 0 {
            previousIssueIndex = currentComicbook.series.publishedIssues.count - 1
        }
        selectedIssueIndex = previousIssueIndex
        
    }
}
