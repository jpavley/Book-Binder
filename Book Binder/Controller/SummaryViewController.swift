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
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // MARK:- Constants -
    
    let columnCount = CGFloat(5)
    let collectionViewMinSpacing = CGFloat(0)
    let cellHeight = CGFloat(100)
    let cellWidth = CGFloat(80)
    
    // MARK:- Properties -
    
    var comicBookCollection: JsonModel!
    
    // MARK:- Actions -
    
    @IBAction func addItem() {
        print("addItem touched")
    }
    
    @IBAction func snapItem(_ sender: Any) {
        print("snapItem touched")
    }
    
    // MARK: - Startup -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        func collectionViewLayout() {
            
            let calculatedColumnCount = (view.frame.size.width / cellWidth).rounded()
            let spacesBetweenColumns = calculatedColumnCount - 1
            let totalSpacing = collectionViewMinSpacing * spacesBetweenColumns
            
            let width = (view.frame.size.width - totalSpacing) / calculatedColumnCount
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: cellHeight)
        }
        
        collectionViewLayout()
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if comicBookCollection == nil {
            updateComicBookCollectionData()
        } else {
            navigationController?.isToolbarHidden = false
            collectionView.reloadData()
        }
    }
    
    func updateComicBookCollectionData() {
        
        if let savedCollection = readUserDefaults(for: defaultsKey) {
            self.comicBookCollection = savedCollection
        } else  if let sampleCollection = initFromBundle(forResource: "sample2", ofType: "json") {
            self.comicBookCollection = sampleCollection
        } else {
            print("no data in local phone stroage or in application bundle")
        }
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
        return comicBookCollection.selectedVolumeCollectedWorkIDs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return comicBookCollection.volumes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let imageName = comicBookCollection.volumes[indexPath.section].works[indexPath.item].coverImage
        let thumbName = "\(imageName)-thumb"
        cell.iconImage.image = UIImage(named: thumbName)
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isEditing {
            navigationController?.isToolbarHidden = false
        } else {
            performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? DetailViewController, let indexPath = sender as? IndexPath {

            comicBookCollection.selectedVolumeIndex = indexPath.section
            comicBookCollection.selectedVolume.selectedWorkIndex = indexPath.item
            
            dest.comicBookCollection = comicBookCollection
        }
    }
}
