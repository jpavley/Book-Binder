//
//  PopoverView.swift
//  Book Binder
//
//  Created by John Pavley on 12/11/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit 

class AddIssuePopoverView: UIView {
    
    @IBOutlet weak var issueNumberField: UITextField!
    @IBOutlet weak var variantLetterField: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var seriesTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var saveFunction: () -> () = { print("series changes saved") }
    var cancelFunction: () -> () = { print("series changes canceled") }
    var deleteFunction: () -> () = { print("series deleted") }
    
    var comicBookCollection: JsonModel!
    
    @IBAction func doneAction(_ sender: Any) {
        saveFunction()
        
        if issueNumberField.text != "" {
            saveData()
            collectionView.reloadData()
        }
        exitPopoverView(popoverView: self, visualEffectView: visualEffectView)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        cancelFunction()
        exitPopoverView(popoverView: self, visualEffectView: visualEffectView)
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
        if let selectedVolume = comicBookCollection.selectedVolume {
            
            let issueNumber = Int(issueNumberField.text!) ?? 0
            let variantLetter = variantLetterField.text!
            let coverImage = selectedVolume.defaultCoverID
            let isOwned = true
            
            let work = JsonModel.JsonVolume.JsonWork(
                issueNumber: issueNumber,
                variantLetter: variantLetter,
                coverImage: coverImage,
                isOwned: isOwned
            )
            
            comicBookCollection.addWorkToSelectedVolume(work)
            saveUserDefaults(for: defaultsKey, with: comicBookCollection)
        } else {
            assert(false, "BOOKBINDERAPP: selectedVolume is nil")
        }
    }
    
    func loadData() {
        if let selectedVolume = comicBookCollection.selectedVolume {
            
            publisherNameLabel.text = "\(selectedVolume.publisherName)"
            seriesTitleLabel.text = selectedVolume.seriesName
            coverImage.image = UIImage(named: "\(selectedVolume.defaultCoverID)-thumb")
            issueNumberField.text = ""
            
            if let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork {
                issueNumberField.placeholder = "\(selectedVolumeSelectedWork.issueNumber + 1)"
            } else {
                issueNumberField.placeholder = ""
            }
            variantLetterField.text = ""
        } else {
            assert(false, "BOOKBINDERAPP: selectedVolume is nil")
        }
    }
}
