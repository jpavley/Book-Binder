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
    
    var bookBinder: BookBinder!
    
    @IBAction func isOwnedAction(_ sender: Any) {
        
        let selectedBook = bookBinder.getSelectedIssue()
        selectedBook.isOwned = isOwnedSwitch.isOn
        
        bookBinder.updateBooks(with: selectedBook)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(bookBinder.jsonModel) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "savedJsonModel")
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
            bookBinder.selectNextIssue()
        case .right:
            // previous book
            bookBinder.selectPreviousIssue()
        case .up:
            // next series
            bookBinder.selectNextComicbook()
        case .down:
            // previous book
            bookBinder.selectPreviousComicbook()
        default:
            assert(false, "BOOKBINDERAPP: unsupported gesture")
        }
        
        updateUX()
    }
    
    func updateUX() {
        
        let selectedBook = bookBinder.getSelectedIssue()
        
        titleLabel.text = "\(selectedBook.bookTitle)"
        publisherLabel.text = "\(selectedBook.bookPublisher) \(selectedBook.bookEra)"
        issueNumberLabel.text = "#\(selectedBook.issueNumber)"
        variantLetterLabel.text = "\(selectedBook.variantLetter)"
        
        let volume = calcVolume(volume: Int(selectedBook.bookVolume)!)
        let printing = calcPrinting(printing: selectedBook.printing)
        let conjunction = (printing == "") ? "" : ", "
        
        VolumePrintingLabel.text = "\(volume)\(conjunction)\(printing)"
        
        coverImageView.alpha = 0
        coverImageView.image = UIImage(named: "\(selectedBook.coverImageID)")
        UIView.animate(withDuration: 1.0, animations: {
            self.coverImageView.alpha = 1.0
        }, completion: nil)
        
        isOwnedSwitch.setOn(selectedBook.isOwned, animated: true)
        navigationController?.isToolbarHidden = false
    }
    
    func calcVolume(volume: Int) -> String {
        switch volume {
        case 0:
            return ""
        case 1:
            return "volume I"
        case 2:
            return "volume II"
        case 3:
            return "volume III"
        case 4:
            return "volume IV"
        case 5:
            return "volume V"
        case 6:
            return "volume VI"
        default:
            return "volume \(volume)"
        }
    }
    
    func calcPrinting(printing: Int) -> String {
        switch printing {
        case 0:
            return ""
        case 1:
            return "first printing"
        case 2:
            return "second printing"
        case 3:
            return "third printing"
        case 4:
            return "fourth printing"
        case 5:
            return "fifth printing"
        case 6:
            return "sixth printing"
        default:
            return "\(printing)th printing"
        }
    }
}
