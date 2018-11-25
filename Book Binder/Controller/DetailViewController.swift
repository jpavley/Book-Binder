//
//  DetailViewController.swift
//  Book Binder
//
//  Created by John Pavley on 9/22/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK:- Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var publisherLabel: UILabel!
    @IBOutlet private weak var issueNumberLabel: UILabel!
    @IBOutlet weak var variantLetterLabel: UILabel!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var isOwnedSwitch: UISwitch!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var cameraButtom: UIBarButtonItem!
    @IBOutlet weak var variantButton: UIBarButtonItem!
    
    // MARK:- Properties
    
    var comicBookCollection: JsonModel!
    var undoData: WorkData!
    
    // MARK:- Actions
    
    @IBAction func deleteAction(_ sender: Any) {
        // TODO: Mark this work for removal from owenership and tracking. It becomes a published, uncollected work.
        
        let alert = UIAlertController(title: "Delete Comic Book?", message: "Remove cover image, variant letter, and set owned to false.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:  { action in
            // yes delete please
            let work = self.comicBookCollection.selectedVolumeSelectedWork
            self.comicBookCollection.removeWorkFromSelectedVolume(work)
            self.updateUXOnLoad()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler:  { action in
            // no don't delete
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        // TODO: Replace the current cover with a new or existing photo
        print("camera action")
    }
    
    @IBAction func variantAction(_ sender: Any) {
        let alert = UIAlertController(title: "Variant Letter", message: "Enter a variant letter for this issue...", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "A, B, C, etc..."
        })
                
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            if let variantLetter = alert.textFields?.first?.text {
                print("varientLetter \(variantLetter)")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func isOwnedAction(_ sender: Any) {
        save()
        updateUX()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeGestureRecognisers()
        cacheUndoData()
        updateUXOnLoad()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            // TODO: if there are no changes don't undo
            // if changes() {
            cancel()
            updateUXOnLoad()
            // }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        save()
    }
    
    // MARK:- Methods
    
    func cacheUndoData() {
        undoData = WorkData(issueNumber: comicBookCollection.selectedVolumeSelectedWork.issueNumber,
                            variantLetter: comicBookCollection.selectedVolumeSelectedWork.variantLetter,
                            coverImage: comicBookCollection.selectedVolumeSelectedWork.coverImage,
                            isOwned: comicBookCollection.selectedVolumeSelectedWork.isOwned)
    }
    
    func cancel() {
        
        let work = comicBookCollection.selectedVolumeSelectedWork
        
        work.issueNumber = undoData.issueNumber
        work.variantLetter = undoData.variantLetter
        work.coverImage = undoData.coverImage
        work.isOwned = undoData.isOwned
        
        if work.isOwned {
            comicBookCollection.addWorkToSelectedVolume(work)
        }
    }
    
    func save() {
        let work = comicBookCollection.selectedVolumeSelectedWork
        
        work.issueNumber = Int(issueNumberLabel.text ?? "") ?? 0
        work.variantLetter = variantLetterLabel.text ?? ""
        work.isOwned = isOwnedSwitch.isOn
        
        // TODO: Figure out how to properly implement the ability to change cover photos
        work.coverImage = comicBookCollection.selectedVolumeSelectedWork.coverImage
        
        if work.isOwned {
            comicBookCollection.addWorkToSelectedVolume(work)
        }
        
        saveUserDefaults(for: defaultsKey, with: comicBookCollection)
        dismiss(animated: true, completion: nil)
        
    }
    
    func addSwipeGestureRecognisers() {
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipe(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
            
        case .left:
            // TODO: next work
            print("next work")
            
        case .right:
            // TODO: previous work
            print("previous work")
            
        case .up:
            // TODO: next volume
            print("next volume")

        case .down:
            // TODO: previous volume
            print("next volume")
            
       default:
            assert(false, "BOOKBINDERAPP: unsupported gesture")
        }
        
        updateUX()
    }
    
    /// When loading the view set the isOwnedSwitch
    func updateUXOnLoad() {
        updateUX()
        
        let isOwned = comicBookCollection.selectedVolumeSelectedWork.isOwned
        isOwnedSwitch.setOn(isOwned, animated: true)
    }
    
    /// When loading the view don't set the isOwnedSwith, because that reloads it!
    func updateUX() {
        
        func enableTrashButton(_ isOwned: Bool, _ variantLetter: String) {
            // TODO: Handle custom cover image case
            
            if isOwned || variantLetter != "" {
                trashButton.isEnabled = true
            } else {
                trashButton.isEnabled = false
            }
        }
        
        func enableVariantButton(_ variantLetter: String) {
            
            if variantLetter == "" {
                variantButton.isEnabled = true
            } else {
                variantButton.isEnabled = false
            }
        }
        
        // get the state
        
        let seriesTitle = comicBookCollection.selectedVolume.seriesName
        let publisherName = comicBookCollection.selectedVolume.publisherName
        let era = comicBookCollection.selectedVolume.era
        let workNumber = comicBookCollection.selectedVolumeSelectedWork.issueNumber
        let variantLetter = comicBookCollection.selectedVolumeSelectedWork.variantLetter
        
        let coverImage = comicBookCollection.selectedVolumeSelectedWork.coverImage != "" ? comicBookCollection.selectedVolumeSelectedWork.coverImage : comicBookCollection.selectedVolume.defaultCoverID
        
        let isOwned = comicBookCollection.selectedVolumeSelectedWork.isOwned
        
        // enable and disable commands
        enableTrashButton(isOwned, variantLetter)
        enableVariantButton(variantLetter)
        
        // update the fields
        
        titleLabel.text = "\(seriesTitle) \(era)"
        publisherLabel.text = "\(publisherName)"
        issueNumberLabel.text = "\(workNumber)"
        variantLetterLabel.text = "\(variantLetter)"
        
        // udpate the cover
        
        coverImageView.alpha = 0
        coverImageView.image = UIImage(named: coverImage)
        UIView.animate(withDuration: 1.0, animations: {
            self.coverImageView.alpha = 1.0
        }, completion: nil)
    }
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // No where to seque to!
    }

}
