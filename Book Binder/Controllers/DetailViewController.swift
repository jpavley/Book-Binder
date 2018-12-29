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
    
    @IBOutlet var popoverView: UIView!
    @IBOutlet weak var popoverIssueField: UITextField!
    @IBOutlet weak var popoverVariantField: UITextField!
    @IBOutlet weak var popoverCoverImage: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    // MARK:- Properties
    
    var comicBookCollection: JsonModel!
    var undoData: WorkData!
    
    // MARK:- Actions
    
    @IBAction func deleteAction(_ sender: Any) {
        
        if let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork {
            
            cacheUndoData(actionKind: .delete)
            
            let title = comicBookCollection.selectedVolume.seriesName
            let workID = selectedVolumeSelectedWork.id
            let alert = UIAlertController(title: "", message: "Delete \(title) \(workID)?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:  { action in
                // yes delete please
                self.comicBookCollection.removeSelectedWorkFromSelectedVolume()
                self.updateUXOnLoad()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler:  { action in
                // no don't delete
            }))
            
            present(alert, animated: true, completion: nil)
        } else {
            assert(false, "BOOKBINDERAPP: selectedVolumeSelectedWork is nil")
        }
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        // TODO: Replace the current cover with a new or existing photo
        print("camera action")
        save()
        updateUX()
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
        
        guard let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork else {
            assert(false, "BOOKBINDERAPP: selectedVolumeSelectedWork is nil")
        }
        
        // load data into popover fields
        popoverIssueField.text = "\(selectedVolumeSelectedWork.issueNumber)"
        popoverVariantField.text = selectedVolumeSelectedWork.variantLetter
        popoverCoverImage.image = UIImage(named: "\(selectedVolumeSelectedWork.coverImage)-thumb")
        
        enableMainUX(toggle: false)
        loadPopoverView(popoverView: popoverView, visualEffectView: visualEffectView, parentView: view)
    }
    
    @IBAction func cancelPopoverAction(_ sender: Any) {
        exitPopoverView(popoverView: popoverView, visualEffectView: visualEffectView)
        enableMainUX(toggle: true)
    }
    
    @IBAction func savePopoverAction(_ sender: Any) {
        
        guard let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork else {
            assert(false, "BOOKBINDERAPP: selectedVolumeSelectedWork is nil")
        }
        
        exitPopoverView(popoverView: popoverView, visualEffectView: visualEffectView)
        enableMainUX(toggle: true)

        // TODO: changing the issue number and varient letter is dangerious!
        //       - Check for duplicate workIDs and don't allow
        //       - Don't allow an empty issue number field
        selectedVolumeSelectedWork.issueNumber = Int(popoverIssueField.text!) ?? 0
        selectedVolumeSelectedWork.variantLetter = popoverVariantField.text ?? ""

        self.save()
        self.updateUX(animateCover: false)

    }
        
    // MARK:- Main View Implementation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePopoverView(popoverView: popoverView, visualEffectView: visualEffectView)
        
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
        
        guard let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork else {
            assert(false, "BOOKBINDERAPP: selectedVolumeSelectedWork is nil")
        }
        
        let isOwned = isOwnedSwitch.isOn
        let coverImage = selectedVolumeSelectedWork.coverImage
        
        comicBookCollection.updateSelectedWorkOfSelectedVolume(isOwned: isOwned, coverImage: coverImage)
        
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
        } else {
            assert(false, "BOOKBINDERAPP: selectedVolumeSelectedWork is nil")
        }
    }
    
    /// When loading the view don't set the isOwnedSwith, because that reloads it!
    func updateUX(animateCover: Bool = true) {
        
        guard let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork else {
            assert(false, "BOOKBINDERAPP: selectedVolumeSelectedWork is nil")
        }
        
        // get the state
        
        let seriesTitle = comicBookCollection.selectedVolume.seriesName
        let publisherName = comicBookCollection.selectedVolume.publisherName
        let era = comicBookCollection.selectedVolume.era
        let workNumber = selectedVolumeSelectedWork.issueNumber
        let variantLetter = selectedVolumeSelectedWork.variantLetter
        
        let coverImage = selectedVolumeSelectedWork.coverImage != "" ? selectedVolumeSelectedWork.coverImage : comicBookCollection.selectedVolume.defaultCoverID
        
        // enable and disable commands
        trashButton.isEnabled = true
        editButton.isEnabled = true
        
        // update the fields
        
        titleLabel.text = "\(seriesTitle) \(era)"
        publisherLabel.text = "\(publisherName)"
        issueLabel.text = "# \(workNumber)\(variantLetter)"
        
        // udpate the cover
        
        var coverImageAlpha = CGFloat(1.0)
        
        if !selectedVolumeSelectedWork.isOwned {
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
