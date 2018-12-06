//
//  WorkData.swift
//  Book Binder
//
//  Created by John Pavley on 11/20/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

enum Action {
    case update, delete
}

/// Struct for saving and restoring work object state. Readonly.
struct WorkData {
    let actionKind: Action
    let issueNumber: Int
    let variantLetter: String
    let coverImage: String
    let isOwned: Bool
    
    init(actionKind: Action, issueNumber: Int, variantLetter: String, coverImage: String, isOwned: Bool) {
        self.actionKind = actionKind
        self.issueNumber = issueNumber
        self.variantLetter = variantLetter
        self.coverImage = coverImage
        self.isOwned = isOwned
    }
}

