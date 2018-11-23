//
//  ComicBookCover.swift
//  Book Binder
//
//  Created by John Pavley on 11/23/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

class ComicBookCover {
    
    var defaultCovers: [String:String]
    
    init(defaultCovers: [String:String]) {
        self.defaultCovers = defaultCovers
    }
    
    func coverIDForPublisher(publisherID: String) -> String {
        
        if let coverID = defaultCovers[publisherID] {
            return coverID
        } else {
            return "american-standard-dc"
        }
    }
        
}
