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
    
    func getSelectedComicbook() -> Comicbook {
        // TODO: nil and range checking
        return comicbooks[selectedComicbookIndex]
    }
    
    func getSelectedIssue() -> BookModel {
        // DUPE: 100 start
        let comicbook = getSelectedComicbook()
        let issueNumber = selectedComicbookIndex
        
        for book in comicbook.books {
            if issueNumber == book.issueNumber {
                // This ia a book the user owns or is tracking
                return book
            }
        }
        
        // This is a book the user doesn't own yet...
        return BookModel(seriesURI: comicbook.series.seriesURI, issueNumber: issueNumber, variantLetter: "", isOwned: false)
        // DUPE: 100 end
    }
    
    func selectNextComicbook() {
        
        var nextComicbookIndex = selectedComicbookIndex + 1
        if nextComicbookIndex >= comicbooks.count {
            nextComicbookIndex = 0
        }
        selectedIssueIndex = nextComicbookIndex
    }
    
    func selectNextIssue() {
        let currentComicbook = getSelectedComicbook()
        var nextIssueIndex = selectedIssueIndex + 1
        if nextIssueIndex > currentComicbook.series.seriesCurrentIssue {
            nextIssueIndex = currentComicbook.series.seriesFirstIssue
        }
        selectedIssueIndex = nextIssueIndex

    }
    
    func selectPreviousIssue() {
        let currentComicbook = getSelectedComicbook()
        var previousIssueIndex = selectedIssueIndex - 1
        if previousIssueIndex < currentComicbook.series.seriesFirstIssue {
            previousIssueIndex = currentComicbook.series.seriesCurrentIssue
        }
        selectedIssueIndex = previousIssueIndex
        
    }
}
