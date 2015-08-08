//
//  ImportPhotoViewController.swift
//  Mugsie
//
//  Created by Show Wang on 5/10/15.
//  Copyright (c) 2015 Show Wang. All rights reserved.
//

import UIKit
import Parse

class ImportPhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var cameraImage: UIImage? // This is the optional image passed in from the camera
    var addMugFlag: Bool?
    var oneTimeMugFlag: Bool?
    
    let currentUser = PFUser.currentUser()!
    
    @IBOutlet weak var previewPhoto: UIImageView? // This is the preview photo image view
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView() // This is the activity indicator for when we're previewing the photo.
    
    // This is the user mug that gets passed in from the image picker controller.
    var passedUserMug: PFObject?
    // MARK: SAVE BUTTON
    
    @IBAction func saveButton(sender: AnyObject) {
        if previewPhoto != nil {
            if passedUserMug != nil {
                
                let customMug = passedUserMug!["customMug"] as! Bool
                passedUserMug!["imageFile"] = PFFile(name: "image.jpg", data: UIImageJPEGRepresentation(previewPhoto!.image, 0.01))
                
                if customMug == true {
                    // It's a custom mug so we need to save the text in emotionTextField specified by the user
                    passedUserMug!["emotionText"] = emotionTextField.text
                }
                
                passedUserMug!.saveInBackground()
                
                self.performSegueWithIdentifier("savedPhotoAsMugSegue", sender: sender)
                
            } else if oneTimeMugFlag == true{
                self.performSegueWithIdentifier("showSendFriendFromImportSegue", sender: sender)
            
            } else if addMugFlag == true {
                // DO SOMETHING IF WE'RE ADDING A NEW MUG. PROBABLY SAVE THE PFOBJECT
                // need to set "customMug" to true
                
                var newMug = PFObject(className: "UserMugs")
                newMug["createdBy"] = PFUser.currentUser()!
                newMug["emotionText"] = emotionTextField.text
                newMug["customMug"] = true
                newMug["imageFile"] = PFFile(name: "image.jpg", data: UIImageJPEGRepresentation(previewPhoto!.image, 0.01))
                newMug.saveInBackground()
                
                self.performSegueWithIdentifier("savedPhotoAsMugSegue", sender: sender)
            }
            
        }
        
    }
    
    @IBOutlet weak var emotionTextField: UITextField!
    
    @IBOutlet weak var emotionText: UILabel!
    
    
    @IBOutlet weak var emotionPreviewText: UILabel!
    
    
    @IBOutlet weak var emotionPreviewOKButton: UIButton!
   
    @IBAction func emotionPreviewOK(sender: AnyObject) {
        if currentUser["firstName"] != nil && currentUser["lastName"] != nil {
            let firstName = currentUser["firstName"] as! String
            let lastName = currentUser["lastName"] as! String
            emotionText.text = "\(firstName) \(lastName) is \(emotionTextField.text)"
        } else {
            emotionText.text = "For emotion: \(emotionTextField.text)"
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
            // Need to pass the selected mug to SendFriendViewController THROUGH the navigation controller
            // The code below accomplishes that and passes the image and emotion text for sending.
        if segue.identifier == "showSendFriendFromImportSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let detailController = navController.topViewController as! SendFriendViewController
            
            detailController.passedImage = PFFile(name: "image.jpg", data: UIImageJPEGRepresentation(previewPhoto!.image, 0.01))
            detailController.passedEmotionText = emotionTextField.text
            
            
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if addMugFlag == true {
            emotionPreviewText.hidden = false
            emotionTextField.hidden = false
            emotionPreviewOKButton.hidden = false
        } else if oneTimeMugFlag == true {
            emotionPreviewText.hidden = false
            emotionTextField.hidden = false
            emotionPreviewOKButton.hidden = false
        }
        
        if passedUserMug != nil {
            let customMug = passedUserMug!["customMug"] as! Bool
            if customMug == true {
                emotionPreviewText.hidden = false
                emotionTextField.hidden = false
                emotionPreviewOKButton.hidden = false
            }
            
        }
        
        // set preview photo to the photo taken from the camera off the bat if we're coming in from using the camera
        if cameraImage != nil {
            previewPhoto!.image = cameraImage!
        }
        
        // Do any additional setup after loading the view.
        if passedUserMug != nil {
            let passedEmotionText = passedUserMug!["emotionText"] as! String
            if currentUser["firstName"] != nil && currentUser["lastName"] != nil {
                let firstName = currentUser["firstName"] as! String
                let lastName = currentUser["lastName"] as! String
                emotionText.text = "\(firstName) \(lastName) is \(passedEmotionText)"
            }
            else {
                emotionText.text = "For emotion: \(passedEmotionText)"
            }
        } else {
            if currentUser["firstName"] != nil && currentUser["lastName"] != nil {
                let firstName = currentUser["firstName"] as! String
                let lastName = currentUser["lastName"] as! String
                emotionText.text = "\(firstName) \(lastName) is"
            }
            else {
                emotionText.text = "For emotion: "
            }
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func importPhoto(sender: AnyObject) {
        // create image instance of UIImagePickerController type
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
    
    }
    
    // The following function is run whenever the image is selected. Use this to display the image to the UIImageView instance, previewPhoto.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        // Uncomment to test if this function is working
        //** println("Image selected")
        
        // Dismiss the view controller in an animated way. Do nothing on completion.
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // Set the preview photo to the image selected, which has a local name image in the function
        previewPhoto!.image = image
    }
    


}
