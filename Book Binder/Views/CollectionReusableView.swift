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
    
    func drawRule(start: CGPoint, end: CGPoint, color: CGColor, width: CGFloat) {
        if let context = UIGraphicsGetCurrentContext() {
            context.move(to: CGPoint(x: start.x, y: start.y))
            context.addLine(to: CGPoint(x: end.x, y: end.y))
            context.setStrokeColor(color)
            context.setLineWidth(width)
            context.strokePath()
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let start1 = CGPoint(x: rect.minX, y: rect.minY)
        let end1 = CGPoint(x: rect.maxX, y: rect.minY)
        let color1 = UIColor(named: "SectionColorDark")!.cgColor
        let width1 = CGFloat(2.0)
        
        
        let start2 = CGPoint(x: rect.minX, y: rect.minY+2)
        let end2 = CGPoint(x: rect.maxX, y: rect.minY+2)
        let color2 = UIColor(named: "SectionColorLight")!.cgColor
        let width2 = CGFloat(4.0)
        
        drawRule(start: start2, end: end2, color: color2, width: width2)
        drawRule(start: start1, end: end1, color: color1, width: width1)

        
//        if let context = UIGraphicsGetCurrentContext() {
//            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
//            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
//            context.setStrokeColor(UIColor.lightGray.cgColor)
//            context.setLineWidth(1.0)
//            context.strokePath()
//
//        }
    }
}
