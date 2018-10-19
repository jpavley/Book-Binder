//
//  Comicbook.swift
//  Book Binder
//
//  Created by John Pavley on 10/4/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

class Comicbook {
    var series: SeriesModel
    var books: [BookBinderURI: BookModel]
    
    init(seriesURI: BookBinderURI) {
        series = SeriesModel(fromURI: seriesURI)
        books = [BookBinderURI: BookModel]()
    }
    
    /// Returns a list of owned issue numbers as a string
    func ownedIssues() -> [String] {
        let foundIssues = books.map { $0.value.isOwned ? "\($0.value.issueNumber)" : "" }
        return foundIssues.sorted()
    }
    
    /// Returns a list of books that match the issue number.
    /// Because of varients this could be more than one.
    func getBookBy(issueNumber: Int) -> [BookModel] {
        //return books.filter { $0.value.issueNumber == issueNumber}.first
        
        var result = [BookModel]()
        
        for (_, value) in books {
            if value.issueNumber == issueNumber {
                result.append(value)
            }
        }
        return result
    }
    
}
// MARk: Comicbook Factories

extension Comicbook {
    
    /// Returns a series URI from a JsonModel
    static func createSeriesURIFrom(jsonSeries: JsonModel.JsonSeries) -> BookBinderURI {
        
        let uriString = "\(jsonSeries.seriesPublisher)/\(jsonSeries.seriesTitle)/\(jsonSeries.seriesEra)//"
        return BookBinderURI(fromURIString: uriString)
    }
    
    /// Returns an array of Comicbooks from a JsonModel
    /// - A JsonModel contains data for 0 to n Comicbooks
    static func createFrom(jsonModel: JsonModel) -> ([Comicbook], Int, Int) {
        
        var comicbooks = [Comicbook]()
        
        for jsonSeries in jsonModel.series {
        
            let seriesURI = createSeriesURIFrom(jsonSeries: jsonSeries)
            let comicbook = Comicbook(seriesURI: seriesURI)
            
            comicbook.series.seriesFirstIssue = jsonSeries.seriesFirstIssue
            comicbook.series.seriesCurrentIssue = jsonSeries.seriesCurrentIssue
            comicbook.series.seriesSkippedIssues = jsonSeries.seriesSkippedIssues
            comicbook.series.seriesExtraIssues = jsonSeries.seriesExtraIssues
                        
            for jsonBook in jsonSeries.books {
                let book = BookModel(seriesURI: comicbook.series.seriesURI, issueNumber: jsonBook.issueNumber, variantLetter: jsonBook.variantLetter, isOwned: jsonBook.isOwned, coverImageID: jsonBook.coverImageID)
                comicbook.books[book.bookURI] = book
            }
            
            comicbooks.append(comicbook)
        }
        
        let selectedSeriesIndex = jsonModel.selectedSeriesIndex
        let selectedBookIndex = jsonModel.selectedBookIndex

        return (comicbooks, selectedSeriesIndex, selectedBookIndex)
    }
    
    /// Returns an optional array of Comicbooks from data that encodes a JsonModel
    /// - Calls createFrom(jsonModel:)
    static func createFrom(jsonData: Data) -> ([Comicbook], Int, Int)? {
        do {
            let decoder = JSONDecoder()
            let jsonModel = try decoder.decode(JsonModel.self, from: jsonData)
            return Comicbook.createFrom(jsonModel: jsonModel)
        } catch {
            // TODO: Probably malformed JSON data
            print(error)
        }
        return nil
    }
    
    /// Returns an optional array of Comicbooks from a string that expresses a JsonModel
    /// - Calls createFrom(jsonString:)
    static func createFrom(jsonString: String) -> ([Comicbook], Int, Int)? {
        let jsonData = jsonString.data(using: .utf8)!
        return createFrom(jsonData: jsonData)
    }
}
