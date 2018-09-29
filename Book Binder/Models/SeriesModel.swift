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
    
    /// Used to tie this series to a publisher and era
    var seriesURI: BookBinderURI
    
    /// Title of the series
    var seriesTitle: String
    
    /// Era of the series
    var seriesEra: String
    
    /// Books owned by the user from this series
    var books: [BookModel]
    
    /// Assume that the first issue in a series is number 1
    var firstIssueNumber = 1
    
    /// Assume that all series have at least one issue
    var currentIssueNumber = 1
    
    init(publisherName: String, seriesTitle: String, era: String) {
        self.seriesTitle = seriesTitle
        self.seriesEra = era
        books = [BookModel]()
        
        seriesURI = BookBinderURI(fromURIString: "\(publisherName)/\(seriesTitle)/\(era)")
    }
}
