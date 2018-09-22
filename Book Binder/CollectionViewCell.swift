//
//  CollectionViewCell.swift
//  Book Binder
//
//  Created by John Pavley on 9/22/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // Outlets not private so we can access from the view controller class
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionImage: UIImageView!
    
    var isEditing: Bool = false {
        didSet {
            // if isEditing is true show the selection image
            selectionImage.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                // if isEditing is true indicate that the cell is selected
                // if isEditing is false indicate that the cell is not selected
                selectionImage.image = isSelected ?
                    UIImage(named: "Checked") :
                    UIImage(named: "Unchecked")
            }
        }
    }
}

