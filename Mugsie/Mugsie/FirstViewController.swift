//
//  FirstViewController.swift
//  Mugsie
//
//  Created by Show Wang on 5/6/15.
//  Copyright (c) 2015 Show Wang. All rights reserved.
//

import UIKit
import Parse

class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // initialize a image from the camera picker
    var cameraImage: UIImage = UIImage()
    
    // not sure why i used a flag variable here, i think i just used it so we can see if they hit the useCamera button, but I'm pretty sure we can just use a sender parameter or something like that in the future
    var useCamera: Bool = false
    
    // galleryItems is the array containing all the GalleryItem stuff that is imported from the items.plist. In the future we will change our data model, this may not be around.
    var galleryItems: [GalleryItem] = []
    
    var passedUserMug: PFObject?
    
    // MARK: -
    // MARK: - View Lifecycle
    
    var userMugsArray = [PFObject]()
    
    var oneTimeMugFlag: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // deprecated, not using plist loading anymore
        // initialize galleryItems
        // initGalleryItems()
        
        // download user mugs from parse and populate array of PFObjects, userMugsArray
        
        // downloadUserMugs()
        // populate the collection view with the gallery items
        // collectionView.reloadData()
        
        // the following code puts in a long press gesture recognizer on the collection view
        var longPress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self
        longPress.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPress)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        downloadUserMugs()
    }
    
    // Add mug button in the header cell
    func addMug() -> Void {
        let addOptions = UIAlertController(title: nil, message: "Add New Mug", preferredStyle: .ActionSheet)
        addOptions.addAction(UIAlertAction(title: "Take new Mug", style: .Default, handler: { (alertAction) -> Void in
            // Segue to take new mug view controller
            
            self.useCamera = true
            var image = UIImagePickerController()
            // set delegate of the UIImagePickerController image instance to self
            image.delegate = self
            // set image instance source type to the Photolibrary
            // to use the camera as the image source instead, uncomment the following line:
            //** image.sourceType = UIImagePickerControllerSourceType.Camera
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            // do we want to allow the user to edit the image before it gets saved?
            image.allowsEditing = true // will probably need to change in future
            self.presentViewController(image, animated: true, completion: nil)
            
            
        }))
        addOptions.addAction(UIAlertAction(title: "Import Photo", style: .Default, handler: { (alertAction) -> Void in
            // Will probably need to pass in logic here to preserve the mug for replacing
            // Segues to the import photo segue
            self.useCamera = false
            self.performSegueWithIdentifier("importPhotoSegue", sender: alertAction)
        }))
        
        addOptions.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(addOptions, animated: true, completion: nil)
        
    }
    
    // One time Mug button in the header cell
    func oneTime() -> Void {
        
        let oneTimeOptions = UIAlertController(title: nil, message: "Send One-Time Mug", preferredStyle: .ActionSheet)
        oneTimeOptions.addAction(UIAlertAction(title: "Use Camera", style: .Default, handler: { (alertAction) -> Void in
            // Segue to take new mug view controller
            
            self.useCamera = true
            var image = UIImagePickerController()
            // set delegate of the UIImagePickerController image instance to self
            image.delegate = self
            // set image instance source type to the Photolibrary
            // to use the camera as the image source instead, uncomment the following line:
            //** image.sourceType = UIImagePickerControllerSourceType.Camera
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            // do we want to allow the user to edit the image before it gets saved?
            image.allowsEditing = true // will probably need to change in future
            self.oneTimeMugFlag = true
            self.presentViewController(image, animated: true, completion: nil)
            
        }))
        oneTimeOptions.addAction(UIAlertAction(title: "Import Photo", style: .Default, handler: { (alertAction) -> Void in
            // Will probably need to pass in logic here to preserve the mug for replacing
            // Segues to the import photo segue
            self.useCamera = false
            self.oneTimeMugFlag = true
            self.performSegueWithIdentifier("importPhotoSegue", sender: alertAction)
        }))
        oneTimeOptions.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(oneTimeOptions, animated: true, completion: nil)
    }
    
    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        
        /*
        let longPress = gestureRecognizer as UILongPressGestureRecognizer
        let state = longPress.state
        var locationInView = longPress.locationInView(collectionView)
        var indexPath = collectionView.indexPathForItemAtPoint(locationInView)
        */
        
        // The following if-block prevents the long press gesture recognizer from conflicting with the didSelectCell / short-tap recognizer
        if (gestureRecognizer.state != UIGestureRecognizerState.Ended){
            return
        }
        
        // figures out where in the view they put in a long press
        let p: CGPoint = gestureRecognizer.locationInView(self.collectionView)
        
        
        if let indexPath = self.collectionView.indexPathForItemAtPoint(p)
        {
            // translates the point in the collection view to figure out which cell it is
            let cell: UICollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath)!
            println("you did a long press on cell: \(indexPath)")
            
            // In order to figure out which mug to replace, we are going to have to figure out what mug corresponds to the cell.
            // We will probably need to use something like mugDataModel[indexPath.row] as the logic for the mug and pass it off to a view controller down the line...
            
            // Create an alert controller, with style action sheet. Action sheet means it's a full fledged menu as opposed to an alert pop up
            let importOptions = UIAlertController(title: nil, message: "Replace Mug", preferredStyle: .ActionSheet)
            
            // Add in the option to take a new mug using the camera. We style this with .Default and not .Destructive (which just makes the text red)
            importOptions.addAction(UIAlertAction(title: "Take new Mug", style: .Default, handler: { (alertAction) -> Void in
                // Segue to take new mug view controller
                
                self.useCamera = true
                var image = UIImagePickerController()
                // set delegate of the UIImagePickerController image instance to self
                image.delegate = self
                // set image instance source type to the Photolibrary
                // to use the camera as the image source instead, uncomment the following line:
                //** image.sourceType = UIImagePickerControllerSourceType.Camera
                image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                // do we want to allow the user to edit the image before it gets saved?
                image.allowsEditing = true // will probably need to change in future
                self.passedUserMug = self.userMugsArray[indexPath.row]
                self.presentViewController(image, animated: true, completion: nil)
                
                
            }))
            importOptions.addAction(UIAlertAction(title: "Import Photo", style: .Default, handler: { (alertAction) -> Void in
                // Will probably need to pass in logic here to preserve the mug for replacing
                // Segues to the import photo segue
                self.useCamera = false
                self.passedUserMug = self.userMugsArray[indexPath.row]
                self.performSegueWithIdentifier("importPhotoSegue", sender: alertAction)
            }))
            
            let userMug = self.userMugsArray[indexPath.row]
            let customMugFlag = userMug["customMug"] as! Bool
            if customMugFlag == true {
                importOptions.addAction(UIAlertAction(title: "Delete Mug", style: .Destructive, handler: {
                    (alertAction) -> Void in
                    
                    userMug.unpinInBackground()
                    userMug.deleteInBackground()
                    self.userMugsArray.removeAtIndex(indexPath.row)
                    // self.collectionView.deleteItemsAtIndexPaths([indexPath])
                    self.collectionView.reloadData()
                    // THIS DOESN'T FULLY WORK YET, NEED TO BE ABLE TO DELETE THE CELL ON SCREEN
                }))
            }
            
            importOptions.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            presentViewController(importOptions, animated: true, completion: nil)
        }
        else
        {
            println("couldn't find index path")
        }
    }
    
    
    // The following function is run whenever the image is selected. Use this to display the image to the UIImageView instance, previewPhoto.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        // Uncomment to test if this function is working
        //** println("Image selected")
        // Dismiss the view controller in an animated way. Do nothing on completion.
        cameraImage = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.performSegueWithIdentifier("importPhotoSegue", sender: picker)
        
        
    }
    
    // Configure the segue for importing photo
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        /*
        if segue.identifier == "importPhotoSegue" {
            
            // Do some stuff to allow transition of data across the segue
            /* e.g.
            let playlistImageView = sender!.view as! UIImageView
            if let index = find(playlistsArray, playlistImageView){
            
            let playlistDetailController = segue.destinationViewController as! PlaylistDetailViewController
            playlistDetailController.playlist = Playlist(index: index)
            }
            */
            
        } */
        
        // Segue for using the camera
        if (segue.identifier == "importPhotoSegue" && useCamera == true){
            let importPhotoViewController = segue.destinationViewController as! ImportPhotoViewController
            importPhotoViewController.cameraImage = cameraImage
            if passedUserMug != nil {
                importPhotoViewController.passedUserMug = passedUserMug
            } else if oneTimeMugFlag == true {
                importPhotoViewController.oneTimeMugFlag = oneTimeMugFlag
            } else {
                importPhotoViewController.addMugFlag = true
            }
        }
        else if (segue.identifier == "importPhotoSegue" && useCamera == false){
            let importPhotoViewController = segue.destinationViewController as! ImportPhotoViewController
            
            if passedUserMug != nil {
                importPhotoViewController.passedUserMug = passedUserMug
            } else if oneTimeMugFlag == true {
                importPhotoViewController.oneTimeMugFlag = oneTimeMugFlag
            } else {
                importPhotoViewController.addMugFlag = true
            }
            
            
            
        }
        // Need to pass the selected mug to SendFriendViewController THROUGH the navigation controller
        // The code below accomplishes that and passes the image and emotion text for sending.
        else if segue.identifier == "showSendFriendSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let detailController = navController.topViewController as! SendFriendViewController
            // detailController.passedImage = sender as! UIImage
            
            let row = sender as! Int
            let userMug = userMugsArray[row] as PFObject
            detailController.passedImage = userMug["imageFile"] as! PFFile
        
            detailController.passedEmotionText = (userMug["emotionText"] as? String)!
            
            // detailController.passedMug = userMug
            
            
        }
        
        
    }
    
    // Initializes the gallery Items. We will probably need to change this code for the data model.
    
    // DEPRECATED FOR NOW
    private func initGalleryItems() {
        
        var items = [GalleryItem]()
        let inputFile = NSBundle.mainBundle().pathForResource("items", ofType: "plist")
        
        let inputDataArray = NSArray(contentsOfFile: inputFile!)
        
        for inputItem in inputDataArray as! [Dictionary<String, String>] {
            let galleryItem = GalleryItem(dataDictionary: inputItem)
            items.append(galleryItem)
        }
        
        galleryItems = items
    }
    
    
    func downloadUserMugs() {
        println("downloading user mugs")
        var userMugs = PFQuery(className: "UserMugs")
        userMugs.whereKey("createdBy", equalTo: PFUser.currentUser()!)
        userMugs.findObjectsInBackgroundWithBlock { (objects, error) in
            if error != nil {
                println(error)
            }
            else {
                println(objects)
                for object in objects as! [PFObject] {
                    object.pinInBackground()
                }
                self.userMugsArray = objects as! [PFObject]
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView.reloadData()
                })

            }
        }

        
    }
    
    
    
    
    
    // MARK: -
    // MARK: - UICollectionViewDataSource
    
    // NOTE: THIS BLOCK IS FOR LOADING FROM THE PLIST. DEPRECATED
    /*
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryItems.count
    }
    */
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userMugsArray.count
    }
    
    // NOTE: THIS BLOCK IS FOR LOADING FROM THE PLIST. DEPRECATED
    /*
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryItemCollectionViewCell", forIndexPath: indexPath) as! GalleryItemCollectionViewCell
        
        cell.setGalleryItem(galleryItems[indexPath.row])
        cell.setGalleryText(galleryItems[indexPath.row])
        return cell
        
    }
    */
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryItemCollectionViewCell", forIndexPath: indexPath) as! GalleryItemCollectionViewCell
        
        let userMug = userMugsArray[indexPath.row] as PFObject
        println("cell userMug is \(userMug)")
        
        
        if let emotionLabel = userMug["emotionText"] as? String {
            println("emotion label is \(emotionLabel)")
            cell.setGalleryText(emotionLabel)
        }
        
        if let thumbnail = userMug["imageFile"] as? PFFile {
            println(thumbnail)
            // IN FUTURE, RESIZE IMAGE HERE BEFORE DISPLAYING
            cell.itemImageView.file = thumbnail
            cell.itemImageView.loadInBackground()
            
        }
        
        
        //cell.setGalleryItem(userMugsArray[indexPath.row])
        //cell.setGalleryText(userMugsArray[indexPath.row])
        return cell
        
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let commentView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "GalleryItemCommentView", forIndexPath: indexPath) as! GalleryItemCommentView
        
        // This sets the header text
        //commentView.commentLabel.text = "Supplementary view of kind \(kind)"
        
        // commentView.commentLabel.text = "Tap to send, hold to change."
        
        
        // The following code is a weird, hackerish way of getting buttons drawn in IB into the header cell and attaching actions to them.
        var addMugButton = self.view.viewWithTag(4) as? UIButton
        var oneTimeButton = self.view.viewWithTag(5) as? UIButton
        println(addMugButton)
        println(oneTimeButton)
        var addMugButtonTest = UIButton()
        var oneTimeButtonTest = UIButton()
        
        // Unwrap the optionals
        if addMugButton != nil {
            addMugButtonTest = addMugButton!
        }
        if oneTimeButton != nil {
            oneTimeButtonTest = oneTimeButton!
        }
        
        // Add actions to the buttons
        addMugButtonTest.addTarget(self, action: "addMug", forControlEvents: UIControlEvents.TouchUpInside)
        oneTimeButtonTest.addTarget(self, action: "oneTime", forControlEvents: UIControlEvents.TouchUpInside)
        
        return commentView
    }
    
    
    // MARK: -
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        /*
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
        alert.addAction(alertAction)
        
        self.presentViewController(alert, animated: true, completion: nil) */
        
        // Instead of alert action here, let's segue to the send friend view controller
        
        /* Can't use this code, we need a segue since we're looking to pass info THROUGH a navigation controller
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("sendFriendNavigationController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        */
        
        // What we want to do is call the "showSendFriendSegue" segue identifier while passing in the mug UIImage as the sender
        
        
        // need to combine passedImage
        
        // prevents crashing when clicking on a default mug with no image
        let userMug = userMugsArray[indexPath.row] as PFObject
        if userMug["imageFile"] != nil {
            self.performSegueWithIdentifier("showSendFriendSegue", sender: indexPath.row)
        }
        
        // self.performSegueWithIdentifier("showSendFriendSegue", sender: passedImage)
        
    }
    
    // MARK: -
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width / 3.0 //3.0
        return CGSizeMake(picDimension, picDimension)
    }
    
    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        /*
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
        */
        let frame: CGRect = self.view.frame
        //let margin  = (frame.width - 90 * 3) / 6.0
        let margin = frame.width / 20.0
        return UIEdgeInsetsMake(10, margin, 10, margin) // margin between cells
    }
    */

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return CGFloat(0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return CGFloat(0)
    }

}

