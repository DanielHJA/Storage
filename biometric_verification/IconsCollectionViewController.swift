//
//  IconsCollectionViewController.swift
//  biometric_verification
//
//  Created by Daniel Hjärtström on 2016-10-20.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.

protocol SelectedIconProtocol: class {
    func didSelectIcon(icon: Data)
}

import UIKit

class IconsCollectionViewController: UICollectionViewController {

    var iconsArray:[[Data]] = []
    var sectionNames:[String] = []
    let activityIndicator: ActivityIndicator = ActivityIndicator()
    weak var delegate: SelectedIconProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flow = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionHeadersPinToVisibleBounds = true // Make header go with scroll
        
        DispatchQueue.global().async {
            
        self.activityIndicator.displayActivityIndicator(viewController: self)
            
        ImageAssetManager.loadFileURLSFromFolderInBundle(parentFolder: "/images/") { (data, sections, status) in
            
            guard status == .success else {
            
                AlertManager.alertWithAction(title: "There was an error", msg: "No images were found.", viewController: self, hasCancelOption: false, completion: { (action) in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
                return
            }
            
            self.iconsArray = data!
            self.sectionNames = sections!
          
            DispatchQueue.main.async {
            
                self.activityIndicator.indicator?.stopAnimating()
                self.activityIndicator.indicator?.removeFromSuperview()
                self.collectionView?.reloadData()
            
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return iconsArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconsArray[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IconsCollectionViewCell
    
        let section = iconsArray[indexPath.section]
        
        cell.iconImage.image = UIImage(data: section[indexPath.row])
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let image = iconsArray[indexPath.section][indexPath.row]
        self.delegate?.didSelectIcon(icon: image)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var header: CollectionReusableViewHeader? = nil
        
        if kind == UICollectionElementKindSectionHeader {
        
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as? CollectionReusableViewHeader
            header?.title.font = UIFont(name: "Avenir", size: 20)!
            header?.title.text = sectionNames[indexPath.section]
            
        }
        return header!
    }
}
