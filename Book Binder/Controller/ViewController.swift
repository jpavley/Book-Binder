//
//  ViewController.swift
//  Book Binder
//
//  Created by John Pavley on 9/16/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK:- Outlets -
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    
    // MARK:- Constants -
    
    let columnCount = CGFloat(6)
    let collectionViewMinSpacing = CGFloat(2)
    let cellHeight = CGFloat(40)
    
    // MARK:- Properties -
    
    var comicbooks = [Comicbook]()
    
    // MARK:- Actions -
    
    @IBAction func addItem() {
        collectionView.performBatchUpdates({
            // TODO: Add comicbook
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
            for _ in items {
                // TODO: Remove comicbook
            }
            
            collectionView.deleteItems(at: selected)
        }
        navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Startup -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func collectionViewLayout() {
            let spacesBetweenColumns = columnCount - 1
            let totalSpacing = collectionViewMinSpacing * spacesBetweenColumns
            
            let width = (view.frame.size.width - totalSpacing) / columnCount
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: cellHeight)
        }
        
        func pullToRefreshSetup() {
            let refresh = UIRefreshControl()
            refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
            collectionView.refreshControl = refresh
        }
        
        func editModeSetup() {
            navigationItem.leftBarButtonItem = editButtonItem
            navigationItem.leftBarButtonItem?.isEnabled = false
            navigationController?.isToolbarHidden = true
        }
        
        func loadComicbookData() {
            if let path = Bundle.main.path(forResource: "books", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    comicbooks = Comicbook.createFrom(jsonData: data)!
                } catch {
                    // TODO: books.json probably not found
                }
            }
        }
        
        collectionViewLayout()
        pullToRefreshSetup()
        editModeSetup()
        loadComicbookData()
    }
    
    // MARK:- Editing -
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        // TODO: Choose sections (comicbooks) not cells (issues) for editing
        
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
        
        collectionView.performBatchUpdates({
            // TODO: Update comicbook data from a server
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
        
        // add 2 to the published issues count for the ... and + icons
        let result = seriesModel.publishedIssues.count + 2
        return result
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicbooks.count
    }
    
    /// The offset index path takes into account that the first cell is the ... icon.
    func calcOffsetIndexPath(indexPath: IndexPath) -> IndexPath {
        // offset by -1 because first cell contains ... icon
        return IndexPath(row: indexPath.row - 1, section: indexPath.section)
    }
    
    /// The current issue string is either ..., +, or a published issue number.
    func calcCurrentIssueString(indexPath: IndexPath) -> String {
        var currentIssueString = ""
        let seriesModel = getSeriesModelFor(indexPath: indexPath)
        let offsetIndexPath = calcOffsetIndexPath(indexPath: indexPath)
        
        // The first cell (0) should be the ... icon for editing the series
        // The last cell (seriesModel.publishedIssues.count + 2) should be the + icon for adding a book
        
        if indexPath.row == 0 {
            
            currentIssueString = "..."
            
        } else if indexPath.row == (seriesModel.publishedIssues.count + 1) {
            
            // offset the published issue count by 1 to account for ... and + icons
            currentIssueString = "+"
            
        } else {
            
            let publishedIssue = getPublishedIssueFor(indexPath: offsetIndexPath)
            currentIssueString = "\(publishedIssue)"
        }
        return currentIssueString
    }
    
    /// Blue strings are either the icons or the issues the user owns.
    func calcBlueStrings(indexPath: IndexPath) -> [String] {
        let offsetIndexPath = calcOffsetIndexPath(indexPath: indexPath)
        let comicbook = getComicbookFor(indexPath: offsetIndexPath)
        var blueStrings = ["..."]
        blueStrings.append(contentsOf: comicbook.ownedIssues())
        blueStrings.append("+")
        return blueStrings
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentIssueString = calcCurrentIssueString(indexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let blueStrings = calcBlueStrings(indexPath: indexPath)
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "DetailSegue" {
            return
        }
        
        if let dest = segue.destination as? DetailViewController, let indexPath = sender as? IndexPath {
            dest.selection = calcCurrentIssueString(indexPath: indexPath)
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
        // TODO: Add sections, not cell
    }
    
    func updateCollectionView() {
        // TODO: Update sections, not cells
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

