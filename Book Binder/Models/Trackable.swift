//
//  Trackable.swift
//  Book Binder
//
//  Created by John Pavley on 10/21/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

protocol Trackable: Hashable, CustomStringConvertible, CustomDebugStringConvertible {
    
    /// Address of this object in the hierarchy of published works (based on media type).
    var uri: BookBinderURI { get set }
    
    /// Edition of this object across the hierarchy of published works (based on editoral version).
    var tags: Set<String> { get set }
    
    /// Date and time this object was created. Immutable.
    var dateStamp: Date { get }
    
    /// Globally unique ID of this object. Immutable.
    var guid: UUID { get }
}
