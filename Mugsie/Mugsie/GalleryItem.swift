//
//  GalleryItem.swift
//  Mugsie
//
//  Created by Show Wang on 5/14/15.
//  Copyright (c) 2015 Show Wang. All rights reserved.
//


import Foundation

class GalleryItem {
    
    var itemImage:String
    
    init(dataDictionary:Dictionary<String,String>) {
        itemImage = dataDictionary["itemImage"]!
    }
    
    class func newGalleryItem(dataDictionary:Dictionary<String,String>) -> GalleryItem {
        return GalleryItem(dataDictionary: dataDictionary)
    }
    
}
