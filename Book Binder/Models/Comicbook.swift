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
    
    static func createFrom(jsonString: String) -> Comicbook {
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let jsonModel = try! decoder.decode(JsonModel.self, from: jsonData)
        
        let testURIString = "\(jsonModel.seriesPublisher)/\(jsonModel.seriesTitle)/\(jsonModel.seriesEra)"
        let testURI = BookBinderURI(fromURIString: testURIString)
        
        let comicbook = Comicbook(seriesURI: testURI)
        comicbook.series.seriesFirstIssue = jsonModel.seriesFirstIssue
        comicbook.series.seriesCurrentIssue = jsonModel.seriesCurrentIssue
        comicbook.series.seriesSkippedIssues = jsonModel.seriesSkippedIssues
        comicbook.series.seriesExtraIssues = jsonModel.seriesExtraIssues
        
        for jsonBook in jsonModel.books {
            let book = BookModel(seriesURI: testURI, issueNumber: jsonBook.issueNumber, variantLetter: jsonBook.variantLetter, isOwned: jsonBook.isOwned)
            comicbook.books.append(book)
        }
        
        return comicbook
    }
}
