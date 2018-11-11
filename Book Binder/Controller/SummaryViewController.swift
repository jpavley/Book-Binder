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
    
    var comicBookCollection: JsonModel!
    
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
        
        if comicBookCollection == nil {
            updateComicBookCollectionData()
        } else {
            collectionView.reloadData()
        }
    }
    func updateComicBookCollectionData() {
        
        if let savedCollection = readUserDefaults(for: defaultsKey) {
            self.comicBookCollection = savedCollection
        } else if let sampleCollection = initFromBundle(forResource: "sample1", ofType: "json") {
            self.comicBookCollection = sampleCollection
        } else {
            print("no data in local phone stroage or in application bundle")
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

extension SummaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! CollectionReusableView
            
            comicBookCollection.selectedVolumeIndex = indexPath.section
            
            let title = comicBookCollection.selectedVolume.seriesName
            let era = comicBookCollection.selectedVolume.era
            let publisher = comicBookCollection.selectedVolume.publisherName
            
            headerView.titleLabel.text = "\(title) \(era)"
            headerView.subTitleLabel.text = publisher
            
            return headerView
            
        default:
            assert(false, "BOOKBINDERAPP: unexpected UICollection element kind")
            return CollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        comicBookCollection.selectedVolumeIndex = section
        return comicBookCollection.completeWorks.count + 2 // for ... and +
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return comicBookCollection.volumes.count
    }
    
    /// The offset index path takes into account that the first cell is the ... icon.
    func calcOffsetIndexPath(indexPath: IndexPath) -> IndexPath {
        // offset by -1 because first cell contains ... icon
        return IndexPath(row: indexPath.item - 1, section: indexPath.section)
    }
    
    /// The offset index path takes into account that the first cell is the ... icon.
    func calcResetIndexPath(indexPath: IndexPath) -> IndexPath {
        // offset by 1 because first cell contains ... icon
        return IndexPath(row: indexPath.item + 1, section: indexPath.section)
    }

    
    /// The current issue string is either ..., +, or a published issue number.
    func calcCurrentIssueString(indexPath: IndexPath) -> String {
        var currentIssueString = ""
        let offsetIndexPath = calcOffsetIndexPath(indexPath: indexPath)
        comicBookCollection.selectedVolumeIndex = offsetIndexPath.section

        // The first cell (0) should be the ... icon for editing the series
        // The last cell (series.publishedIssues.count + 2) should be the + icon for adding a book
        
        if indexPath.item == 0 {

            currentIssueString = "..."

        } else if indexPath.item == (comicBookCollection.completeWorks.count + 1) {

            // offset the published issue count by 1 to account for ... and + icons
            currentIssueString = "+"

        } else {

            currentIssueString = "\(comicBookCollection.completeWorks[offsetIndexPath.item])"
        }
        return currentIssueString
    }
    
    /// Blue strings are either the icons or the issues the user owns.
    func calcBlueStrings(indexPath: IndexPath) -> [String] {
        let offsetIndexPath = calcOffsetIndexPath(indexPath: indexPath)
        comicBookCollection.selectedVolumeIndex = offsetIndexPath.section
        return comicBookCollection.selectedVolumeCollectedWorkIDs
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
            
            comicBookCollection.selectedVolumeIndex = offsetIndexPath.section
            comicBookCollection.selectedVolume.selectedWorkIndex = offsetIndexPath.item
            
            dest.comicBookCollection = comicBookCollection
        }
    }
}
