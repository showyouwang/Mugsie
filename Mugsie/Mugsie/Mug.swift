//
//  Mug.swift
//  Mugsie
//
//  Created by Show Wang on 6/6/15.
//  Copyright (c) 2015 Show Wang. All rights reserved.
//

import Foundation
import Parse

class Mug {
    var imageFile: PFFile?
    var emotionText = ""
    var customMug = false
    
    
    init(emotionText: String, customMug: Bool){
        self.emotionText = emotionText
        self.customMug = customMug
    }
    
    init(imageFile: PFFile, emotionText: String, customMug: Bool) {
        self.imageFile = imageFile
        self.emotionText = emotionText
        self.customMug = customMug
    }
    
    /*
    class func newDefaultMug(image: UIImage, emotionText: String) -> Mug {
        return Mug(image: image, emotionText: emotionText, customMug: false)
    }
    */
   
    class func newCustomMug(imageFile: PFFile, emotionText: String) -> Mug {
        return Mug(imageFile: imageFile, emotionText: emotionText, customMug: true)
    }
    
    
    init(dataDictionary:Dictionary<String,String>) {
        emotionText = dataDictionary["itemEmotion"]!
    }
    
    class func newDefaultMug(dataDictionary:Dictionary<String,String>) -> Mug {
        return Mug(dataDictionary: dataDictionary)
    }
    
    
}