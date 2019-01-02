//
//  PopoverView.swift
//  Book Binder
//
//  Created by John Pavley on 12/11/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit 

class AddIssuePopoverView: PopoverUIView {
    
    @IBOutlet weak var issueNumberField: UITextField!
    @IBOutlet weak var variantLetterField: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var seriesTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var comicBookCollection: JsonModel!
    
    @IBAction func doneAction(_ sender: Any) {
        saveFunction()
        exitPopoverView(visualEffectView: visualEffectView)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        cancelFunction()
        exitPopoverView(visualEffectView: visualEffectView)
    }
    
    @IBAction func photosAction(_ sender: Any) {
        print("photosAction()")
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        print("cameraAction()")
    }
    
    @IBAction func noImageAction(_ sender: Any) {
        print("noImageAction()")
    }
}
