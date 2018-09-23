//
//  SeriesModel.swift
//  Book Binder
//
//  Created by John Pavley on 9/23/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// MVP 1: Just enough to get the Summary View displayed
class SeriesModel {
    
    // Used to tie this series to a publisher and eara
    var seriesURI: BookBinderURI
    
    // Title of the series
    var seriesTitle: String
    
    // Books included in this series
    var books: [BookModel]
    
    init(publisherName: String, seriesTitle: String, era: String) {
        self.seriesTitle = seriesTitle
        books = [BookModel]()
        
        seriesURI = BookBinderURI(fromURIString: "\(publisherName)/\(seriesTitle)/\(era)")
    }
}
