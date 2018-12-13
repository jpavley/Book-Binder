//
//  PopoverView.swift
//  Book Binder
//
//  Created by John Pavley on 12/11/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit 

class PopoverView: UIView {
    
    @IBOutlet weak var issueNumberField: UITextField!
    @IBOutlet weak var variantLetterField: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var seriesTitleLabel: UILabel!
    
    var comicBookCollection: JsonModel!
    
    @IBAction func doneAction(_ sender: Any) {
        saveData()
        visualEffectView.isHidden = true
        removeFromSuperview()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        visualEffectView.isHidden = true
        removeFromSuperview()
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
    
    func saveData() {
        comicBookCollection.selectedVolumeSelectedWork.issueNumber = Int(issueNumberField.text!) ?? 0
        comicBookCollection.selectedVolumeSelectedWork.variantLetter = variantLetterField.text ?? ""
        // TODO: Save to user defaults
    }
    
    func loadData() {
        publisherNameLabel.text = "\(comicBookCollection.selectedVolume.publisherName)"
        seriesTitleLabel.text = comicBookCollection.selectedVolume.seriesName
        coverImage.image = UIImage(named: "\(comicBookCollection.selectedVolume.defaultCoverID)-thumb")
        issueNumberField.placeholder = "\(comicBookCollection.selectedVolumeSelectedWork.issueNumber)"
    }
}
