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
    
    var comicbooks = [Comicbook]()
    
    @IBAction func addItem() {
        
        // add one item per touch
        
        collectionView.performBatchUpdates({
            // addItems(itemList: ["\(collectionData.count + 1) 😈"])
        }, completion: nil)
    }
    
    @IBAction func deleteItems() {
        
        //        if let selected = collectionView.indexPathsForSelectedItems {
        
        // sort and reverse the order of the selected items so we
        // are deleting them last to first and not messing up
        // the index paths. Otherwise we would have to delete
        // by tag or id. Index paths are based on position from the
        // beginning of the visible items.
        //            let items = selected.map { $0.item }.sorted().reversed()
        //            for item in items {
        //                // collectionData.remove(at: item)
        //            }
        //
        //            collectionView.deleteItems(at: selected)
        //        }
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
        
        // load comicbook data from json file
        if let path = Bundle.main.path(forResource: "books", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                comicbooks = Comicbook.createFrom(jsonData: data)!
            } catch {
                // TODO: books.json probably not found
            }
        }
        
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

// MARK: - UICollectionView -

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! CollectionReusableView
            
            let seriesModel = getSeriesModelFor(indexPath: indexPath)
            
            headerView.titleLabel.text = "\(seriesModel.seriesTitle) \(seriesModel.seriesEra)"
            headerView.subTitleLabel.text = seriesModel.seriesPublisher
            
            return headerView
            
        default:
            assert(false, "unexpected UICollection element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        let indexPath = IndexPath(row: 0, section: section)
        let seriesModel = getSeriesModelFor(indexPath: indexPath)
        return seriesModel.publishedIssues.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicbooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let comicbook = getComicbookFor(indexPath: indexPath)
        let blueStrings = comicbook.ownedIssues()
        
        let publishedIssue = getPublishedIssueFor(indexPath: indexPath)
        let currentIssueString = "\(publishedIssue)"
        var attributes: [NSAttributedString.Key: Any]
        
        if blueStrings.contains(currentIssueString) {
            
            attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor: UIColor.blue
            ]
        } else {
            
            attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        }
        
        cell.titleLabel.attributedText = NSAttributedString(string: currentIssueString, attributes: attributes)
        cell.isEditing = isEditing
        return cell
    }
    
    /// Did Deselect Item At
    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if let selected = collectionView.indexPathsForSelectedItems, selected.count == 0 {
                navigationController?.isToolbarHidden = true
            }
        }
    }
    
    /// Did Select Item At
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        if isEditing {
            navigationController?.isToolbarHidden = false
        } else {
            performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        }
        
        let publishedIssue = getPublishedIssueFor(indexPath: indexPath)
        let text = "\(publishedIssue)"
        print(text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "DetailSegue" {
            return
        }
        
        // code for selection passing with manual segue
        
        if let dest = segue.destination as? DetailViewController,
            let indexPath = sender as? IndexPath {
            let publishedIssue = getPublishedIssueFor(indexPath: indexPath)
            dest.selection = "\(publishedIssue)"
        }
    }
    
    
}

// MARK: - Item Management -

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

// MARK: - Get objects by index path -

extension ViewController {
    
    func getComicbookFor(indexPath: IndexPath) -> Comicbook {
        return comicbooks[indexPath.section]
    }
    
    func getSeriesModelFor(indexPath: IndexPath) -> SeriesModel {
        return getComicbookFor(indexPath: indexPath).series
    }
    
    func getPublishedIssueFor(indexPath: IndexPath) -> Int {
        let seriesModel = getSeriesModelFor(indexPath: indexPath)
        return seriesModel.publishedIssues[indexPath.row]
    }
    
    func getBookModelFor(indexPath: IndexPath) -> BookModel {
        let comicbook = getComicbookFor(indexPath: indexPath)
        let issueNumber = getPublishedIssueFor(indexPath: indexPath)
        
        for book in comicbook.books {
            if issueNumber == book.issueNumber {
                // This ia a book the user owns or is tracking
                return book
            }
        }
        
        // This is a book the user doesn't own yet...
        return BookModel(seriesURI: comicbook.series.seriesURI, issueNumber: issueNumber, variantLetter: "", isOwned: false)
        
    }
}

