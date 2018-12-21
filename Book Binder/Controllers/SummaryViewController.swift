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
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var addIssuePopoverView: AddIssuePopoverView!
    @IBOutlet var editSeriesPopoverView: EditSeriesPopoverView!
    
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
        
        editSeriesPopoverView.publisherTextField.text = ""
        editSeriesPopoverView.seriesTextField.text = ""
        editSeriesPopoverView.eraTextField.text = ""
        editSeriesPopoverView.coverImageView.image = UIImage(named: "american-standard-marvel-thumb")
        
        loadPopoverView(popoverView: editSeriesPopoverView, visualEffectView: visualEffectView, parentView: view)
    }
    
    @IBAction func snapItem(_ sender: Any) {
    }
    
    @IBAction func editSeriesAction(_ sender: Any) {
        let editButton = sender as! UIButton
        
        editSeriesPopoverView.publisherTextField.text = comicBookCollection.volumes[editButton.tag].publisherName
        editSeriesPopoverView.seriesTextField.text = comicBookCollection.volumes[editButton.tag].seriesName
        editSeriesPopoverView.eraTextField.text = "\(comicBookCollection.volumes[editButton.tag].era)"
        
        let coverImageName = comicBookCollection.volumes[editButton.tag].defaultCoverID
        editSeriesPopoverView.coverImageView.image = UIImage(named: "\(coverImageName)-thumb")

        loadPopoverView(popoverView: editSeriesPopoverView, visualEffectView: visualEffectView, parentView: view)
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
        
        configurePopoverView(popoverView: addIssuePopoverView, visualEffectView: visualEffectView)
        configurePopoverView(popoverView: editSeriesPopoverView, visualEffectView: visualEffectView)
        
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
            
            headerView.editButton.tag = indexPath.section
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
        return comicBookCollection.selectedVolumeCollectedWorkIDs.count + 1 // extra cell for addWorkButton
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return comicBookCollection.volumes.count
    }
    
    func isAddIssueCell(indexPath: IndexPath) -> Bool {
        comicBookCollection.selectedVolumeIndex = indexPath.section
        return indexPath.item == comicBookCollection.selectedVolumeCollectedWorkIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        if isAddIssueCell(indexPath: indexPath) {
            // Add Issue Cell
            
            // scale the icon image
            cell.iconImage.alpha = 1.0
            cell.iconImage.contentMode = .scaleAspectFit
            cell.iconImage.transform = CGAffineTransform(scaleX: 0.35, y: 0.35)
            
            // color the icon image
            let original =  UIImage(named: "Add-New-Issue")
            let tinted = original?.withRenderingMode(.alwaysTemplate)
            cell.iconImage.image = tinted
            cell.tintColor = UIColor(named: "UIBlueColor")
            

        } else {
            // Display cover Cell
            
            // scale the cover
            cell.iconImage.alpha = 1.0
            cell.iconImage.contentMode = .center
            cell.iconImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

            // assign the cover image
            let work = comicBookCollection.volumes[indexPath.section].works[indexPath.item]
            let thumbName = "\(work.coverImage)-thumb"
            cell.iconImage.image = UIImage(named: thumbName)
            
            // fade if not opwned
            if !work.isOwned {
                cell.iconImage.alpha = 0.3
            }
        }
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isAddIssueCell(indexPath: indexPath) {
            addWorkToSeries(seriesIndex: indexPath.section)
        } else {
            performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        }
    }
    
    func addWorkToSeries(seriesIndex: Int) {
        
        comicBookCollection.selectedVolumeIndex = seriesIndex
        comicBookCollection.selectedVolume.selectedWorkIndex = comicBookCollection.selectedVolume.works.count - 1
        addIssuePopoverView.comicBookCollection = comicBookCollection
        addIssuePopoverView.loadData()
        
        visualEffectView.isHidden = false
        
        loadPopoverView(popoverView: addIssuePopoverView, visualEffectView: visualEffectView, parentView: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? DetailViewController, let indexPath = sender as? IndexPath {

            comicBookCollection.selectedVolumeIndex = indexPath.section
            comicBookCollection.selectedVolume.selectedWorkIndex = indexPath.item
            
            dest.comicBookCollection = comicBookCollection
        }
    }
}

extension SummaryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
