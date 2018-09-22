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
            addItems(itemList: ["\(collectionData.count + 1) 😈"])
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // cllection vuew layout sizing
        
        let collectionViewMinSpacing = CGFloat(10)
        let columnCount = CGFloat(3)
        let spacesBetweenColumns = columnCount - 1
        let totalSpacing = collectionViewMinSpacing * spacesBetweenColumns
        
        let width = (view.frame.size.width - totalSpacing) / columnCount
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        // pull to refresh
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refresh
    }
    
    // pull to refresh
    
    @objc func refresh() {
        
        collectionView.performBatchUpdates({
            addItems(itemList: ["\(collectionData.count + 1) 👽", "\(collectionData.count + 2) 💩"])
        }, completion: nil)
        
        collectionView.refreshControl?.endRefreshing()
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

/// Adding one more items
extension ViewController {
    
    func addItems(itemList: [String]) {
        for item in itemList {
            
            // First update model
            addItemToModel(item: item)
            
            // Second update view
            updateCollectionView()
        }
    }
    
    func addItemToModel(item: String) {
        collectionData.append(item)
    }
    
    func updateCollectionView() {
        let indexPath = IndexPath(row: collectionData.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
}

