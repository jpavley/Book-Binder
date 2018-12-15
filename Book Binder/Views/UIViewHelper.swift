//
//  UIViewHelper.swift
//  Book Binder
//
//  Created by John Pavley on 12/14/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

func configurePopoverView(popoverView: UIView, visualEffectView: UIVisualEffectView) {
    popoverView.layer.cornerRadius = 5
    visualEffectView.isHidden = true

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

