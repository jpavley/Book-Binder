//
//  PropteriesViewController.swift
//  Book Binder
//
//  Created by John Pavley on 12/10/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

class PropertiesViewController: UIViewController {
    
    @IBOutlet weak var issueField: UITextField!
    @IBOutlet weak var variantField: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var containerView: UIView!
    
    var comicBookCollection: JsonModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 5
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
