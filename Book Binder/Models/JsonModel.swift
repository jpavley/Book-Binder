//
//  JsonModel.swift
//  Book Binder
//
//  Created by John Pavley on 10/4/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

struct JsonModel: Codable {
    
    struct JsonSeries: Codable {
        let seriesPublisher: String
        let seriesTitle: String
        let seriesEra: Int
        let seriesVolume: Int
        let seriesFirstIssue: Int
        let seriesCurrentIssue: Int
        let seriesSkippedIssues: Int
        let seriesExtraIssues: Int
        let books: [JsonBook]
        
        struct JsonBook: Codable {
            let printing: Int
            let issueNumber: Int
            let variantLetter: String
            let isOwned: Bool
            let coverImageID: String
            
            init(printing: Int, issueNumber: Int, variantLetter: String, isOwned: Bool, coverImageID: String) {
                self.printing = printing
                self.issueNumber = issueNumber
                self.variantLetter = variantLetter
                self.isOwned = isOwned
                self.coverImageID = coverImageID
            }
        }
        
        init(seriesPublisher: String, seriesTitle: String, seriesEra: Int, seriesVolume: Int, seriesFirstIssue: Int, seriesCurrentIssue: Int, seriesSkippedIssues: Int, seriesExtraIssues: Int, books: [JsonBook]) {
            
            self.seriesPublisher = seriesPublisher
            self.seriesTitle = seriesTitle
            self.seriesEra = seriesEra
            self.seriesVolume = seriesVolume
            self.seriesFirstIssue = seriesFirstIssue
            self.seriesCurrentIssue = seriesCurrentIssue
            self.seriesSkippedIssues = seriesSkippedIssues
            self.seriesExtraIssues = seriesExtraIssues
            self.books = books
        }
    }
    
    let series: [JsonSeries]
    let selectedSeriesIndex: Int
    let selectedBookIndex: Int
    
    init(series: [JsonSeries], selectedSeriesIndex: Int, selectedBookIndex: Int) {
        
        self.series = series
        self.selectedSeriesIndex = selectedSeriesIndex
        self.selectedBookIndex = selectedBookIndex
    }
}


