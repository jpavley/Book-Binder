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
    
    /// Returns a JsonModel for the current ComicbookSeries in this BookBinder.
    /// (Serialization to JSON.)
    var jsonModel: JsonModel {
        
        var jsonSeriesArray = [JsonModel.JsonSeries]()
        var jsonBookArray = [JsonModel.JsonSeries.JsonBook]()
        var jsonVariantArray = [JsonModel.JsonSeries.JsonBook.JsonVariant]()
        
        for comicbook in comicbooks {
            
            for (_, book) in comicbook.works {
                
                for variant in book.variants {
                    jsonVariantArray.append(JsonModel.JsonSeries.JsonBook.JsonVariant(printing: variant.printing,
                                                                                      variantLetter: variant.letter,
                                                                                      isOwned: variant.isOwned,
                                                                                      coverImageID: variant.coverImageID))
                }
                
                let jsonBook = JsonModel.JsonSeries.JsonBook(issueNumber: book.issueNumber, variants: jsonVariantArray)
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
    /// or adding a book if it doesn't exist.
    func updateBooks(with modifiedBook: Work, and modifiedVariant: WorkVarient) {
        let selectedComicbook = getSelectedComicbookSeries()
        var books = selectedComicbook.works
        
        if selectedComicbook.uri.description != modifiedBook.seriesURI.description {
            assert(true, "BOOKBINDERAPP: you can't add or modify a book with a series URI different from the comicbook's series URI!")
            return
        }
        
        // replace an existing variant with the modified variant
        // copy over all the variants but replace the changed variant with the modified variant
        var updatedVariantList = modifiedBook.variants
        
        for variant in modifiedBook.variants {
            
            if variant.letter == modifiedVariant.letter {
                
                updatedVariantList.append(modifiedVariant)
            } else {
                
                updatedVariantList.append(variant)
            }
        }
        
        // copy over the updated list of variants into an updated book
        let updatedBook = Work(seriesURI: modifiedBook.seriesURI, issueNumber: modifiedBook.issueNumber, variants: updatedVariantList)
        
        // try to update the books dictionary or add a new book
        if let oldValue = books.updateValue(updatedBook, forKey: updatedBook.uri) {
            assert(true, "BOOKBINDERAPP: the old value of \(oldValue.debugDescription) was replaced with \(updatedBook.debugDescription)")
        } else {
            assert(true, "BOOKBINDERAPP: no old value for \(updatedBook.debugDescription) was found so it was added as a new value")
        }
        
        selectedComicbook.works = books
    }
    
    func getSelectedComicbookSeries() -> ComicbookSeries {
        // TODO: nil and range checking
        return comicbooks[selectedComicbookIndex]
    }
    
    /// One of the most important functions in the whole app!
    /// Either returns an existing Work contained in a ComicBookSeries or creates a Work
    /// if the selected issue doesn't yet exist. This function assumes that the user is simply
    /// not tracking all the Works of a Series as there could be hundreds. This is an example of
    /// the Flyweight pattern: "Large number of objects should be supported efficiently. Creating
    /// large numbers of objects should be avoided.
    func getSelectedIssue() -> Work {
        let comicbookSeries = getSelectedComicbookSeries()
        let issueNumber = comicbookSeries.publishedIssues[selectedIssueIndex]
        
        for (_, value) in comicbookSeries.works {
            if issueNumber == value.issueNumber {
                // This ia a book the user owns or is tracking
                return value
            }
        }
        
        // This is a book the user doesn't own yet...
        let publisherID = BookBinderURI.part(fromURIString: comicbookSeries.uri.description, partID: .publisher)
        let coverImageID = publisherCover(for: publisherID)
        let variant = WorkVarient(printing: 0, letter: "", coverImageID: coverImageID, isOwned: false)
        return Work(seriesURI: comicbookSeries.uri, issueNumber: issueNumber, variants: [variant])
    }
    
    func publisherCover(for publisher: String) -> String {
        switch publisher {
        case "Marvel Entertainment":
            return "american-standard-marvel"
        case "DC Comics":
            return "american-standard-dc"
        default:
            return "american-standard-ga"
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
        let currentComicbook = getSelectedComicbookSeries()
        var nextIssueIndex = selectedIssueIndex + 1
        if nextIssueIndex >= currentComicbook.publishedIssues.count {
            nextIssueIndex = 0
        }
        selectedIssueIndex = nextIssueIndex

    }
    
    func selectPreviousIssue() {
        let currentComicbook = getSelectedComicbookSeries()
        var previousIssueIndex = selectedIssueIndex - 1
        if previousIssueIndex < 0 {
            previousIssueIndex = currentComicbook.publishedIssues.count - 1
        }
        selectedIssueIndex = previousIssueIndex
        
    }
}
