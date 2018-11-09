//
//  BookBinderSection.swift
//  Book Binder
//
//  Created by John Pavley on 11/8/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

class BookBinderSection {
    var comicBookCollection: ComicBookCollection
    var sectionNumber: Int
    
    init(comicBookCollection: ComicBookCollection, sectionNumber: Int) {
        self.comicBookCollection = comicBookCollection
        self.sectionNumber = sectionNumber
    }
    
    var publishedWorks: [Int] {
        var results = [Int]()
        let publisher = comicBookCollection.comicBookModel.publishers[sectionNumber]
        let series = publisher.series[sectionNumber]
        for volume in series.volumes {
            for i in volume.firstWorkNumber...volume.currentWorkNumber {
                results.append(i)
            }
        }
        return results
    }
    
    var ownedWorks: [Int] {
        
    }
}
