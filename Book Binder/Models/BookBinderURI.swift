//
//  BookBinderURI.swift
//  BookBinderLab1
//
//  Created by John Pavley on 11/1/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation
/**
 MVP 3: Simple URI format with versioning and only the parts it needs to support JsonModel.
 - Note:
     - Parts: version/publisher/series/volume/issue/variant
     - Type: Int/String/String/Int/Int/String
     - Index: 0/1/2/3/4/5
     - All valid URIs begin with a version number and contain a the correct number of slashes for that version.
     - Empty parts are **OK** but missing slashes are **not OK**
     - Syntax: Version 1 URIs start the Integer 1 and contain five slashes.
     - Example Full URI: "1/Marvel Entertainment/DoctorStrange/2018/1/c".
     - Example Empty URI: "1/////".
*/
struct BookBinderURI {
    
    // MARK:- URI validation properties
    
    static let currentVersion = 1
    static let slashCount = 5
    static let emptyURIString = "1/////"
    
    // MARK:- Part Properties
    
    /// String that represents a URI version prefix like "1".
    var versionPart: String
    
    /// String that represents a publisher like "Ziff Davis".
    var publisherPart: String
    
    /// String that represents the title of a series like "ROM Spaceknight".
    var seriesPart: String
    
    /// String that represents an volume number like "1".
    var volumePart: String
    
    /// String that represents an issue number like "608"
    var issuePart: String
    
    /// String that represents a variant letter like "c"
    var variantPart: String
    
    // MARK:- Initialization
    
    /**
     Creates an empty URI which is not valid (/////)
    */
    init() {
        versionPart = ""
        publisherPart = ""
        seriesPart = ""
        volumePart = ""
        issuePart = ""
        variantPart = ""
    }
    
    /**
     Create a URI from the supplied parameters.
     - Parameters:
         - versionPart: String that represents a URI version prefix like "1".
         - publisherPart: String that represents a publisher like "Ziff Davis".
         - seriesPart: String that represents the title of a series like "ROM Spaceknight".
         - volumePart: String that represents an volume number like "1".
         - issuePart: String that represents an issue number like "608"
         - variantPart: String that represents a variant letter like "c"
    */
    init(versionPart: String, publisherPart: String, seriesPart: String, volumePart: String, issuePart: String, variantPart: String) {
        
        self.versionPart = versionPart
        self.publisherPart = publisherPart
        self.seriesPart = seriesPart
        self.volumePart = volumePart
        self.issuePart = issuePart
        self.variantPart = variantPart
    }
    
    /**
     Create a URI from a well formed URI string.
     - Parameter from: String representation of a URI
    */
    init?(from s: String) {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            print("** BAD URI \(s)")
            return nil
        }
        
        versionPart = BookBinderURI.part(from: s, partID: .version) ?? ""
        publisherPart = BookBinderURI.part(from: s, partID: .publisher) ?? ""
        seriesPart = BookBinderURI.part(from: s, partID: .series) ?? ""
        volumePart = BookBinderURI.part(from: s, partID: .volume) ?? ""
        issuePart = BookBinderURI.part(from: s, partID: .issue) ?? ""
        variantPart = BookBinderURI.part(from: s, partID: .variant) ?? ""
    }
    
    // MARK:- Methods
    
    /**
     Returns the specified part of an URI.
     - Parameter from: String representation of a URI
    */
    static func part(from s: String, partID: URIPart) -> String? {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            return nil
        }
        
        let parts = s.components(separatedBy: "/")
        
        if parts.count > partID.rawValue {
            let part = parts[partID.rawValue]
            return part.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return ""
    }
    
    // MARK:- Validation
    
    /**
     Returns returns true if a URI contains the correct number of "/"s and start with the correct version number.
     - Parameter uriString: A URI String representation to validate.
    */
    static func isWellFormed(uriString: String) -> Bool {
        
        func hasCorrectVersionNumber(target: Int) -> Bool {
            return uriString.starts(with: "\(target)")
        }
        
        func hasCorrectNumberOfSlashes(target: Int) -> Bool {
            let regex = try? NSRegularExpression(pattern: "/", options: .caseInsensitive)
            let count = regex?.matches(in: uriString, options: [], range: NSRange(location: 0, length: uriString.count)).count
            return count == target
        }
        
        let version = hasCorrectVersionNumber(target: BookBinderURI.currentVersion)
        let slashes = hasCorrectNumberOfSlashes(target: BookBinderURI.slashCount)
        
        return version && slashes
    }
}

extension BookBinderURI: CustomStringConvertible {
    
    /**
     Returns a string version of an URI based on the value of it's parts.
    */
    var description: String {
        
        func makePart(part: String) -> String {
            return part != "" ? "/\(part)" : "/"
        }
        
        var result = ""
        
        result += makePart(part: versionPart)
        result += makePart(part: publisherPart)
        result += makePart(part: seriesPart)
        result += makePart(part: volumePart)
        result += makePart(part: issuePart)
        result += makePart(part: variantPart)
        
        result = String(result.dropFirst())
        
        return result
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

