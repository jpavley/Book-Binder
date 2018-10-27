//
//  ComicbookSeries.swift
//  Book Binder
//
//  Created by John Pavley on 10/4/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

class ComicbookSeries: Series {
    
    convenience init(seriesURI: BookBinderURI) {
        self.init(uri: seriesURI, firstIssue: 0, currentIssue: 0)
    }
    
    /// Returns a list of owned issue numbers as a string
    func ownedIssues() -> [String] {
        let foundIssues = works.map { $0.value.isOwned ? "\($0.value.issueNumber)" : "" }
        return foundIssues.sorted()
    }
    
    /// Returns a list of books that match the issue number.
    /// Because of varients this could be more than one.
    func getBookBy(issueNumber: Int) -> [Work] {
        //return books.filter { $0.value.issueNumber == issueNumber}.first
        
        var result = [Work]()
        
        for (_, value) in works {
            if value.issueNumber == issueNumber {
                result.append(value)
            }
        }
        return result
    }
    
}
// MARk: Comicbook Factories

extension ComicbookSeries {
    
    /// Returns a series URI from a JsonModel
    static func createSeriesURIFrom(jsonSeries: JsonModel.JsonSeries) -> BookBinderURI? {
        
        let uriString = "\(jsonSeries.seriesPublisher)/\(jsonSeries.seriesTitle)/\(jsonSeries.seriesEra)/\(jsonSeries.seriesVolume)///"
        if let uri = BookBinderURI(fromURIString: uriString) {
            return uri
        } else {
            return nil
        }

    }
    
    /// Returns an array of Comicbooks from a JsonModel
    /// - A JsonModel contains data for 0 to n Comicbooks
    static func createFrom(jsonModel: JsonModel) -> ([ComicbookSeries], Int, Int) {
        
        var comicbookSeriesList = [ComicbookSeries]()
        
        for jsonSeries in jsonModel.series {
        
            if let seriesURI = createSeriesURIFrom(jsonSeries: jsonSeries) {
                
                let comicbookSeries = ComicbookSeries(seriesURI: seriesURI)
                
                comicbookSeries.firstIssue = jsonSeries.seriesFirstIssue
                comicbookSeries.currentIssue = jsonSeries.seriesCurrentIssue
                comicbookSeries.skippedIssues = jsonSeries.seriesSkippedIssues
                
                for jsonBook in jsonSeries.books {
                    let book = Work(seriesURI: comicbookSeries.uri, printing: jsonBook.printing, issueNumber: jsonBook.issueNumber, variantLetter: jsonBook.variantLetter, isOwned: jsonBook.isOwned, coverImageID: jsonBook.coverImageID)
                    comicbookSeries.works[book.uri] = book
                }
                
                comicbookSeriesList.append(comicbookSeries)
            }
        }
        
        let selectedSeriesIndex = jsonModel.selectedSeriesIndex
        let selectedBookIndex = jsonModel.selectedBookIndex

        return (comicbookSeriesList, selectedSeriesIndex, selectedBookIndex)
    }
    
    /// Returns an optional array of Comicbooks from data that encodes a JsonModel
    /// - Calls createFrom(jsonModel:)
    static func createFrom(jsonData: Data) -> ([ComicbookSeries], Int, Int)? {
        do {
            let decoder = JSONDecoder()
            let jsonModel = try decoder.decode(JsonModel.self, from: jsonData)
            return ComicbookSeries.createFrom(jsonModel: jsonModel)
        } catch {
            // TODO: Probably malformed JSON data
            print(error)
        }
        return nil
    }
    
    /// Returns an optional array of Comicbooks from a string that expresses a JsonModel
    /// - Calls createFrom(jsonString:)
    static func createFrom(jsonString: String) -> ([ComicbookSeries], Int, Int)? {
        let jsonData = jsonString.data(using: .utf8)!
        return createFrom(jsonData: jsonData)
    }
}
