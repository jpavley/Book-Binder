//
//  BookBinder.swift
//  Book Binder
//
//  Created by John Pavley on 10/9/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

class BookBinder {
    var comicbooks: [ComicbookSeries]
    var selectedComicbookIndex: Int
    var selectedIssueIndex: Int
    
    var jsonModel: JsonModel {
        
        var jsonSeriesArray = [JsonModel.JsonSeries]()
        var jsonBookArray = [JsonModel.JsonSeries.JsonBook]()
        
        for comicbook in comicbooks {
            
            for (_, book) in comicbook.works {
                let jsonBook = JsonModel.JsonSeries.JsonBook(printing: book.printing, issueNumber: book.issueNumber, variantLetter: book.variantLetter, isOwned: book.isOwned, coverImageID: book.coverImageID)
                jsonBookArray.append(jsonBook)
            }
            
            
            let jsonSeries = JsonModel.JsonSeries(publisher: comicbook.publisher,
                                                  title: comicbook.title,
                                                  era: comicbook.era,
                                                  volumeNumber: comicbook.volumeNumber,
                                                  firstIssue: comicbook.firstIssue,
                                                  currentIssue: comicbook.currentIssue,
                                                  skippedIssues: comicbook.skippedIssues,
                                                  books: jsonBookArray)
            jsonSeriesArray.append(jsonSeries)

        }
        
        return JsonModel(series: jsonSeriesArray, selectedSeriesIndex: selectedComicbookIndex, selectedBookIndex: selectedIssueIndex)
    }
    
    init(comicbooks: [ComicbookSeries], selectedComicbookIndex: Int, selectedIssueIndex: Int) {
        self.comicbooks = comicbooks
        self.selectedComicbookIndex = selectedComicbookIndex
        self.selectedIssueIndex = selectedIssueIndex
    }
    
    /// Modifies the selected comicbook's books array by either updating an existing book
    /// or adding a book if it doesn't exist
    func updateBooks(with modifiedBook: Work) {
        let selectedComicbook = getSelectedComicbook()
        var books = selectedComicbook.works
        
        if selectedComicbook.uri.description != modifiedBook.seriesURI.description {
            assert(true, "BOOKBINDERAPP: you can't add or modify a book with a series URI different from the comicbook's series URI!")
            return
        }
        
        if let oldValue = books.updateValue(modifiedBook, forKey: modifiedBook.uri) {
            assert(true, "BOOKBINDERAPP: the old value of \(oldValue.debugDescription) was replaced with \(modifiedBook.debugDescription)")
        } else {
            assert(true, "BOOKBINDERAPP: no old value for \(modifiedBook.debugDescription) was found so it was added as a new value")
        }
        
        selectedComicbook.works = books
    }
    
    func getSelectedComicbook() -> ComicbookSeries {
        // TODO: nil and range checking
        return comicbooks[selectedComicbookIndex]
    }
    
    func getSelectedIssue() -> Work {
        let comicbook = getSelectedComicbook()
        let issueNumber = comicbook.publishedIssues[selectedIssueIndex]
        
        for (_, value) in comicbook.works {
            if issueNumber == value.issueNumber {
                // This ia a book the user owns or is tracking
                return value
            }
        }
        
        // This is a book the user doesn't own yet...
        let publisherID = BookBinderURI.part(fromURIString: comicbook.uri.description, partID: .publisher)
        let coverImageID = publisherCover(for: publisherID)
        return Work(seriesURI: comicbook.uri, printing: 0, issueNumber: issueNumber, variantLetter: "", isOwned: false, coverImageID: coverImageID)
    }
    
    func publisherCover(for publisher: String) -> String {
        switch publisher {
        case "Marvel Entertainment":
            return "marvel-placeholder-1"
        case "DC Comics":
            return "dc-placeholder-1"
        default:
            return "golden-age-placeholder-1"
        }
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
        if nextIssueIndex >= currentComicbook.publishedIssues.count {
            nextIssueIndex = 0
        }
        selectedIssueIndex = nextIssueIndex

    }
    
    func selectPreviousIssue() {
        let currentComicbook = getSelectedComicbook()
        var previousIssueIndex = selectedIssueIndex - 1
        if previousIssueIndex < 0 {
            previousIssueIndex = currentComicbook.publishedIssues.count - 1
        }
        selectedIssueIndex = previousIssueIndex
        
    }
}
