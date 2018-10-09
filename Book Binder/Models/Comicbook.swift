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
    var books: [BookModel]
    
    init(seriesURI: BookBinderURI) {
        series = SeriesModel(fromURI: seriesURI)
        books = [BookModel]()
    }
    
    /// Returns a list of owned issue numbers as a string
    func ownedIssues() -> [String] {
        var result = [String]()
        for book in books {
            if book.isOwned {
                result.append("\(book.issueNumber)")
            }
        }
        return result
    }
    
    func getBookBy(issueNumber: Int) -> BookModel? {
        return books.filter { $0.issueNumber == issueNumber}.first
    }
    
}
// MARk: Comicbook Factories

extension Comicbook {
    
    /// Returns a series URI from a JsonModel
    static func createSeriesURIFrom(jsonModel: JsonModel) -> BookBinderURI {
        let uriString = "\(jsonModel.seriesPublisher)/\(jsonModel.seriesTitle)/\(jsonModel.seriesEra)"
        return BookBinderURI(fromURIString: uriString)
    }
    
    /// Returns an array of Comicbooks from a JsonModel
    /// - A JsonModel contains data for 0 to n Comicbooks
    static func createFrom(jsonModel: [JsonModel]) -> [Comicbook] {
        
        var comicbooks = [Comicbook]()
        
        for jsonComic in jsonModel {
        
            let seriesURI = createSeriesURIFrom(jsonModel: jsonComic)
            let comicbook = Comicbook(seriesURI: seriesURI)
            
            comicbook.series.seriesFirstIssue = jsonComic.seriesFirstIssue
            comicbook.series.seriesCurrentIssue = jsonComic.seriesCurrentIssue
            comicbook.series.seriesSkippedIssues = jsonComic.seriesSkippedIssues
            comicbook.series.seriesExtraIssues = jsonComic.seriesExtraIssues
                        
            for jsonBook in jsonComic.books {
                let book = BookModel(seriesURI: comicbook.series.seriesURI, issueNumber: jsonBook.issueNumber, variantLetter: jsonBook.variantLetter, isOwned: jsonBook.isOwned)
                comicbook.books.append(book)
            }
            
            comicbooks.append(comicbook)
        }

        return comicbooks
    }
    
    /// Returns an optional array of Comicbooks from data that encodes a JsonModel
    /// - Calls createFrom(jsonModel:)
    static func createFrom(jsonData: Data) -> [Comicbook]? {
        do {
            let decoder = JSONDecoder()
            let jsonModel = try decoder.decode([JsonModel].self, from: jsonData)
            return Comicbook.createFrom(jsonModel: jsonModel)
        } catch {
            // TODO: Probably malformed JSON data
        }
        return nil
    }
    
    /// Returns an optional array of Comicbooks from a string that expresses a JsonModel
    /// - Calls createFrom(jsonString:)
    static func createFrom(jsonString: String) -> [Comicbook]? {
        let jsonData = jsonString.data(using: .utf8)!
        return createFrom(jsonData: jsonData)
    }
    
}
