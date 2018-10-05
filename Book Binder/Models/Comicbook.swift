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
}
// MARk: Comicbook Factories

extension Comicbook {
    
    static func createSeriesURIFrom(jsonModel: JsonModel) -> BookBinderURI {
        let uriString = "\(jsonModel.seriesPublisher)/\(jsonModel.seriesTitle)/\(jsonModel.seriesEra)"
        return BookBinderURI(fromURIString: uriString)
    }
    
    static func createFrom(jsonModel: JsonModel) -> Comicbook {
        
        let seriesURI = createSeriesURIFrom(jsonModel: jsonModel)
        
        let comicbook = Comicbook(seriesURI: seriesURI)
        comicbook.series.seriesFirstIssue = jsonModel.seriesFirstIssue
        comicbook.series.seriesCurrentIssue = jsonModel.seriesCurrentIssue
        comicbook.series.seriesSkippedIssues = jsonModel.seriesSkippedIssues
        comicbook.series.seriesExtraIssues = jsonModel.seriesExtraIssues
        
        for jsonBook in jsonModel.books {
            let book = BookModel(seriesURI: comicbook.series.seriesURI, issueNumber: jsonBook.issueNumber, variantLetter: jsonBook.variantLetter, isOwned: jsonBook.isOwned)
            comicbook.books.append(book)
        }

        return comicbook
    }
    
    static func createFrom(jsonData: Data) -> Comicbook? {
        do {
            let decoder = JSONDecoder()
            let jsonModel = try decoder.decode(JsonModel.self, from: jsonData)
            let comicbook = Comicbook.createFrom(jsonModel: jsonModel)
            return comicbook
        } catch {
            // handle error
        }
        return nil
    }
    
    static func createFrom(jsonString: String) -> Comicbook {
        let jsonData = jsonString.data(using: .utf8)!
        return createFrom(jsonData: jsonData)!
    }
    
}
