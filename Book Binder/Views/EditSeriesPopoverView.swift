//
//  EditSeriesPopoverView.swift
//  Book Binder
//
//  Created by John Pavley on 12/14/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

class EditSeriesPopoverView: UIView {
    
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var seriesTextField: UITextField!
    @IBOutlet weak var eraTextField: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBAction func photosAction(_ sender: Any) {
        
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        
    }
    
    @IBAction func noImageAction(_ sender: Any) {
        
    }
    
    @IBAction func doneAction(_ sender: Any) {
        exitPopoverView(popoverView: self, visualEffectView: visualEffectView)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        exitPopoverView(popoverView: self, visualEffectView: visualEffectView)
    }
}
