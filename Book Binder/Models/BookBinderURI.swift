//
//  BookBinderURI.swift
//  Book Binder
//
//  Created by John Pavley on 9/23/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

enum URIPart: Int {
    case publisher = 0
    case series = 1
    case era = 2
    case issue = 3
    case varient = 4
    case consumption = 5
}

/// MVP 1: Simple URI format.
/// - Publisher/Series/Era/Issue/Varient
/// - Full URI: "Marvel Entertainment/DoctorStrange/2018/1/v"
/// - No Varient URI: "Ziff Davis/GI Joe/1950/10"
/// - Series URI: "DC/Superman/2005"
struct BookBinderURI: CustomStringConvertible {
    
    var publisherID: String
    var seriesID: String
    var eraID: String
    var issueID: String
    var varientID: String
    var consumptionID: String
    
    /// URI format: publisher/series/era/issue/varient/consumption
    var description: String {
        
        var result = ""
        
        result += publisherID != "" ? "\(publisherID)" : ""
        result += seriesID != "" ? "/\(seriesID)" : ""
        result += eraID != "" ? "/\(eraID)" : ""
        result += issueID != "" ? "/\(issueID)" : ""
        result += varientID != "" ? "/\(varientID)" : ""
        result += consumptionID != "" ? "/\(consumptionID)" : ""
        
        return result
    }
    
    init(fromURIString s: String) {
        let parts = s.components(separatedBy: "/")
        
        publisherID = parts.count >= URIPart.publisher.rawValue + 1 ? parts[URIPart.publisher.rawValue] : ""
        seriesID = parts.count >= URIPart.series.rawValue + 1 ? parts[URIPart.series.rawValue] : ""
        eraID = parts.count >= URIPart.era.rawValue + 1 ? parts[URIPart.era.rawValue] : ""
        issueID = parts.count >= URIPart.issue.rawValue + 1 ? parts[URIPart.issue.rawValue] : ""
        varientID = parts.count >= URIPart.varient.rawValue + 1 ? parts[URIPart.varient.rawValue] : ""
        consumptionID = parts.count >= URIPart.consumption.rawValue + 1 ? parts[URIPart.consumption.rawValue] : ""
    }
}
