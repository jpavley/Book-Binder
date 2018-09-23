//
//  BookBinderURI.swift
//  Book Binder
//
//  Created by John Pavley on 9/23/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// MVP 1: Simple URI format.
/// - "Marvel Entertainment/2018/Daredevil/583/"
/// - "Marvel Entertainment/2018/DoctorStrange/1/v"
/// - "Marvel Comics Group/1979/ROM Spaceknight/70/"
struct BookBinderURI: CustomStringConvertible {
    
    var publisherID: String
    var eraID: String
    var seriesID: String
    var issueID: String
    var varientID: String
    
    var description: String {
        return "\(publisherID)/\(eraID)/\(seriesID)/\(issueID)/\(varientID)"
    }
    
    init(fromURIString s: String) {
        let parts = s.components(separatedBy: "/")
        
        publisherID = parts.count >= 1 ? parts[0] : ""
        eraID = parts.count >= 2 ? parts[1] : ""
        seriesID = parts.count >= 3 ? parts[2] : ""
        issueID = parts.count > 4 ? parts[3] : ""
        varientID = parts.count > 5 ? parts[4] : ""
    }
}
