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
    @IBOutlet weak var issueLabel: UILabel!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var isOwnedSwitch: UISwitch!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var cameraButtom: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var noIssuesLabel: UILabel!
    
    @IBOutlet var editIssuePopoverView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    // MARK:- Properties
    
    var comicBookCollection: JsonModel!
    var undoData: WorkData!
    var photoPicker: UIImagePickerController!
    
    // MARK:- Actions
    
    @IBAction func deleteAction(_ sender: Any) {
        
        if let selectedVolume = comicBookCollection.selectedVolume, let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork {
            
            cacheUndoData(actionKind: .delete)
            
            let title = selectedVolume.seriesName
            let workID = selectedVolumeSelectedWork.id
            let alert = UIAlertController(title: "", message: "Delete \(title) \(workID)?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:  { action in
                // yes delete please
                self.comicBookCollection.removeSelectedWorkFromSelectedVolume()
                self.save()
                self.updateUXOnLoad()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler:  { action in
                // no don't delete
            }))
            
            present(alert, animated: true, completion: nil)
        } else {
            assert(false, "BOOKBINDERAPP: selectedVolume and/or selectedVolumeSelectedWork is nil")
        }
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        
        self.photoPicker.allowsEditing = false
        self.photoPicker.sourceType = .photoLibrary
        
        self.addChild(photoPicker)
        photoPicker.didMove(toParent: self)
        self.view!.addSubview(photoPicker.view)
        
//        self.present(self.photoPicker, animated: true) {
//            // access photo details here
//            self.save()
//            self.updateUX()
//        }
    }
    
    @IBAction func isOwnedAction(_ sender: Any) {
        save()
        updateUX()
    }
    
    // MARK:- Popover Implementation
    
    func enableMainUX(toggle: Bool) {
        navigationController!.navigationItem.setHidesBackButton(toggle, animated: true)
        trashButton.isEnabled = toggle
        cameraButtom.isEnabled = toggle
        editButton.isEnabled = toggle

    }
    
    @IBAction func editAction(_ sender: Any) {
        
        // make sure we're not going to blow up!
        
        guard let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork else {
            assert(false, "BOOKBINDERAPP: selectedVolumeSelectedWork is nil")
        }
        
        // disable the main view while the popover is popped
        
        enableMainUX(toggle: false)
        
        // configure popover UX before it appears
        
        let pov = editIssuePopoverView as! EditIssuePopoverView
        pov.issueNumberField.text = "\(selectedVolumeSelectedWork.issueNumber)"
        pov.variantLetterField.text = selectedVolumeSelectedWork.variantLetter
        
        // congigure save, delete, and cancel functions
        
        pov.saveFunction = {
            self.enableMainUX(toggle: true)
            guard let selectedVolumeSelectedWork = self.comicBookCollection.selectedVolumeSelectedWork else {
                assert(false, "BOOKBINDERAPP: selectedVolumeSelectedWork is nil")
            }
            
            // TODO: changing the issue number and varient letter is dangerious!
            //       - Check for duplicate workIDs and don't allow
            //       - Don't allow an empty issue number field
            selectedVolumeSelectedWork.issueNumber = Int(pov.issueNumberField.text!) ?? 0
            selectedVolumeSelectedWork.variantLetter = pov.variantLetterField.text ?? ""
            // TODO: Update the coverImageView somehow
            
            self.save()
            self.updateUX(animateCover: false)
        }
        
        pov.cancelFunction = {
            self.enableMainUX(toggle: true)
        }
        
        // configure photo, camera, and no image functions
        
//        pov.photoLibraryFunction = {
//            self.photoPicker.allowsEditing = false
//            self.photoPicker.sourceType = .photoLibrary
//            self.present(self.photoPicker, animated: true) {
//                // access photo details here
//            }
//        }
        
//        pov.cameraFunction = {
//
//        }
//
//        pov.noImageFunction = {
//
//        }
        
        // everything is ready! pop the popover!
        
        pov.loadPopoverView(visualEffectView: visualEffectView, parentView: view)
    }
    
    // MARK:- Main View Implementation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // popover config
        
        let pov = editIssuePopoverView as! EditIssuePopoverView
        pov.configurePopoverView(visualEffectView: visualEffectView)
        
        // photo library config
        photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        
        // main view config
        addSwipeGestureRecognisers()
        cacheUndoData(actionKind: .update)
        updateUXOnLoad()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            
            switch undoData.actionKind {
            case .delete:
                undoDelete()
            case .update:
                cancel()
            }
            
            updateUXOnLoad()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        save()
    }
    
    // MARK:- Methods
    
    func cacheUndoData(actionKind: Action) {
        
        guard let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork else {
            assert(false, "BOOKBINDERAPP: selectedVolumeSelectedWork is nil")
        }
        
        undoData = WorkData(actionKind: actionKind,
                            issueNumber: selectedVolumeSelectedWork.issueNumber,
                            variantLetter: selectedVolumeSelectedWork.variantLetter,
                            coverImage: selectedVolumeSelectedWork.coverImage,
                            isOwned: selectedVolumeSelectedWork.isOwned)
    }
    
    func undoDelete() {
        let work = JsonModel.JsonVolume.JsonWork(issueNumber: undoData.issueNumber, variantLetter: undoData.variantLetter, coverImage: undoData.coverImage, isOwned: undoData.isOwned)
        
        comicBookCollection.addWorkToSelectedVolume(work)
    }
    
    func cancel() {
        if let work = comicBookCollection.selectedVolumeSelectedWork {
            work.issueNumber = undoData.issueNumber
            work.variantLetter = undoData.variantLetter
            work.coverImage = undoData.coverImage
            work.isOwned = undoData.isOwned
        } else {
            assert(false, "BOOKBINDERAPP: selectedVolumeSelectedWork is nil")
        }
    }
    
    func save() {
                
        if let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork {
            let isOwned = isOwnedSwitch.isOn
            let coverImage = selectedVolumeSelectedWork.coverImage
            
            comicBookCollection.updateSelectedWorkOfSelectedVolume(isOwned: isOwned, coverImage: coverImage)
            
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
            comicBookCollection.selectNextWork()
            
        case .right:
            comicBookCollection.selectPreviousWork()
            
        case .up:
            comicBookCollection.selectNextVolume()

        case .down:
            comicBookCollection.selectPreviousVolume()
            
       default:
            assert(false, "BOOKBINDERAPP: unsupported gesture")
        }
        
        updateUXOnLoad()
    }
    
    /// When loading the view set the isOwnedSwitch
    func updateUXOnLoad() {
        updateUX()
        
        if let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork {
            let isOwned = selectedVolumeSelectedWork.isOwned
            isOwnedSwitch.setOn(isOwned, animated: true)
        }
    }
    
    /// When loading the view don't set the isOwnedSwith, because that reloads it!
    func updateUX(animateCover: Bool = true) {
        
        guard let selectedVolume = comicBookCollection.selectedVolume else {
            assert(false, "BOOKBINDERAPP: selectedVolume is nil")
        }
        
        if comicBookCollection.selectedVolumeSelectedWork == nil {
            updateUXNoWorks(selectedVolume, animateCover)
        } else {
            let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork!
            updateUXWithWorks(selectedVolume, selectedVolumeSelectedWork, animateCover)
        }
    }
    
    func updateUXWithWorks(_ selectedVolume: JsonModel.JsonVolume,
                           _ selectedWork: JsonModel.JsonVolume.JsonWork,
                           _ animateCover: Bool) {
        
        let seriesTitle = selectedVolume.seriesName
        let publisherName = selectedVolume.publisherName
        let era = selectedVolume.era
        let workNumber = selectedWork.issueNumber
        let variantLetter = selectedWork.variantLetter
        
        let coverImage = selectedWork.coverImage != "" ? selectedWork.coverImage : selectedVolume.defaultCoverID
        
        // enable and disable commands
        
        trashButton.isEnabled = true
        editButton.isEnabled = true
        isOwnedSwitch.isEnabled = true
        
        // update the fields
        
        titleLabel.text = "\(seriesTitle) \(era)"
        publisherLabel.text = "\(publisherName)"
        issueLabel.text = "# \(workNumber)\(variantLetter)"
        noIssuesLabel.isHidden = true
        
        // update the cover
        
        var coverImageAlpha = CGFloat(1.0)
        
        if !selectedWork.isOwned {
            coverImageAlpha = 0.3
        }
        
        if animateCover {
            
            coverImageView.alpha = 0
            coverImageView.image = UIImage(named: coverImage)
            UIView.animate(withDuration: 1.0) {
                self.coverImageView.alpha = coverImageAlpha
            }
        }
    }
    
    func updateUXNoWorks(_ selectedVolume: JsonModel.JsonVolume, _ animateCover: Bool) {
        
        let seriesTitle = selectedVolume.seriesName
        let publisherName = selectedVolume.publisherName
        let era = selectedVolume.era
        let workNumber = ""
        let variantLetter = ""
        let coverImage = "missing-issue"
        
        // enable and disable commands
        
        trashButton.isEnabled = false
        editButton.isEnabled = false
        isOwnedSwitch.isOn = false
        isOwnedSwitch.isEnabled = false

        
        // update the fields
        
        titleLabel.text = "\(seriesTitle) \(era)"
        publisherLabel.text = "\(publisherName)"
        issueLabel.text = "# \(workNumber)\(variantLetter)"
        noIssuesLabel.isHidden = false
        
        // update the no issues field
        
        if animateCover {
            
            noIssuesLabel.alpha = 0
            UIView.animate(withDuration: 1.0) {
                self.noIssuesLabel.alpha = 1
            }
            
            coverImageView.alpha = 0
            coverImageView.image = UIImage(named: coverImage)
            UIView.animate(withDuration: 1.0) {
                self.coverImageView.alpha = 0.3
            }

        }

    }
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // No where to seque to!
    }
}

extension DetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            coverImageView.image = pickedImage
            let imageURL = info[.imageURL]
            print("image url: \(imageURL!)")
            save()
            updateUX()
        }
        
        picker.view!.removeFromSuperview()
        picker.removeFromParent()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.view!.removeFromSuperview()
        picker.removeFromParent()
    }
}
