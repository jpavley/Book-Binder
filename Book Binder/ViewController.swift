//
//  ViewController.swift
//  Book Binder
//
//  Created by John Pavley on 9/16/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var collectionData = ["1 🏆", "2 🐸", "3 🍩", "4 😸", "5 🤡", "6 👾",
                      "7 👻", "8 🍖", "9  🎸", "10 🐯", "11 🐷", "12 🌋"]
    
    @IBAction func addItem() {
        
        // add more than one item per touch
        
        collectionView.performBatchUpdates({
            for _ in 0 ..< 2 {
                // First: Add the new data to the data model
                let text = "\(collectionData.count + 1) 👽"
                collectionData.append(text)
                
                // Second: Update the collection view
                let indexPath = IndexPath(row: collectionData.count - 1, section: 0)
                collectionView.insertItems(at: [indexPath])
            }
        }, completion: nil)
        
        // add only one item per touch
        
//        // First: Add the new data to the data model
//        let text = "\(collectionData.count + 1) 👽"
//        collectionData.append(text)
//        
//        // Second: Update the collection view
//        let indexPath = IndexPath(row: collectionData.count - 1, section: 0)
//        collectionView.insertItems(at: [indexPath])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let collectionViewMinSpacing = CGFloat(10)
        let columnCount = CGFloat(3)
        let spacesBetweenColumns = columnCount - 1
        let totalSpacing = collectionViewMinSpacing * spacesBetweenColumns
        
        let width = (view.frame.size.width - totalSpacing) / columnCount
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell",
                                                      for: indexPath)
        
        if let label = cell.viewWithTag(100) as? UILabel {
            label.text = collectionData[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let text = collectionData[indexPath.row]
        print("selected \(text)")
        
        // code for selection passing with manual segue
        
        performSegue(withIdentifier: "DetailSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "DetailSegue" {
            return
        }
        
        // code for selection passing with manual segue
        
        if let dest = segue.destination as? DetailViewController,
            let index = sender as? IndexPath {
            
            dest.selection = collectionData[index.row]
        }

        
        // orignal code for selection passing with automated segue
        
//        if let dest = segue.destination as? DetailViewController,
//            let index = collectionView.indexPathsForSelectedItems?.first {
//
//            dest.selection = collectionData[index.row]
//        }
    }
}

