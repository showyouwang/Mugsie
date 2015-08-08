//
//  GalleryItemCollectionViewCell.swift
//  Mugsie
//
//  Created by Show Wang on 5/14/15.
//  Copyright (c) 2015 Show Wang. All rights reserved.
//

import UIKit

class GalleryItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: PFImageView!
    
    @IBOutlet weak var itemEmotionLabel: UILabel!

    /*
    func setGalleryItem(item:GalleryItem) {
        itemImageView.image = UIImage(named: item.itemImage)
    }
    
    // Create a function to set the emotion text in a cell
    func setGalleryText(item:GalleryItem) {
        itemEmotionLabel.text = "Happy"
    }
    */
    
    func setGalleryItem(item: UIImage) {
        itemImageView.image = item
    }
    
    func setGalleryText(text: String) {
        itemEmotionLabel.text = text
    }
    
}
