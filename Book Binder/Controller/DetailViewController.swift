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
        
        cacheUndoData(actionKind: .delete)
        
        let title = comicBookCollection.selectedVolume.seriesName
        let workID = comicBookCollection.selectedVolumeSelectedWork.id
        
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
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        // TODO: Replace the current cover with a new or existing photo
        print("camera action")
        save()
        updateUX()
    }
    
    @IBAction func variantAction(_ sender: Any) {
        // TODO: This function becomes something else
        print("variant action")
        save()
        updateUX()
    }
    
    
    @IBAction func isOwnedAction(_ sender: Any) {
        save()
        updateUX()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        undoData = WorkData(actionKind: actionKind,
                            issueNumber: comicBookCollection.selectedVolumeSelectedWork.issueNumber,
                            variantLetter: comicBookCollection.selectedVolumeSelectedWork.variantLetter,
                            coverImage: comicBookCollection.selectedVolumeSelectedWork.coverImage,
                            isOwned: comicBookCollection.selectedVolumeSelectedWork.isOwned)
    }
    
    func undoDelete() {
        let work = JsonModel.JsonVolume.JsonWork(issueNumber: undoData.issueNumber, variantLetter: undoData.variantLetter, coverImage: undoData.coverImage, isOwned: undoData.isOwned)
        
        comicBookCollection.addWorkToSelectedVolume(work)
    }
    
    func cancel() {
        let work = comicBookCollection.selectedVolumeSelectedWork
        
        work.issueNumber = undoData.issueNumber
        work.variantLetter = undoData.variantLetter
        work.coverImage = undoData.coverImage
        work.isOwned = undoData.isOwned
    }
    
    func save() {
        
        let issueNumber = Int(issueNumberLabel.text ?? "") ?? 0
        let variantLetter = variantLetterLabel.text ?? ""
        let isOwned = isOwnedSwitch.isOn
        let coverImage = comicBookCollection.selectedVolumeSelectedWork.coverImage
        
        comicBookCollection.updateSelectedWorkOfSelectedVolume(issueNumber: issueNumber, variantLetter: variantLetter, isOwned: isOwned, coverImage: coverImage)
        
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
        
        let isOwned = comicBookCollection.selectedVolumeSelectedWork.isOwned
        isOwnedSwitch.setOn(isOwned, animated: true)
    }
    
    /// When loading the view don't set the isOwnedSwith, because that reloads it!
    func updateUX() {
        
        // get the state
        
        let seriesTitle = comicBookCollection.selectedVolume.seriesName
        let publisherName = comicBookCollection.selectedVolume.publisherName
        let era = comicBookCollection.selectedVolume.era
        let workNumber = comicBookCollection.selectedVolumeSelectedWork.issueNumber
        let variantLetter = comicBookCollection.selectedVolumeSelectedWork.variantLetter
        
        let coverImage = comicBookCollection.selectedVolumeSelectedWork.coverImage != "" ? comicBookCollection.selectedVolumeSelectedWork.coverImage : comicBookCollection.selectedVolume.defaultCoverID
        
        // enable and disable commands
        trashButton.isEnabled = true
        variantButton.isEnabled = true
        
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
