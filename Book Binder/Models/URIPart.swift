//
//  URIPart.swift
//  BookBinderLab1
//
//  Created by John Pavley on 11/1/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// Parts of a URI mapped to postion in a URI string.
enum URIPart: Int {
    case version = 0
    case publisher = 1
    case series = 2
    case volume = 3
    case issue = 4
    case variant = 5
}
