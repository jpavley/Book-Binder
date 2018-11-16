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
    
    override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext() {
            context.move(to: CGPoint(x: rect.minX + 6.0, y: rect.minY + 6.0))
            context.addLine(to: CGPoint(x: rect.maxX - 6.0, y: rect.minY + 6.0))
            context.setStrokeColor(UIColor.lightGray.cgColor)
            context.setLineWidth(2.0)
            context.setLineDash(phase: 5.0, lengths: [5.0, 5.0])
            context.strokePath()
            
        }
    }
}
