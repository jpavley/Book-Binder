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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var comicBookCollection: JsonModel!
    
    @IBAction func doneAction(_ sender: Any) {
        saveData()
        exitPopoverView()
        collectionView.reloadData()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        exitPopoverView()
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
    
    func exitPopoverView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0
            self.visualEffectView.isHidden = true
            
        }) { success in
            self.removeFromSuperview()
        }
    }
    
    func saveData() {
        let issueNumber = Int(issueNumberField.text!) ?? 0
        let variantLetter = variantLetterField.text!
        let coverImage = comicBookCollection.selectedVolume.defaultCoverID
        let isOwned = true
        
        let work = JsonModel.JsonVolume.JsonWork(issueNumber: issueNumber,
                                                 variantLetter: variantLetter,
                                                 coverImage: coverImage,
                                                 isOwned: isOwned)
        comicBookCollection.addWorkToSelectedVolume(work)
        
        saveUserDefaults(for: defaultsKey, with: comicBookCollection)
    }
    
    func loadData() {
        publisherNameLabel.text = "\(comicBookCollection.selectedVolume.publisherName)"
        seriesTitleLabel.text = comicBookCollection.selectedVolume.seriesName
        coverImage.image = UIImage(named: "\(comicBookCollection.selectedVolume.defaultCoverID)-thumb")
        issueNumberField.text = ""
        issueNumberField.placeholder = "\(comicBookCollection.selectedVolumeSelectedWork.issueNumber + 1)"
        variantLetterField.text = ""
    }
}
