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
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    // MARK:- Properties
    
    var comicBookCollection: JsonModel!
    var undoData: WorkData!
    
    // MARK:- Actions
    
    @IBAction func cancelPopoverAction(_ sender: Any) {
        exitPopoverView()
    }
    
    @IBAction func savePopoverAction(_ sender: Any) {
        exitPopoverView()
    }
    
    func exitPopoverView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.popoverView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.popoverView.alpha = 0
            self.visualEffectView.isHidden = true
            
            }) { success in
                self.popoverView.removeFromSuperview()
                self.save()
                self.updateUX()
            }
    }
    
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
    
    @IBAction func editAction(_ sender: Any) {
        
        visualEffectView.isHidden = false
        view.addSubview(popoverView)
        popoverView.center = view.center
        
        popoverView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popoverView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.popoverView.alpha = 1
            self.popoverView.transform = CGAffineTransform.identity
        }
    }
    
    
    @IBAction func isOwnedAction(_ sender: Any) {
        save()
        updateUX()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popoverView.layer.cornerRadius = 5
        visualEffectView.isHidden = true
        
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
        
        let isOwned = isOwnedSwitch.isOn
        let coverImage = comicBookCollection.selectedVolumeSelectedWork.coverImage
        
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
        editButton.isEnabled = true
        
        // update the fields
        
        titleLabel.text = "\(seriesTitle) \(era)"
        publisherLabel.text = "\(publisherName)"
        issueLabel.text = "# \(workNumber)\(variantLetter)"
        
        // udpate the cover
        
        var coverImageAlpha = CGFloat(1.0)
        
        if !comicBookCollection.selectedVolumeSelectedWork.isOwned {
            coverImageAlpha = 0.3
        }
        
        coverImageView.alpha = 0
        coverImageView.image = UIImage(named: coverImage)
        UIView.animate(withDuration: 1.0, animations: {
            self.coverImageView.alpha = coverImageAlpha
        }, completion: nil)
    }
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // No where to seque to!
    }

}
