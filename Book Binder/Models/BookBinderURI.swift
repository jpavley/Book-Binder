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
    case variant = 4
    case consumption = 5
}

/// MVP 1: Simple URI format.
/// - Publisher/Series/Era/Issue/variant/consumption
/// - Full URI: "Marvel Entertainment/DoctorStrange/2018/1/v/owned"
/// - Missing Parts URI: "Marvel Entertainment//2018/1//owned"
/// - No variant URI: "Ziff Davis/GI Joe/1950/10"
/// - Series URI: "DC/Superman/2005"
struct BookBinderURI: CustomStringConvertible {
    
    /// String that represents a publisher like "Ziff Davis"
    var publisherID: String
    
    /// String that represents a series like "ROM Spaceknight"
    var seriesID: String
    
    /// String that represents an era date like "1950"
    var eraID: String
    
    /// String that represents an issue number like "608"
    var issueID: String
    
    /// String that represents a variant letter like "c"
    var variantID: String
    
    /// String that represents a consumption state liked "owned" or "read"
    var consumptionID: String
    
    /// Builds a string version of an URI based on the value of it's parts
    ///
    /// - URI format: publisher/series/era/issue/variant/consumption
    var description: String {
        
        var result = ""
        
        result += publisherID != "" ? "\(publisherID)" : ""
        result += seriesID != "" ? "/\(seriesID)" : "/"
        result += eraID != "" ? "/\(eraID)" : "/"
        result += issueID != "" ? "/\(issueID)" : "/"
        result += variantID != "" ? "/\(variantID)" : "/"
        result += consumptionID != "" ? "/\(consumptionID)" : "/"
        
        return result
    }
    
    init(fromURIString s: String) {
        let parts = s.components(separatedBy: "/")
        
        publisherID = parts.count >= URIPart.publisher.rawValue + 1 ? parts[URIPart.publisher.rawValue] : ""
        seriesID = parts.count >= URIPart.series.rawValue + 1 ? parts[URIPart.series.rawValue] : ""
        eraID = parts.count >= URIPart.era.rawValue + 1 ? parts[URIPart.era.rawValue] : ""
        issueID = parts.count >= URIPart.issue.rawValue + 1 ? parts[URIPart.issue.rawValue] : ""
        variantID = parts.count >= URIPart.variant.rawValue + 1 ? parts[URIPart.variant.rawValue] : ""
        consumptionID = parts.count >= URIPart.consumption.rawValue + 1 ? parts[URIPart.consumption.rawValue] : ""
    }
    
    static func part(fromURIString s: String, partID: URIPart) -> String {
        
        let parts = s.components(separatedBy: "/")
        
        if parts.count > partID.rawValue {
            return parts[partID.rawValue]
        } else {
            return ""
        }
    }
}
