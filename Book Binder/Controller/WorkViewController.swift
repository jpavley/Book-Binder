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
    
    // MARK:- Actions
    
    @IBAction func takePhotoAction(_ sender: Any) {
    }
    
    @IBAction func photoLibraryAction(_ sender: Any) {
    }
    
    @IBAction func cancelAction(_ sender: Any) {
    }

    @IBAction func saveAction(_ sender: Any) {
    }


    

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
