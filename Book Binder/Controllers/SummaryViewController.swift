//
//  SummaryViewController.swift
//  Book Binder
//
//  Created by John Pavley on 9/16/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- Outlets -
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var addIssuePopoverView: AddIssuePopoverView!
    @IBOutlet var editSeriesPopoverView: EditSeriesPopoverView!
    @IBOutlet weak var noSeriesCollectedLabel: UILabel!
    
    // MARK:- Constants -
    
    let columnCount = CGFloat(5)
    let collectionViewMinSpacing = CGFloat(0)
    let cellHeight = CGFloat(126)
    let cellWidth = CGFloat(80)
    
    // MARK:- Properties -
    
    var comicBookCollection: JsonModel!
    
    // MARK:- Action helpers
    
    func enableToolbarButtons(toggle: Bool) {
        addButton.isEnabled = toggle
        cameraButton.isEnabled = toggle
    }
    
    func getCoverImageName(for section: Int) -> String {
        if comicBookCollection.volumes[section].works.count > 0 {
            return comicBookCollection.volumes[section].works.first!.coverImage
        } else {
            return comicBookCollection.volumes[section].defaultCoverID
        }
    }
    
    // MARK:- Actions -
    
    @IBAction func addVolume() {
        
        // configure view UX while popover is popped
        
        enableToolbarButtons(toggle: false)
        
        // configure popover UX before it appears
        
        editSeriesPopoverView.publisherTextField.text = ""
        editSeriesPopoverView.seriesTextField.text = ""
        editSeriesPopoverView.eraTextField.text = ""
        editSeriesPopoverView.coverImageView.image = UIImage(named: "american-standard-marvel-thumb")
        editSeriesPopoverView.deleteButton.isHidden = true
        
        // congigure save, delete, and cancel functions
        
        editSeriesPopoverView.saveFunction = {
            let publisherName = self.editSeriesPopoverView.publisherTextField.text!
            let seriesName = self.editSeriesPopoverView.seriesTextField.text!
            let era = Int(self.editSeriesPopoverView.eraTextField.text!) ?? 0
            let volumeNumber = 1
            let kind = "comic book"
            let works = [JsonModel.JsonVolume.JsonWork]()
            let defaultCoverID = "american-standard-marvel"
            let selectedWorkIndex = 0
            
            let newVolume = JsonModel.JsonVolume(
                publisherName: publisherName,
                seriesName: seriesName,
                era: era,
                volumeNumber: volumeNumber,
                kind: kind,
                works: works,
                defaultCoverID: defaultCoverID,
                selectedWorkIndex: selectedWorkIndex
            )
            
            self.comicBookCollection.addVolume(newVolume)
            saveUserDefaults(for: defaultsKey, with: self.comicBookCollection)
            self.collectionView.reloadData()
            self.enableToolbarButtons(toggle: true)
        }
        
        editSeriesPopoverView.cancelFunction = {
            self.enableToolbarButtons(toggle: true)
        }
        
        // everything is ready! pop the popup!
        
        loadPopoverView(popoverView: editSeriesPopoverView, visualEffectView: visualEffectView, parentView: view)
    }
    
    @IBAction func snapItem(_ sender: Any) {
    }
    
    @IBAction func editSeriesAction(_ sender: Any) {
        
        // configure view UX while popup is popped
        
        enableToolbarButtons(toggle: false)
        
        // configure popup UX
        
        let editButton = sender as! UIButton
        
        comicBookCollection.selectedVolumeIndex = editButton.tag
        editSeriesPopoverView.publisherTextField.text = comicBookCollection.volumes[editButton.tag].publisherName
        editSeriesPopoverView.seriesTextField.text = comicBookCollection.volumes[editButton.tag].seriesName
        editSeriesPopoverView.eraTextField.text = "\(comicBookCollection.volumes[editButton.tag].era)"
        editSeriesPopoverView.deleteButton.isHidden = false
        
        let coverImageName = getCoverImageName(for: editButton.tag)
        editSeriesPopoverView.coverImageView.image = UIImage(named: "\(coverImageName)-thumb")
        
        // congigure save, delete, and cancel functions
        
        editSeriesPopoverView.saveFunction = {
            self.comicBookCollection.selectedVolume!.publisherName = self.editSeriesPopoverView.publisherTextField.text!
            self.comicBookCollection.selectedVolume!.seriesName = self.editSeriesPopoverView.seriesTextField.text!
            self.comicBookCollection.selectedVolume!.era = Int(self.editSeriesPopoverView.eraTextField.text!) ?? 0
            // TODO: Update the coverImageView somehow

            saveUserDefaults(for: defaultsKey, with: self.comicBookCollection)
            self.collectionView.reloadData()
            self.enableToolbarButtons(toggle: true)
        }
        
        editSeriesPopoverView.deleteFunction = {
            self.comicBookCollection.removeSelectedVolume()
            saveUserDefaults(for: defaultsKey, with: self.comicBookCollection)
            self.collectionView.reloadData()
            self.enableToolbarButtons(toggle: true)
        }
        
        editSeriesPopoverView.cancelFunction = {
            self.enableToolbarButtons(toggle: true)
        }
        
        // everything is ready! pop the popover!
        
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
        noSeriesCollectedLabel.isHidden = true
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
        
        if comicBookCollection.selectedVolume == nil {
            assert(false, "BOOKBINDERAPP: selectedVolume is nil")
        }
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! CollectionReusableView
            
            comicBookCollection.selectedVolumeIndex = indexPath.section
            
            let title = comicBookCollection.selectedVolume?.seriesName ?? ""
            let era = comicBookCollection.selectedVolume?.era ?? 0
            let publisher = comicBookCollection.selectedVolume?.publisherName
            
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
    
    // MARK:-
    
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
            cell.iconImage.contentMode = .top
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
    
    // MARK: -
    
    func addWorkToSeries(seriesIndex: Int) {
        
        if let selectedVolume = comicBookCollection.selectedVolume {
            
            // configure view UX while popup is popped
            
            enableToolbarButtons(toggle: false)
            
            // configure popup UX
            
            comicBookCollection.selectedVolumeIndex = seriesIndex
            selectedVolume.selectedWorkIndex = selectedVolume.works.count - 1
            addIssuePopoverView.comicBookCollection = comicBookCollection
            
            addIssuePopoverView.publisherNameLabel.text = "\(selectedVolume.publisherName)"
            addIssuePopoverView.seriesTitleLabel.text = selectedVolume.seriesName
            addIssuePopoverView.coverImage.image = UIImage(named: "\(selectedVolume.defaultCoverID)-thumb")
            addIssuePopoverView.issueNumberField.text = ""
            
            if let selectedVolumeSelectedWork = comicBookCollection.selectedVolumeSelectedWork {
                addIssuePopoverView.issueNumberField.placeholder = "\(selectedVolumeSelectedWork.issueNumber + 1)"
            } else {
                addIssuePopoverView.issueNumberField.placeholder = ""
            }
            
            addIssuePopoverView.variantLetterField.text = ""

            
            // congigure save, delete, and cancel functions
            
            addIssuePopoverView.saveFunction = {
                self.enableToolbarButtons(toggle: true)
                
                if self.addIssuePopoverView.issueNumberField.text == "" {
                    // Dont create and save a work if the user doens't give us an issue number
                    return
                }
                
                let issueNumber = Int(self.addIssuePopoverView.issueNumberField.text!) ?? 0
                let variantLetter = self.addIssuePopoverView.variantLetterField.text!
                let coverImage = selectedVolume.defaultCoverID
                let isOwned = true
                
                let work = JsonModel.JsonVolume.JsonWork(
                    issueNumber: issueNumber,
                    variantLetter: variantLetter,
                    coverImage: coverImage,
                    isOwned: isOwned
                )
                
                self.comicBookCollection.addWorkToSelectedVolume(work)
                saveUserDefaults(for: defaultsKey, with: self.comicBookCollection)
                self.collectionView.reloadData()
            }
            
            addIssuePopoverView.cancelFunction = {
                self.enableToolbarButtons(toggle: true)
            }
            
            // everything is ready! pop the popup!
            
            loadPopoverView(popoverView: addIssuePopoverView, visualEffectView: visualEffectView, parentView: view)
            
        } else {
            assert(false, "BOOKBINDERAPP: selectedVolume is nil")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedVolume = comicBookCollection.selectedVolume else {
            assert(false, "BOOKBINDERAPP: selectedVolume is nil")
        }
        
        if let dest = segue.destination as? DetailViewController, let indexPath = sender as? IndexPath {
            
            comicBookCollection.selectedVolumeIndex = indexPath.section
            selectedVolume.selectedWorkIndex = indexPath.item
            
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
