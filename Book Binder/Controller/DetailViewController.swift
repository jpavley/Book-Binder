//
//  DetailViewController.swift
//  Book Binder
//
//  Created by John Pavley on 9/22/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var publisherLabel: UILabel!
    @IBOutlet private weak var issueNumberLabel: UILabel!
    @IBOutlet private weak var variantLetterLabel: UILabel!
    @IBOutlet weak var VolumePrintingLabel: UILabel!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var isOwnedSwitch: UISwitch!
    
    var comicBookCollection: JsonModel!
    
    @IBAction func isOwnedAction(_ sender: Any) {
        
        comicBookCollection.selectedVolumeSelectedWork.isOwned = isOwnedSwitch.isOn
        comicBookCollection.addWorkToSelectedVolume(comicBookCollection.selectedVolumeSelectedWork)
        
        updateUX()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        print("delete action")
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
        updateUX()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
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
    
    func updateUX() {
        
        let seriesTitle = comicBookCollection.selectedVolume.seriesName
        let publisherName = comicBookCollection.selectedVolume.publisherName
        let era = comicBookCollection.selectedVolume.era
        let workNumber = comicBookCollection.selectedVolumeSelectedWork.issueNumber
        let variantLetter = comicBookCollection.selectedVolumeSelectedWork.variantLetter
        let volumeNumber = comicBookCollection.selectedVolume.volumeNumber
        let coverImage = comicBookCollection.selectedVolumeSelectedWork.coverImage
        let isOwned = comicBookCollection.selectedVolumeSelectedWork.isOwned
        
        
        titleLabel.text = seriesTitle
        publisherLabel.text = "\(publisherName) \(era)"
        issueNumberLabel.text = "#\(workNumber)"
        variantLetterLabel.text = "\(variantLetter)"
        VolumePrintingLabel.text = "Vol. \(volumeNumber)"
        
        coverImageView.alpha = 0
        coverImageView.image = UIImage(named: coverImage)
        UIView.animate(withDuration: 1.0, animations: {
            self.coverImageView.alpha = 1.0
        }, completion: nil)
        
        isOwnedSwitch.setOn(isOwned, animated: true)
        navigationController?.isToolbarHidden = false
    }
}
