//
//  SendFriendViewController.swift
//  Mugsie
//
//  Created by Show Wang on 5/19/15.
//  Copyright (c) 2015 Show Wang. All rights reserved.
//

import UIKit
import Parse

class SendFriendViewController: PFQueryTableViewController {
    
    var searchText = ""
    var selectFriendMode = false
    var passedImage = PFFile()
    var passedEmotionText = ""
    
    
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        self.parseClassName = className
    }
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
        self.parseClassName = "_User"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fixes annoying UI bug
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        println("MODE: \(selectFriendMode)")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // get the object
        var selectedObject = self.objectAtIndexPath(indexPath)!
        if selectedObject is PFUser {
            // probably *should* have a confirmation box...
           //send image to pfuser
            
            println("image sent to \(selectedObject)")
            println(passedImage.description)
            
            
            
            
            
            /*

            var sendImage = PFObject(className: "SendImage")

            
            // drop down the quality
            // the following code doesnt work unless the filesize is small because Parse has a 128kb filesize limitation on PFObjects
            // sendImage["image"] = UIImageJPEGRepresentation(passedImage, 0.01)
            
            sendImage["photo"] = PFFile(name: "image.jpg", data: UIImageJPEGRepresentation(passedImage, 0.01))
            sendImage["emotionText"] = passedEmotionText
            // TO ADD: sendImage["thumbnail"] = PFFile(name: "thumbnail.jpg, data: UIImageJPEGRepresentation(passedImage, 0.01)) // MAKE THIS A THUMBNAIL SOMEHOW
            
            
            
            if PFUser.currentUser()?.username != nil {
                sendImage["senderUsername"] = PFUser.currentUser()?.username!
            }
            if self.objectAtIndexPath(indexPath) != nil {
                // the following code sets a PFUser pointer under "recipientUsername"
                // sendImage["recipientUsername"] = self.objectAtIndexPath(indexPath)! as! PFUser
                
                // the following code sends a username string instead of a PFUser object
                var tempVar = self.objectAtIndexPath(indexPath)! as! PFUser
                sendImage["recipientUsername"] = tempVar.username!
            }
            
            */
            
            /*
            THE FOLLOWING CODE SAVES THINGS AS STRINGS. WHAT WE WANT IS TO SAVE THINGS AS PFUSERS FOR SCALABILITY??
            if PFUser.currentUser()?.username != nil {
                sendImage["senderUsername"] = PFUser.currentUser()?.username!
            }
            if self.objectAtIndexPath(indexPath) != nil {
                // the following code sets a PFUser pointer under "recipientUsername"
                // sendImage["recipientUsername"] = self.objectAtIndexPath(indexPath)! as! PFUser
                
                // the following code sends a username string instead of a PFUser object
                var tempVar = self.objectAtIndexPath(indexPath)! as! PFUser
                sendImage["recipientUsername"] = tempVar.username!
            }

            
            THE FOLLOWING CODE SAVES THINGS AS PFUSER
            if PFUser.currentUser() != nil {
                sendImage["fromUser"] = PFUser.currentUser()
            }
            if self.objectAtIndexPath(indexPath) != nil {
                
                sendImage["toUser"] = self.objectAtIndexPath(indexPath)! as! PFUser
                
            }
            
            sendImage.saveInBackgroundWithBlock({ (_, _) -> Void in
            
            })

            */
            
            /* This code was for testing the sending.
            var test = self.objectAtIndexPath(indexPath) as! PFUser
            var test2 = PFUser.currentUser()?.username
            println("send to \(test.username)")
            println("i am \(test2) ")
            */
            


            var activity = PFObject(className: "Activity") // FOR THE FEED
            
            if PFUser.currentUser() != nil {
                activity["fromUser"] = PFUser.currentUser()
            }
            if self.objectAtIndexPath(indexPath) != nil {
                activity["toUser"] = self.objectAtIndexPath(indexPath)! as! PFUser
            
            }
            activity["type"] = "sendImage"
            activity["content"] = passedEmotionText
            
            // drop down the quality
            // the following code doesnt work unless the filesize is small because Parse has a 128kb filesize limitation on PFObjects
            // sendImage["image"] = UIImageJPEGRepresentation(passedImage, 0.01)
            
            //activity["photo"] = PFFile(name: "image.jpg", data: UIImageJPEGRepresentation(passedImage, 0.01))
            
            activity["photo"] = passedImage
            
            // TO ADD: activity["thumbnail"] = PFFile(name: "thumbnail.jpg, data: UIImageJPEGRepresentation(passedImage, 0.01)) // MAKE THIS A THUMBNAIL SOMEHOW
            
            
            activity.saveInBackgroundWithBlock({ (_, _) -> Void in

            })

        }

        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // implement send button here???
        
        // segue back to the original view
        self.performSegueWithIdentifier("successfulMugSendSegue", sender: nil)
        
        
    }
    
    
    
}
