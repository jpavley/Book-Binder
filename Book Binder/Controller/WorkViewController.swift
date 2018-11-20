//
//  WorkViewController.swift
//  Book Binder
//
//  Created by John Pavley on 11/19/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

struct UndoData {
    let workNumber: Int
    let variantLetter: String
    let coverImage: String
    let isOwned: Bool
}

class WorkViewController: UIViewController {
    
    // MARK:- Outlets
    
    @IBOutlet weak var seriesTitleLabel: UILabel!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var issueNumberField: UITextField!
    @IBOutlet weak var variantLetterField: UITextField!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var isOwnedSwitch: UISwitch!
    
    // MARK:- Properties
    
    var comicBookCollection: JsonModel!
    var undoData: UndoData!
    
    // MARK:- Actions
    
    @IBAction func takePhotoAction(_ sender: Any) {
    }
    
    @IBAction func photoLibraryAction(_ sender: Any) {
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        let work = comicBookCollection.selectedVolumeSelectedWork
        
        work.issueNumber = undoData.workNumber
        work.variantLetter = undoData.variantLetter
        work.coverImage = undoData.coverImage
        work.isOwned = undoData.isOwned
        
        if work.isOwned {
            comicBookCollection.addWorkToSelectedVolume(work)
        }
        
        saveUserDefaults(for: defaultsKey, with: comicBookCollection)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func isOwnedAction(_ sender: Any) {
//        let sw = sender as! UISwitch
//        
//        let work = comicBookCollection.selectedVolumeSelectedWork
//        work.isOwned = sw.isOn
//        
//        if work.isOwned {
//            comicBookCollection.addWorkToSelectedVolume(work)
//        }
//        
//        saveUserDefaults(for: defaultsKey, with: comicBookCollection)
//        updateUX()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let work = comicBookCollection.selectedVolumeSelectedWork
        
        work.issueNumber = Int(issueNumberField.text ?? "") ?? 0
        work.variantLetter = variantLetterField.text ?? ""
        work.isOwned = isOwnedSwitch.isOn
        
        // TODO: Implement cover image
        // work.coverImage = ?
        
        if work.isOwned {
            comicBookCollection.addWorkToSelectedVolume(work)
        }
        
        saveUserDefaults(for: defaultsKey, with: comicBookCollection)
        dismiss(animated: true, completion: nil)

    }
    
    // MARK:- Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let isOwned = comicBookCollection.selectedVolumeSelectedWork.isOwned
        isOwnedSwitch.setOn(isOwned, animated: true)
        
        undoData = UndoData(workNumber: comicBookCollection.selectedVolumeSelectedWork.issueNumber,
                            variantLetter: comicBookCollection.selectedVolumeSelectedWork.variantLetter,
                            coverImage: comicBookCollection.selectedVolumeSelectedWork.coverImage,
                            isOwned: comicBookCollection.selectedVolumeSelectedWork.isOwned)

        updateUX()
    }
    
    // MARK:- Methods
    
    func updateUX() {
        let seriesTitle = comicBookCollection.selectedVolume.seriesName
        let publisherName = comicBookCollection.selectedVolume.publisherName
        let era = comicBookCollection.selectedVolume.era
        let workNumber = comicBookCollection.selectedVolumeSelectedWork.issueNumber
        let variantLetter = comicBookCollection.selectedVolumeSelectedWork.variantLetter
        let coverImage = comicBookCollection.selectedVolumeSelectedWork.coverImage
        
        seriesTitleLabel.text = "\(seriesTitle) \(era)"
        publisherNameLabel.text = "\(publisherName)"
        issueNumberField.text = "\(workNumber)"
        variantLetterField.text = "\(variantLetter)"
        
        coverPhotoImageView.alpha = 0
        coverPhotoImageView.image = UIImage(named: coverImage)
        UIView.animate(withDuration: 1.0, animations: {
            self.coverPhotoImageView.alpha = 1.0
        }, completion: nil)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
