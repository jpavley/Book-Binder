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
    
    // MARK:- Properties
    
    var comicBookCollection: JsonModel!
    var undoData: WorkData!
    
    // MARK:- Actions
        
    @IBAction func editAction(_ sender: Any) {
        print("edit action")
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        print("camera action")
    }
    
    @IBAction func addIssueAction(_ sender: Any) {
        print("add issue action")
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
            cancel()
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
        
        saveUserDefaults(for: defaultsKey, with: comicBookCollection)
        dismiss(animated: true, completion: nil)
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
            // next work
            print("next work")
            
        case .right:
            // previous work
            print("previous work")
            
        case .up:
            // next volume
            print("next volume")

        case .down:
            // previous volume
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
        
        let seriesTitle = comicBookCollection.selectedVolume.seriesName
        let publisherName = comicBookCollection.selectedVolume.publisherName
        let era = comicBookCollection.selectedVolume.era
        let workNumber = comicBookCollection.selectedVolumeSelectedWork.issueNumber
        let variantLetter = comicBookCollection.selectedVolumeSelectedWork.variantLetter
        let coverImage = comicBookCollection.selectedVolumeSelectedWork.coverImage
        
        
        titleLabel.text = "\(seriesTitle) \(era)"
        publisherLabel.text = "\(publisherName)"
        issueNumberLabel.text = "\(workNumber)"
        variantLetterLabel.text = "\(variantLetter)"
        
        coverImageView.alpha = 0
        coverImageView.image = UIImage(named: coverImage)
        UIView.animate(withDuration: 1.0, animations: {
            self.coverImageView.alpha = 1.0
        }, completion: nil)
        
        navigationController?.isToolbarHidden = false
    }
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // No where to seque to!
    }

}
