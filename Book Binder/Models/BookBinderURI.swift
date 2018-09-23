//
//  BookBinderURI.swift
//  Book Binder
//
//  Created by John Pavley on 9/23/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

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
    
    var description: String {
        // return "\(publisherID)/\(seriesID)/\(eraID)/\(issueID)/\(varientID)"
        
        var result = ""
        
        result += publisherID != "" ? "\(publisherID)" : ""
        result += seriesID != "" ? "/\(seriesID)" : ""
        result += eraID != "" ? "/\(eraID)" : ""
        result += issueID != "" ? "/\(issueID)" : ""
        result += varientID != "" ? "/\(varientID)" : ""
        
        return result
    }
    
    init(fromURIString s: String) {
        let parts = s.components(separatedBy: "/")
        
        publisherID = parts.count >= 1 ? parts[0] : ""
        seriesID = parts.count >= 2 ? parts[1] : ""
        eraID = parts.count >= 3 ? parts[2] : ""
        issueID = parts.count >= 4 ? parts[3] : ""
        varientID = parts.count >= 5 ? parts[4] : ""
    }
}
