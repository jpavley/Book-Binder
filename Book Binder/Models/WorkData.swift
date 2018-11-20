//
//  WorkData.swift
//  Book Binder
//
//  Created by John Pavley on 11/20/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// Struct for saving and restoring work object state. Readonly.
struct WorkData {
    let issueNumber: Int
    let variantLetter: String
    let coverImage: String
    let isOwned: Bool
    
    init(issueNumber: Int, variantLetter: String, coverImage: String, isOwned: Bool) {
        self.issueNumber = issueNumber
        self.variantLetter = variantLetter
        self.coverImage = coverImage
        self.isOwned = isOwned
    }
}

