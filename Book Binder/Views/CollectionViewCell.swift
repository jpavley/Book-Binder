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
            // selectionImage.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                // if isEditing is true indicate that the cell is selected
                // if isEditing is false indicate that the cell is not selected
                //selectionImage.image = isSelected ? UIImage(named: "Checked") : UIImage(named: "Unchecked")
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        if titleLabel.text != "..." && titleLabel.text != "+" {
            return
        }
        
        if let context = UIGraphicsGetCurrentContext() {
            let circleFrame = CGRect(origin: CGPoint(x: rect.midX/2.5, y: rect.minY), size: CGSize(width: rect.size.height, height: rect.size.height))
            let newRect = circleFrame.insetBy(dx: 6.0, dy: 6.0)
            context.addEllipse(in: newRect)
            context.setStrokeColor(UIColor.blue.cgColor)
            context.setLineWidth(1.0)
            context.strokePath()
            
        }
    }

}

