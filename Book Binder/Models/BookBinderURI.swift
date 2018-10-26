//
//  BookBinderURI.swift
//  Book Binder
//
//  Created by John Pavley on 9/23/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// Parts of a URI mapped to postion in a URI string.
/// publisher/title/era/volume/printing/issue/variant
enum URIPart: Int {
    case publisher = 0
    case title = 1
    case era = 2
    case volume = 3
    case printing = 4
    case issue = 5
    case variant = 6
}

/// MVP 1: Simple URI format.
/// "publisher/title/era/volume/printing/issue/variant".
/// - Full URI: "Marvel Entertainment/DoctorStrange/2018/1/1/1/v".
/// - Series URI: "Marvel Entertainment/DoctorStrange/2018/1///".
/// - Work URI: "////1/1/v".
/// - Empty URI: "//////".
struct BookBinderURI: CustomStringConvertible {
    
    /// Empty URI constant with the correct number of slashes.
    static let emptyURIString = "//////"
    
    /// Number of slashes that should be in every well formed URI.
    static let slashCount = 6
    
    /// String that represents a publisher like "Ziff Davis".
    var publisherPart: String
    
    /// String that represents the title of a series like "ROM Spaceknight".
    var titlePart: String
    
    /// String that represents an era date like "1950".
    var eraPart: String
    
    /// String that represents an volume number like "1".
    /// Most works have an implicit volume number.
    var volumePart: String
    
    /// String that represents a printing designation like "first".
    /// Most works have an implicit printing designation unless they are popular enough to be reprinted.
    var printingPart: String
    
    /// String that represents an issue number like "608"
    var issuePart: String
    
    /// String that represents a variant letter like "c"
    var variantPart: String
    
    /// Builds a string version of an URI based on the value of it's parts
    ///
    /// - Part Names: publisher/title/era/volume/printing/issue/variant
    /// - Parts Index: 0/1/2/3/4/5/6
    var description: String {
        
        var result = ""
        
        result += publisherPart != "" ? "\(publisherPart)" : ""
        result += titlePart != "" ? "/\(titlePart)" : "/"
        result += eraPart != "" ? "/\(eraPart)" : "/"
        result += volumePart != "" ? "/\(volumePart)" : "/"
        result += printingPart != "" ? "/\(printingPart)" : "/"
        result += issuePart != "" ? "/\(issuePart)" : "/"
        result += variantPart != "" ? "/\(variantPart)" : "/"
        
        return result
    }
    
    /// Initialize a URI from a well formed URI string
    ///
    /// - Part Names: publisher/title/era/volume/printing/issue/variant
    /// - Parts Index: 0/1/2/3/4/5/6
    init?(fromURIString s: String) {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            print("** BAD URI \(s)")
            return nil
        }
        
        publisherPart = BookBinderURI.part(fromURIString: s, partID: .publisher)
        titlePart = BookBinderURI.part(fromURIString: s, partID: .title)
        eraPart = BookBinderURI.part(fromURIString: s, partID: .era)
        volumePart = BookBinderURI.part(fromURIString: s, partID: .volume)
        printingPart = BookBinderURI.part(fromURIString: s, partID: .printing)
        issuePart = BookBinderURI.part(fromURIString: s, partID: .issue)
        variantPart = BookBinderURI.part(fromURIString: s, partID: .variant)
    }
    
    /// Returns the specified part of an URI
    ///
    /// - Part Names: publisher/title/era/volume/printing/issue/variant
    /// - Parts Index: 0/1/2/3/4/5/6
    static func part(fromURIString s: String, partID: URIPart) -> String {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            return BookBinderURI.emptyURIString
        }
        
        let parts = s.components(separatedBy: "/")
        
        if parts.count > partID.rawValue {
            let part = parts[partID.rawValue]
            return part.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return ""
        }
    }
    
    /// Returns the just the series parts of an URI
    ///
    /// - Part Names: publisher/title/era/volume///
    static func extractSeriesURIString(fromURIString s: String) -> String {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            return BookBinderURI.emptyURIString
        }
        
        let parts = s.components(separatedBy: "/")
        
        let publisherPart = parts.count >= URIPart.publisher.rawValue + 1 ? parts[URIPart.publisher.rawValue] : ""
        let titlePart = parts.count >= URIPart.title.rawValue + 1 ? parts[URIPart.title.rawValue] : ""
        let eraPart = parts.count >= URIPart.era.rawValue + 1 ? parts[URIPart.era.rawValue] : ""
        let volumePart = parts.count >= URIPart.volume.rawValue + 1 ? parts[URIPart.volume.rawValue] : ""
        
        return "\(publisherPart)/\(titlePart)/\(eraPart)/\(volumePart)///"
    }
    
    var seriesPart: BookBinderURI {
        return BookBinderURI(fromURIString: BookBinderURI.extractSeriesURIString(fromURIString: self.description)) ?? BookBinderURI(fromURIString: BookBinderURI.emptyURIString)!
    }
    
    /// Returns returns true if a URI contains the correct number of "/"s
    ///
    /// - Part Names: //////
    static func isWellFormed(uriString: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: "/", options: .caseInsensitive)
        let count = regex?.matches(in: uriString, options: [], range: NSRange(location: 0, length: uriString.count)).count
        return count == BookBinderURI.slashCount
    }
}

extension BookBinderURI: Hashable {
    
    static func == (lhs: BookBinderURI, rhs: BookBinderURI) -> Bool {
        return lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
    
}
