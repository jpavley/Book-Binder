//
//  SummaryViewController.swift
//  Book Binder
//
//  Created by John Pavley on 9/16/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    // MARK:- Outlets -
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    
    // MARK:- Constants -
    
    let columnCount = CGFloat(6)
    let collectionViewMinSpacing = CGFloat(2)
    let cellHeight = CGFloat(40)
    
    // MARK:- Properties -
    
    var bookBinder: BookBinder!
    
    // MARK:- Actions -
    
    @IBAction func addItem() {
        collectionView.performBatchUpdates({
            // TODO: Add series
        }, completion: nil)
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
        
        func toolbarSetup() {
            navigationController?.isToolbarHidden = true
        }
        
        collectionViewLayout()
        pullToRefreshSetup()
        toolbarSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if bookBinder == nil {
            updateBookBinderData()
        } else {
            collectionView.reloadData()
        }
    }
    func updateBookBinderData() {
        
        if let comicbooks = loadComicbookDataFromJSON() {
            bookBinder = BookBinder(comicbooks: comicbooks, selectedComicbookIndex: 0, selectedIssueIndex: 0)
            return
        }
        
        // No comic book data, create an empty book binder
        bookBinder = BookBinder(comicbooks: [Comicbook(seriesURI: BookBinderURI(fromURIString: ""))], selectedComicbookIndex: 0, selectedIssueIndex: 0)
    }
    
    func loadComicbookDataFromJSON() -> [Comicbook]? {
        if let path = Bundle.main.path(forResource: "books", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return Comicbook.createFrom(jsonData: data)!
            } catch {
                // TODO: books.json probably not found
            }
        }
        return nil
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

extension SummaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
            assert(false, "BOOKBINDERAPP: unexpected UICollection element kind")
            return CollectionReusableView()
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
        return bookBinder.comicbooks.count
    }
    
    /// The offset index path takes into account that the first cell is the ... icon.
    func calcOffsetIndexPath(indexPath: IndexPath) -> IndexPath {
        // offset by -1 because first cell contains ... icon
        return IndexPath(row: indexPath.row - 1, section: indexPath.section)
    }
    
    /// The offset index path takes into account that the first cell is the ... icon.
    func calcResetIndexPath(indexPath: IndexPath) -> IndexPath {
        // offset by 1 because first cell contains ... icon
        return IndexPath(row: indexPath.row + 1, section: indexPath.section)
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
        return cell
    }
    
    /// Did Select Item At
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        if isEditing {
            navigationController?.isToolbarHidden = false
        } else {
            // return if these are the special cells that represent other actions
            let issueString = calcCurrentIssueString(indexPath: indexPath)
            if issueString == "..." || issueString == "+" {
                return
            }
            
            // continue to detail view control to display selected book
            performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? DetailViewController, let indexPath = sender as? IndexPath {
            
            let offsetIndexPath = calcOffsetIndexPath(indexPath: indexPath)
            bookBinder.selectedComicbookIndex = offsetIndexPath.section
            bookBinder.selectedIssueIndex = offsetIndexPath.row
            
            dest.bookBinder = bookBinder
        }
    }
}

// MARK: - Get objects by index path -

extension SummaryViewController {
    
    func getComicbookFor(indexPath: IndexPath) -> Comicbook {
        return bookBinder.comicbooks[indexPath.section]
    }
    
    func getSeriesModelFor(indexPath: IndexPath) -> SeriesModel {
        return getComicbookFor(indexPath: indexPath).series
    }
    
    func getPublishedIssueFor(indexPath: IndexPath) -> Int {
        let seriesModel = getSeriesModelFor(indexPath: indexPath)
        return seriesModel.publishedIssues[indexPath.row]
    }
    
    func getBookModelFor(indexPath: IndexPath) -> BookModel {
        // DUPE: 100 start
        let comicbook = getComicbookFor(indexPath: indexPath)
        let issueNumber = getPublishedIssueFor(indexPath: indexPath)
        
        for (_, value) in comicbook.books {
            if issueNumber == value.issueNumber {
                // This ia a book the user owns or is tracking
                return value
            }
        }
        
        // This is a book the user doesn't own yet...
        return BookModel(seriesURI: comicbook.series.seriesURI, issueNumber: issueNumber, variantLetter: "", isOwned: false, coverImageID: "")
        // DUPE: 100 end
    }
}

