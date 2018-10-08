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
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var isOwnedSwitch: UISwitch!
    
    var selection: BookModel!
    
    
    @IBAction func isOwnedAction(_ sender: Any) {
        selection.isOwned = isOwnedSwitch.isOn
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
        updateUX()
    }
    
    func updateUX() {
        titleLabel.text = "\(selection.bookTitle)"
        publisherLabel.text = "\(selection.bookPublisher) \(selection.bookEra)"
        issueNumberLabel.text = "#\(selection.issueNumber)"
        variantLetterLabel.text = "\(selection.variantLetter)"
        
        let coverName = publisherCover(for: selection.bookPublisher)
        coverImageView.image = UIImage(named: coverName)
        isOwnedSwitch.isOn = selection.isOwned
        
        navigationController?.isToolbarHidden = false
    }
    
    func publisherCover(for publisher: String) -> String {
        switch publisher {
        case "Marvel Entertainment":
            return "x-men-101"
        case "DC Comics":
            return "lois-lane-111"
        case "NBM":
            return "logans-run-6"
        default:
            return "identity-crisis-7-b"
        }
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
