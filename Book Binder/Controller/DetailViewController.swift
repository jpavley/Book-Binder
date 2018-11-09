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
    
    var comicBookCollection: ComicBookCollection!
    
    @IBAction func isOwnedAction(_ sender: Any) {
        
        if isOwnedSwitch.isOn {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yyyy"
            let dateCollected = df.string(from: Date())
            // TODO: update comicBookModel
            // comicBookCollectible.variant.dateConsumed = dateCollected
        } else {
            // TODO: update comicBookModel
            // comicBookCollectible.variant.dateConsumed = ""
        }
        
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
            // next book
            comicBookCollection.selectNextIssue()
        case .right:
            // previous book
            comicBookCollection.selectPreviousIssue()
        case .up:
            // next series
            comicBookCollection.selectNextSeries()
        case .down:
            // previous book
            comicBookCollection.selectPreviousSeries()
        default:
            assert(false, "BOOKBINDERAPP: unsupported gesture")
        }
        
        updateUX()
    }
    
    func updateUX() {
        
        let uri = BookBinderURI(from: comicBookCollection.comicBookModel.selectedURI)
        let collectible = comicBookCollection.comicBookCollectibleBy(uri: uri!)
        
        titleLabel.text = "\(collectible.series.title)"
        publisherLabel.text = "\(collectible.publisher.name) \(collectible.volume.era)"
        issueNumberLabel.text = "#\(collectible.work.number)"
        variantLetterLabel.text = "\(collectible.variant.letter)"
        
        let volume = calcVolumeText(volume: Int(collectible.volume.number))
        let printing = calcPrintingText(printing: collectible.variant.printing)
        let conjunction = (volume == "") || (printing == "") ? "" : ", "
        
        VolumePrintingLabel.text = "\(volume)\(conjunction)\(printing)"
        
        coverImageView.alpha = 0
        coverImageView.image = UIImage(named: "\(collectible.variant.coverID)")
        UIView.animate(withDuration: 1.0, animations: {
            self.coverImageView.alpha = 1.0
        }, completion: nil)
        
        isOwnedSwitch.setOn(collectible.isOwned, animated: true)
        navigationController?.isToolbarHidden = false
    }
    
    func calcVolumeText(volume: Int) -> String {
        return "Vol. \(volume)"
    }
    
    func calcPrintingText(printing: Int) -> String {
        return "Printing \(printing)"
    }
}
