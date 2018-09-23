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
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    
    let columnCount = CGFloat(3)
    
    var collectionData = ["1 🏆", "2 🐸", "3 🍩", "4 😸", "5 🤡", "6 👾",
                      "7 👻", "8 🍖", "9  🎸", "10 🐯", "11 🐷", "12 🌋"]
    
    @IBAction func addItem() {
        
        // add one item per touch
        
        collectionView.performBatchUpdates({
            addItems(itemList: ["\(collectionData.count + 1) 😈"])
        }, completion: nil)
    }
    
    @IBAction func deleteItems() {
        
        if let selected = collectionView.indexPathsForSelectedItems {
            
            // sort and reverse the order of the selected items so we
            // are deleting them last to first and not messing up
            // the index paths. Otherwise we would have to delete
            // by tag or id. Index paths are based on position from the
            // beginning of the visible items.
            let items = selected.map { $0.item }.sorted().reversed()
            for item in items {
                collectionData.remove(at: item)
            }
            
            collectionView.deleteItems(at: selected)
        }
        
        // my code
        
//        if let indexPaths = collectionView!.indexPathsForSelectedItems {
//
//            collectionView.performBatchUpdates({
//
//                for indexPath in indexPaths {
//                    collectionData.remove(at: indexPath.row)
//                    collectionView.deleteItems(at: [indexPath])
//                }
//            }, completion: nil)
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // collection view layout sizing
        
        let collectionViewMinSpacing = CGFloat(10)
        let spacesBetweenColumns = columnCount - 1
        let totalSpacing = collectionViewMinSpacing * spacesBetweenColumns
        
        let width = (view.frame.size.width - totalSpacing) / columnCount
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        // pull to refresh
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refresh
        
        // editing mode
        // This one line of code does so much!
        // - Adds an edit button to the left side of the
        // - Toggles the button between Edit and Done
        // - Toggles the view controller between editing and not-editing mode
        navigationItem.leftBarButtonItem = editButtonItem
        navigationController?.isToolbarHidden = true
    }
    
    // editing mode
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        addButton.isEnabled = !editing
        deleteButton.isEnabled = editing
        navigationController?.isToolbarHidden = !editing
        collectionView.allowsMultipleSelection = editing
        
        // set the editing state of each visible cell
        
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            cell.isEditing = editing
        }
    }
    
    
    // pull to refresh
    
    @objc func refresh() {
        
        // ad more than one item per pull
        
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
                                                      for: indexPath) as! CollectionViewCell
        
        // editing mode
        
        cell.titleLabel.text = collectionData[indexPath.row]
        cell.isEditing = isEditing
        
        // code prior to custom collection cell
        
//        if let label = cell.viewWithTag(100) as? UILabel {
//            label.text = collectionData[indexPath.row]
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        if isEditing {
            // Don't segue if in editing mode
            return
        }
        
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

/// Add one or more items to the collection and update the view
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

