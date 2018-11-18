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
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.setStrokeColor(UIColor.lightGray.cgColor)
            context.setLineWidth(1.0)
            //context.setLineDash(phase: 5.0, lengths: [5.0, 5.0])
            context.strokePath()
            
        }
    }
}
