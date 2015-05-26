//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Kadar Toth Istvan on 19/05/15.
//  Copyright (c) 2015 Kadar Toth Istvan. All rights reserved.
//

import Foundation
import UIKit
// Collection view
class CollectionViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // show editor if there are aren't any memes
        if Meme.countAll() == 0 {
            performSegueWithIdentifier("showEditor", sender: self)
        }
        collectionView!.reloadData()
        // display button if there aren't any memes after deletion
        navigationItem.leftBarButtonItem?.enabled = Meme.countAll() > 0
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        if let meme = Meme.getAtIndex(indexPath.row) {
            cell.memeImageView.image = meme.memeImage
        }
        cell.deleteButton.hidden = !editing
        cell.deleteButton.addTarget(self, action: "DeleteClicked:", forControlEvents: .TouchUpInside)
        return cell
    }
    
    @IBAction func DeleteClicked(sender: UIButton) {
        // from button to cell
        let cell = sender.superview!.superview! as! MemeCollectionViewCell
        let index = collectionView!.indexPathForCell(cell)!
        Meme.removeAtIndex(index.row)
        collectionView!.deleteItemsAtIndexPaths([index]);
        setEditing(false, animated: true)
        navigationItem.leftBarButtonItem?.enabled = Meme.countAll() > 0
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Meme.countAll()
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        if !editing {
            performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    // when + clicked goto editor
    @IBAction func AddClicked(sender: AnyObject) {
        performSegueWithIdentifier("showEditor", sender: self)
    }
    // segue the meme to detail view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            var destination = segue.destinationViewController as! DetailViewController
            if let meme = Meme.getAtIndex(selectedIndex!) {
                destination.meme = meme
            }
        }
    }
}
