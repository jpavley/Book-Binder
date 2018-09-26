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
    
    let columnCount = CGFloat(6)
    let collectionViewMinSpacing = CGFloat(2)
    let cellHeight = CGFloat(40)
    
    var collectionData1 = [
        "...", "583", "584", "585", "586", "587", "588",
        "589", "590", "591", "592", "593", "594", "595",
        "596", "597", "598", "599", "600", "601", "602",
        "603", "604", "605", "606", "607", "608", "+"
    ]
    
    var collectionData2 = [
        "...", "1v", "2", "3", "4", "+"
    ]
    
    var collectionData3 = [
        "...", "45", "46", "47", "48", "49", "50",
        "51", "52", "53", "54", "55", "56", "57",
        "58", "59", "60", "61", "62", "63", "64",
        "65", "66", "67", "68", "69", "70", "+",
    ]

    
    @IBAction func addItem() {
        
        // add one item per touch
        
        collectionView.performBatchUpdates({
            // addItems(itemList: ["\(collectionData.count + 1) 😈"])
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
                // collectionData.remove(at: item)
            }
            
            collectionView.deleteItems(at: selected)
        }
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // collection view layout sizing
        
        let spacesBetweenColumns = columnCount - 1
        let totalSpacing = collectionViewMinSpacing * spacesBetweenColumns
        
        let width = (view.frame.size.width - totalSpacing) / columnCount
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: cellHeight)
        
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
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationController?.isToolbarHidden = true
    }
    
    // editing mode
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        // enable edit mode on the collection with multiple selection
        
        super.setEditing(editing, animated: animated)
        collectionView.allowsMultipleSelection = editing
        
        // ensure all cells are deselected when entering or exiting edit more
        
        collectionView.indexPathsForSelectedItems?.forEach {
            collectionView.deselectItem(at: $0, animated: false)
        }
        
        // set the editing state of each visible cell
        
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            cell.isEditing = editing
        }
        
        // add buttomn management
        
        addButton.isEnabled = !editing
        
        // tool bar management
        
        if !editing {
            navigationController?.isToolbarHidden = true
        }
        
    }
    
    
    // pull to refresh
    
    @objc func refresh() {
        
        // ad more than one item per pull
        
        collectionView.performBatchUpdates({
            //addItems(itemList: ["\(collectionData.count + 1) 👽", "\(collectionData.count + 2) 💩"])
        }, completion: nil)
        
        collectionView.refreshControl?.endRefreshing()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! CollectionReusableView
            
            if indexPath.section == 0 {
                headerView.titleLabel.text = "Daredevil 2018"
                headerView.subTitleLabel.text = "Marvel Entertainment, Comicbook"
            }
            
            if indexPath.section == 1  {
                headerView.titleLabel.text = "Doctor Strange 2018"
                headerView.subTitleLabel.text = "Marvel Entertainment, Comicbook"
            }
            
            if indexPath.section == 2 {
                headerView.titleLabel.text = "ROM Spaceknight 1979"
                headerView.subTitleLabel.text = "Marvel Comics Group, Comicbook"
            }
            
            return headerView
            
        default:
            assert(false, "unexpected UICollection element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return collectionData1.count
        }
        
        if section == 1 {
            return collectionData2.count
        }

        if section == 2 {
            return collectionData3.count
        }
        
        return 0

        //return collectionData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        if indexPath.section == 0 {
            
            let blueStrings = ["...", "605", "606", "607", "608", "+"]
            
            if blueStrings.contains(collectionData1[indexPath.row]) {
                
                let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                    NSAttributedString.Key.foregroundColor: UIColor.blue
                ]
                
                cell.titleLabel.attributedText = NSAttributedString(string: collectionData1[indexPath.row], attributes: attributes)
            } else {
                
                let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                    NSAttributedString.Key.foregroundColor: UIColor.red,
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                ]
                
                cell.titleLabel.attributedText = NSAttributedString(string: collectionData1[indexPath.row], attributes: attributes)
            }
        }
        
        if indexPath.section == 1 {
            
            let blueStrings = ["...", "1v", "3", "4", "+"]
            
            if blueStrings.contains(collectionData2[indexPath.row]) {
                
                let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                    NSAttributedString.Key.foregroundColor: UIColor.blue
                ]
                
                cell.titleLabel.attributedText = NSAttributedString(string: collectionData2[indexPath.row], attributes: attributes)
            } else {
                
                let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                    NSAttributedString.Key.foregroundColor: UIColor.red,
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                ]
                
                cell.titleLabel.attributedText = NSAttributedString(string: collectionData2[indexPath.row], attributes: attributes)
            }
        }
        
        if indexPath.section == 2 {
            
            let blueStrings = ["...", "49", "52", "55", "57", "58", "59", "63", "69", "70", "+"]
            
            if blueStrings.contains(collectionData3[indexPath.row]) {
                
                let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                    NSAttributedString.Key.foregroundColor: UIColor.blue
                ]
                
                cell.titleLabel.attributedText = NSAttributedString(string: collectionData3[indexPath.row], attributes: attributes)
            } else {
                
                let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                    NSAttributedString.Key.foregroundColor: UIColor.red,
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                ]
                
                cell.titleLabel.attributedText = NSAttributedString(string: collectionData3[indexPath.row], attributes: attributes)
            }
        }

        
        
        cell.isEditing = isEditing
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if let selected = collectionView.indexPathsForSelectedItems, selected.count == 0 {
                navigationController?.isToolbarHidden = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        if isEditing {
            navigationController?.isToolbarHidden = false
        } else {
            performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        }
        
        if indexPath.section == 0 {
            let text = collectionData1[indexPath.row]
            print(text)
        }
        
        if indexPath.section == 1 {
            let text = collectionData2[indexPath.row]
            print(text)
        }
        
        if indexPath.section == 2 {
            let text = collectionData3[indexPath.row]
            print(text)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "DetailSegue" {
            return
        }
        
        // code for selection passing with manual segue
        
        if let dest = segue.destination as? DetailViewController,
            let index = sender as? IndexPath {
            
            if index.section == 0 {
                dest.selection = collectionData1[index.row]
            }
            
            if index.section == 1 {
                dest.selection = collectionData2[index.row]
            }
            
            if index.section == 2 {
                dest.selection = collectionData3[index.row]
            }
        }
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
        //collectionData.append(item)
    }
    
    func updateCollectionView() {
//        let indexPath = IndexPath(row: collectionData.count - 1, section: 0)
//        collectionView.insertItems(at: [indexPath])
    }
}

