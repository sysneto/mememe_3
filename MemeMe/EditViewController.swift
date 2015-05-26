//
//  EditorViewController.swift
//  MemeMe
//
//  Created by Kadar Toth Istvan on 19/05/15.
//  Copyright (c) 2015 Kadar Toth Istvan. All rights reserved.
//

import UIKit

// Edit View
class EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    // store the typed text
    var currentTextField: UITextField?
    
    var editMeme: Meme?
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Font set for meme text
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Arial", size: 40)!,
            NSStrokeWidthAttributeName: -3
        ]
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
        
        topText.delegate = self
        bottomText.delegate = self
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // if existing meme was set during segue to this controller
        if let meme = editMeme {
            topText.text = meme.top
            bottomText.text = meme.bottom
            memeImageView.image = meme.image
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    // when start Edit meme texts
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == topText && textField.text! == "TOP" {
            textField.text = ""
        }
        if textField == bottomText && textField.text! == "BOTTOM" {
            textField.text = ""
        }
        currentTextField = textField
    }
    // when finish editing set back the buffers
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == topText && textField.text! == "" {
            textField.text = "TOP"
        }
        if textField == bottomText && textField.text! == "" {
            textField.text = "BOTTOM"
        }
        currentTextField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let textField = currentTextField {
            if textField == bottomText {
                self.view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    // when click on Share icon to Save or any other action
    @IBAction func didPressActivity(sender: UIBarButtonItem) {
        let image = makeMemeImage()
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activity.completionWithItemsHandler = { (type: String!, completed: Bool, returnedItems: [AnyObject]!, error: NSError!) in
            if completed {
                var backgroundImage = self.memeImageView.image == nil ? UIImage() : self.memeImageView.image
                var meme = Meme(
                    top: self.topText.text,
                    bottom: self.bottomText.text,
                    image: backgroundImage!,
                    memeImage: image
                )
                // Save the meme image
                meme.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activity, animated: true, completion: nil)
    }
    
    // compose image
    private func makeMemeImage() -> UIImage {
        
        hideToolbars()
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        showToolbars()
        
        return image
    }
    
    private func hideToolbars() {
        navBar.hidden = true
        bottomToolbar.hidden = true
    }
    
    private func showToolbars() {
        navBar.hidden = false
        bottomToolbar.hidden = false
    }
    
    @IBAction func CancelClick(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// brings up the camera roll
    @IBAction func AlbumClick(sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    /// shows the camera via the UIImage picker
    @IBAction func CameraClick(sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}