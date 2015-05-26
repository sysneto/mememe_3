//
//  Meme.swift
//  MemeMe
//
//  Created by Kadar Toth Istvan on 19/05/15.
//  Copyright (c) 2015 Kadar Toth Istvan. All rights reserved.
//

import UIKit
// The meme object with all properties and functions
class Meme {
    // TOP Text
    var top: String!
    // text for bottom of the Meme
    var bottom: String!
    // background image for the Meme
    var image: UIImage!
    // text and image composed for sharing
    var memeImage: UIImage!
    
     //setting member variables using constructor function
       init(top: String, bottom: String, image: UIImage, memeImage: UIImage) {
        self.top = top
        self.bottom = bottom
        self.image = image
        self.memeImage = memeImage
    }
    //save function for meme image
     func save() {
        Meme.getStorage().memes.append(self)
    }
    // get the memes
    class func getStorage() -> AppDelegate {
        let object = UIApplication.sharedApplication().delegate
        return object as! AppDelegate
    }
    // return all memes
    class func findAll() -> [Meme] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return Meme.getStorage().memes
    }
    // Image counter in table
    class func countAll() -> Int {
        return Meme.getStorage().memes.count
    }
    // get meme from index
      class func getAtIndex(index: Int) -> Meme? {
        if Meme.getStorage().memes.count > index {
            return Meme.getStorage().memes[index]
        }
        return nil
    }
    // remove meme from index
     class func removeAtIndex(index: Int) {
        if index >= 0 && Meme.getStorage().memes.count > index {
            Meme.getStorage().memes.removeAtIndex(index)
        }
    }
}
