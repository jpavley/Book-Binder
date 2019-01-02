//
//  EditSeriesPopoverView.swift
//  Book Binder
//
//  Created by John Pavley on 12/14/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

class EditSeriesPopoverView: PopoverUIView {
    
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var seriesTextField: UITextField!
    @IBOutlet weak var eraTextField: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func photosAction(_ sender: Any) {
        
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        
    }
    
    @IBAction func noImageAction(_ sender: Any) {
        
    }
    
    @IBAction func doneAction(_ sender: Any) {
        saveFunction()
        exitPopoverView(visualEffectView: visualEffectView)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        deleteFunction()
        exitPopoverView(visualEffectView: visualEffectView)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        cancelFunction()
        exitPopoverView(visualEffectView: visualEffectView)
    }
}
