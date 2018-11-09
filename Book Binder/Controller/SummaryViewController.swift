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
    
    var comicBookCollection: ComicBookCollection!
    
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
        
        var jsonModel: JsonModel!
        
        // load from user defaults
        let defaults = UserDefaults.standard
        do {
            // Encode the JsonModel as JSON
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(jsonModel)
            
            // Save the JSON to user defaults with the key savedJsonModel
            defaults.set(encoded, forKey: "savedJsonModel")
            
            // Load the JSON back from user defaults with the key savedJsonModel
            if let savedJsonModel = defaults.object(forKey: "savedJsonModel") as? Data {
                
                // Decode the JSON as a JsonModel
                let decoder = JSONDecoder()
                jsonModel = try decoder.decode(JsonModel.self, from: savedJsonModel)
                
                // Create a ComicBookCollection with the JsonModel
                comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
            }
        } catch {
            // failing -> can't load data!
            print(error)
        }


        // load from JSON
        if let path = Bundle.main.path(forResource: "sample1", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                do {
                    let decoder = JSONDecoder()
                    jsonModel = try decoder.decode(JsonModel.self, from: data)
                    
                    // succeeding -> data loaded and decoded
                    comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
                } catch {
                    // failing -> can't decode!
                    print(error)
                }
                
            } catch {
                // failing -> can't load data!
                print(error)
            }
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
            
            let collectible = getComicbookCollectibleFor(indexPath: indexPath)
            
            headerView.titleLabel.text = "\(collectible.series.title) \(collectible.volume.era)"
            headerView.subTitleLabel.text = collectible.publisher.name
            
            return headerView
            
        default:
            assert(false, "BOOKBINDERAPP: unexpected UICollection element kind")
            return CollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        let keys = comicBookCollection.comicBookDictionary.keys.sorted()
        let lastKey = keys.last!
        let sections = lastKey.section + 1
        
        return sections
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

        // The first cell (0) should be the ... icon for editing the series
        // The last cell (series.publishedIssues.count + 2) should be the + icon for adding a book
        
//        if indexPath.row == 0 {
//
//            currentIssueString = "..."
//
//        } else if indexPath.row == (collectable.publishedIssues.count + 1) {
//
//            // offset the published issue count by 1 to account for ... and + icons
//            currentIssueString = "+"
//
//        } else {
//
//            let uri = comicBookCollection.comicBookDictionary[indexPath]
//            let collectable = comicBookCollection.comicBookCollectibleBy(uri: uri!)
//            let publishedIssue = getPublishedIssueFor(indexPath: offsetIndexPath)
//            currentIssueString = "\(publishedIssue)"
//        }
        return currentIssueString
    }
    
    /// Blue strings are either the icons or the issues the user owns.
    func calcBlueStrings(indexPath: IndexPath) -> [String] {
        //let offsetIndexPath = calcOffsetIndexPath(indexPath: indexPath)
        //let collectible = getComicbookCollectibleFor(indexPath: offsetIndexPath)
        let collectible = getComicbookCollectibleFor(indexPath: indexPath)
        var blueStrings = ["..."]
        blueStrings.append(contentsOf: ["1","2","3"])
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
            let uri = comicBookCollection.comicBookDictionary[offsetIndexPath]
            comicBookCollection.comicBookModel.selectedURI = uri!.description
            
            dest.comicBookCollection = comicBookCollection
        }
    }
}

// MARK: - Get objects by index path -

extension SummaryViewController {
    
    func getComicbookCollectibleFor(indexPath: IndexPath) -> ComicBookCollectible {
        //let offsetIndexPath = calcOffsetIndexPath(indexPath: indexPath)
        //let uri = comicBookCollection.comicBookDictionary[offsetIndexPath]
        let uri = comicBookCollection.comicBookDictionary[indexPath]
        let comicBookCollectable = comicBookCollection.comicBookCollectibleBy(uri: uri!)
        return comicBookCollectable
    }
    
    func getPublishedIssueFor(indexPath: IndexPath) -> Int {
        let collectible = getComicbookCollectibleFor(indexPath: indexPath)
        return collectible.work.number
    }
}

