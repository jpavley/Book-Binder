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
        let seriesFirstIssue: Int
        let seriesCurrentIssue: Int
        let seriesSkippedIssues: Int
        let seriesExtraIssues: Int
    }
    
    struct JsonBook: Codable {
        let issueNumber: Int
        let variantLetter: String
        let isOwned: Bool
    }
    
    let series: JsonSeries
    let books: [JsonBook]
}


