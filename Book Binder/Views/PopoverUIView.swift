//
//  PopoverUIView.swift
//  Book Binder
//
//  Created by John Pavley on 1/2/19.
//  Copyright © 2019 John Pavley. All rights reserved.
//

import UIKit

class PopoverUIView: UIView {
    
    var saveFunction: () -> () = { print("series changes saved") }
    var cancelFunction: () -> () = { print("series changes canceled") }
    var deleteFunction: () -> () = { print("series deleted") }
    
    weak var visualEffectView: UIVisualEffectView!
    weak var parentView: UIView!
    
    func configurePopoverView() {
        self.layer.cornerRadius = 5
        visualEffectView.isHidden = true
        self.frame.size.width = UIScreen.main.bounds.width
    }
    
    func loadPopoverView(popoverView: UIView, visualEffectView: UIVisualEffectView, parentView: UIView) {
        visualEffectView.isHidden = false
        
        parentView.addSubview(popoverView)
        popoverView.center = parentView.center
        
        popoverView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popoverView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            popoverView.alpha = 1
            popoverView.transform = CGAffineTransform.identity
        }
    }
    
    func exitPopoverView(popoverView: UIView, visualEffectView: UIVisualEffectView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            popoverView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            popoverView.alpha = 0
            visualEffectView.isHidden = true
            
        }) { success in
            popoverView.removeFromSuperview()
        }
    }
}
