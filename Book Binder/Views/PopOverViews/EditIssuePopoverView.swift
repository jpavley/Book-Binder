//
//  EditIssuePopoverView.swift
//  Book Binder
//
//  Created by John Pavley on 1/2/19.
//  Copyright © 2019 John Pavley. All rights reserved.
//

import UIKit

class EditIssuePopoverView: PopoverUIView {
    
    @IBOutlet weak var issueNumberField: UITextField!
    @IBOutlet weak var variantLetterField: UITextField!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBAction func doneAction(_ sender: Any) {
        saveFunction()
        exitPopoverView(visualEffectView: visualEffectView)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        cancelFunction()
        exitPopoverView(visualEffectView: visualEffectView)
    }
}
