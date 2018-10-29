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
        let seriesSkippedIssues: [Int]
        let books: [JsonBook]
        
        struct JsonBook: Codable {
            let issueNumber: Int
            let variants: [JsonVariant]
            
            struct JsonVariant: Codable {
                let printing: Int
                let letter: String
                let isOwned: Bool
                let coverImageID: String
                
                init(printing: Int, variantLetter: String, isOwned: Bool, coverImageID: String) {
                    self.printing = printing
                    self.letter = variantLetter
                    self.isOwned = isOwned
                    self.coverImageID = coverImageID
                }
           }
            
            init(issueNumber: Int, variants: [JsonVariant]) {
                self.issueNumber = issueNumber
                self.variants = variants
            }
        }
        
        init(publisher: String, title: String, era: Int, volumeNumber: Int, firstIssue: Int, currentIssue: Int, skippedIssues: [Int], books: [JsonBook]) {
            
            self.seriesPublisher = publisher
            self.seriesTitle = title
            self.seriesEra = era
            self.seriesVolume = volumeNumber
            self.seriesFirstIssue = firstIssue
            self.seriesCurrentIssue = currentIssue
            self.seriesSkippedIssues = skippedIssues
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


