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
    
    var photoLibraryFunction: () -> () = { print("open photo picker") }
    var cameraFunction: () -> () = { print("open camera") }
    var noImageFunction: () -> () = { print("no image") }
    
    func configurePopoverView(visualEffectView: UIVisualEffectView) {
        self.layer.cornerRadius = 16
        visualEffectView.isHidden = true
        self.frame.size.width = UIScreen.main.bounds.width
    }
    
    func loadPopoverView(visualEffectView: UIVisualEffectView, parentView: UIView) {
        visualEffectView.isHidden = false
        
        parentView.addSubview(self)
        self.center = parentView.center
        
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }
    }
    
    func exitPopoverView(visualEffectView: UIVisualEffectView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0
            visualEffectView.isHidden = true
            
        }) { success in
            self.removeFromSuperview()
        }
    }
}
