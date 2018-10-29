//
//  WorkVariant.swift
//  Book Binder
//
//  Created by John Pavley on 10/27/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

class WorkVarient {
    var printing: Int
    var letter: String
    var coverImageID: String
    var isOwned: Bool
    
    init(printing: Int, letter: String, coverImageID: String, isOwned: Bool) {
        self.printing = printing
        self.letter = letter
        self.coverImageID = coverImageID
        self.isOwned = isOwned
    }
}
