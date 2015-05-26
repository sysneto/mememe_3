//
//  TableViewController.swift
//  MemeMe
//
//  Created by Kadar Toth Istvan on 19/05/15.
//  Copyright (c) 2015 Kadar Toth Istvan. All rights reserved.
//


import UIKit

class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedIndex: Int!
    
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // display button if there aren't any memes after deletion
        navigationItem.leftBarButtonItem?.enabled = Meme.countAll() > 0
        tableView.reloadData()
    }
    //For deleting the Meme
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            Meme.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        default:
            return
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Meme.countAll()
    }
    //Setup the display of the cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("memeTableCell") as! MemeTableCell
        if let meme = Meme.getAtIndex(indexPath.row) {
            cell.memeImageView.image = meme.memeImage
            cell.memeLabel.text = "\(meme.top) \(meme.bottom)"
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !tableView.editing {
            selectedIndex = indexPath.row
            performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    
    @IBAction func AddClick(sender: AnyObject) {
        performSegueWithIdentifier("showEditor", sender: self)
    }
    // segue for detail view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            var destination = segue.destinationViewController as! DetailViewController
            if let meme = Meme.getAtIndex(selectedIndex!) {
                destination.meme = meme
            }
        }
    }
}
