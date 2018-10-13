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
        let issueNumber = comicbook.series.publishedIssues[selectedIssueIndex]
        
        for book in comicbook.books {
            if issueNumber == book.issueNumber {
                // This ia a book the user owns or is tracking
                return book
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
