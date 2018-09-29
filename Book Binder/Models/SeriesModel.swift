//
//  SeriesModel.swift
//  Book Binder
//
//  Created by John Pavley on 9/23/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// MVP 1: Just enough to get the Summary View displayed.
/// The Series Model extrapolates the number of issues between the
/// first and the current. If the current issue of Daredevil
/// is 608, SeriesModel decides that there are 607 issues before issue
/// 608 with the first issue being one. But this is not always the
/// case! Sometimes series might start at a random number. Doctor Strange
/// 1968 started at issue 169 and 2017 started at issue 381.
class SeriesModel {
    
    /// Title of the series
    var seriesPublisher: String

    /// Title of the series
    var seriesTitle: String
    
    /// Era of the series
    var seriesEra: String
    
    /// Assume that the first issue in a series is number 1
    var seriesFirstIssue = 1
    
    /// Assume that all series have at least one issue
    var seriesCurrentIssue = 1
    
    /// Assume that no issues in series were skipped
    var seriesSkippedIssues = 0
    
    /// Assume that no extra issues in the series were added
    var seriesExtraIssues = 0
    
    /// Initialization by properties
    init(seriesPublisher: String, seriesTitle: String, seriesEra: String) {
        self.seriesPublisher = seriesPublisher
        self.seriesTitle = seriesTitle
        self.seriesEra = seriesEra
    }
    
    /// Initalization by URI
    init(fromURI: BookBinderURI) {
        self.seriesPublisher = fromURI.publisherID
        self.seriesTitle = fromURI.seriesID
        self.seriesEra = fromURI.eraID
    }
}

// MARK: Calculated Vars

extension SeriesModel {
    
    /// URI that identifies this series
    var seriesURI: BookBinderURI {
        return BookBinderURI(fromURIString: "\(seriesPublisher)/\(seriesTitle)/\(seriesEra)")
    }
    
    /// Number of possible issues if no numbers are skipped
    var publishedIssueCount: Int {
        let sequentialIssues = seriesCurrentIssue - (seriesFirstIssue - 1)
        return sequentialIssues + seriesExtraIssues - seriesSkippedIssues
    }
}
