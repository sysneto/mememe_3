//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Kadar Toth Istvan on 19/05/15.
//  Copyright (c) 2015 Kadar Toth Istvan. All rights reserved.
//

import UIKit
 // full screen view of Meme
class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memeImage
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEditor" {
            let destination = segue.destinationViewController as! EditViewController
            destination.editMeme = meme
        }
    }
}
