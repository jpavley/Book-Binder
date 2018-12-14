//
//  CollectionReusableView.swift
//  Book Binder
//
//  Created by John Pavley on 9/25/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var comicBookCollection: JsonModel!
    var volumeIndex: Int!
    
    @IBAction func editAction(_ sender: Any) {

        let seriesName = comicBookCollection.volumes[volumeIndex].seriesName
        print("editAction() \(seriesName)")
    }
}
