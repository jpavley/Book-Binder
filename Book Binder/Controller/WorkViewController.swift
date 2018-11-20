//
//  WorkViewController.swift
//  Book Binder
//
//  Created by John Pavley on 11/19/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

class WorkViewController: UIViewController {
    
    // MARK:- Outlets
    
    @IBOutlet weak var seriesTitleLabel: UILabel!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var issueNumberField: UITextField!
    @IBOutlet weak var variantLetterField: UITextField!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var isOwnedSwitch: UISwitch!
    
    // MARK:- Properties
    
    var comicBookCollection: JsonModel!
    
    // MARK:- Actions
    
    @IBAction func takePhotoAction(_ sender: Any) {
    }
    
    @IBAction func photoLibraryAction(_ sender: Any) {
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func isOwnedAction(_ sender: Any) {
    }
    
    @IBAction func saveAction(_ sender: Any) {
    }
    
    // MARK:- Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let isOwned = comicBookCollection.selectedVolumeSelectedWork.isOwned
        isOwnedSwitch.setOn(isOwned, animated: true)

        updateUX()
    }
    
    // MARK:- Methods
    
    func updateUX() {
        let seriesTitle = comicBookCollection.selectedVolume.seriesName
        let publisherName = comicBookCollection.selectedVolume.publisherName
        let era = comicBookCollection.selectedVolume.era
        let workNumber = comicBookCollection.selectedVolumeSelectedWork.issueNumber
        let variantLetter = comicBookCollection.selectedVolumeSelectedWork.variantLetter
        let coverImage = comicBookCollection.selectedVolumeSelectedWork.coverImage
        
        seriesTitleLabel.text = "\(seriesTitle) \(era)"
        publisherNameLabel.text = "\(publisherName)"
        issueNumberField.text = "\(workNumber)"
        variantLetterField.text = "\(variantLetter)"
        
        coverPhotoImageView.alpha = 0
        coverPhotoImageView.image = UIImage(named: coverImage)
        UIView.animate(withDuration: 1.0, animations: {
            self.coverPhotoImageView.alpha = 1.0
        }, completion: nil)

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
