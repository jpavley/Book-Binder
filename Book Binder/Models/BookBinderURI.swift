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
}

/// MVP 1: Simple URI format.
/// - Publisher/Series/Era/Issue/variant
/// - Full URI: "Marvel Entertainment/DoctorStrange/2018/1/v"
/// - Missing Parts URI: "Marvel Entertainment//2018//"
/// - No variant URI: "Ziff Davis/GI Joe/1950/10/"
/// - Series URI: "DC/Superman/2005"
/// - Empty URI: "////"
struct BookBinderURI: CustomStringConvertible {
    
    /// Number of slashes that should be in every well formed URI
    static let slashCount = 4
    
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
        
        return result
    }
    
    init(fromURIString s: String) {
        
        publisherID = BookBinderURI.part(fromURIString: s, partID: .publisher)
        seriesID = BookBinderURI.part(fromURIString: s, partID: .series)
        eraID = BookBinderURI.part(fromURIString: s, partID: .era)
        issueID = BookBinderURI.part(fromURIString: s, partID: .issue)
        variantID = BookBinderURI.part(fromURIString: s, partID: .variant)
  }
    
    static func part(fromURIString s: String, partID: URIPart) -> String {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            return "////"
        }
        
        let parts = s.components(separatedBy: "/")
        
        if parts.count > partID.rawValue {
            let part = parts[partID.rawValue]
            return part.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return ""
        }
    }
    
    static func extractSeriesURI(fromURIString s: String) -> String {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            return "//"
        }
        
        let parts = s.components(separatedBy: "/")
        
        let publisherID = parts.count >= URIPart.publisher.rawValue + 1 ? parts[URIPart.publisher.rawValue] : ""
        let seriesID = parts.count >= URIPart.series.rawValue + 1 ? parts[URIPart.series.rawValue] : ""
        let eraID = parts.count >= URIPart.era.rawValue + 1 ? parts[URIPart.era.rawValue] : ""

        return "\(publisherID)/\(seriesID)/\(eraID)//"
    }
    
    static func isWellFormed(uriString: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: "/", options: .caseInsensitive)
        let count = regex?.matches(in: uriString, options: [], range: NSRange(location: 0, length: uriString.count)).count
        return count == BookBinderURI.slashCount
    }
}
