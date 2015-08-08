//
//  SecondViewCell.swift
//  Mugsie
//
//  Created by Show Wang on 6/7/15.
//  Copyright (c) 2015 Show Wang. All rights reserved.
//

import UIKit
import Parse

class SecondViewCell: PFTableViewCell {
    
    
    @IBOutlet weak var feedItemThumbnail: PFImageView!
    
    @IBOutlet weak var feedItemLabel: UILabel!
    
    @IBOutlet weak var feedItemTime: UILabel!
    
    
    func setThumbnail(thumbnail: UIImage) {
        feedItemThumbnail.image = thumbnail
    }
    
    func setLabel(label: String) {
        feedItemLabel.text = label
    }

}
