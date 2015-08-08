//
//  SecondViewController.swift
//  Mugsie
//
//  Created by Show Wang on 5/6/15.
//  Copyright (c) 2015 Show Wang. All rights reserved.
//

import UIKit
import Parse

class SecondViewController: PFQueryTableViewController {
    
    
    var twentyFourHoursAgoDate = NSDate(timeIntervalSinceNow: -24*60*60)
    var tapGesture = UIGestureRecognizer()
    
    /*
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        self.parseClassName = className
    }
    */
    
    /*
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        self.parseClassName = "Activity"
    }
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
        self.parseClassName = "Activity"
    }
    */
    
    
    
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
    }
    

    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
        self.parseClassName = "Activity"
        self.pullToRefreshEnabled = false
        self.paginationEnabled = false
        
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // fixes annoying UI bug
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        loadObjects()
        cleanUpOldMugs()
    }
    
    
  
    
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Activity")
        query.whereKey("toUser", equalTo: PFUser.currentUser()!)
        query.whereKey("fromUser", notEqualTo: PFUser.currentUser()!)
        query.whereKey("createdAt", greaterThanOrEqualTo: twentyFourHoursAgoDate)
        query.whereKeyExists("fromUser")
        
        // grabs relational data in the initial query. this assumes that "fromUser" is of type PFUser, and "photo" is a pointer to the image PFFile
        query.includeKey("fromUser")
        // query.includeKey("photo") // to add some other time
        query.orderByDescending("createdAt")
        
        // query.cachePolicy = .NetworkOnly
        /*
            enum PFCachePolicy : UInt8 {

            case IgnoreCache
            case CacheOnly
            case NetworkOnly
            case CacheElseNetwork
            case NetworkElseCache
            case CacheThenNetwork
            }
        */
        /*
        if (self.objects!.count == 0) {
            query.cachePolicy = .CacheThenNetwork
        }
        */
        return query
    }
   
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        //var cell = tableView.dequeueReusableCellWithIdentifier("SecondViewCell", forIndexPath: indexPath) as! SecondViewCell
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("SecondViewCell") as! SecondViewCell!
        
        if cell == nil {
            cell = SecondViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "SecondViewCell")
            println("cell is \(cell)")
        }
        
        
        // Extract names from the PFObject to display in the table cell
        println(object)
        if let type = object?["type"] as? String {
            if type == "sendImage" {
                if let sentEmotionText = object?["content"] as? String {
                    
                    if let sender = object?["fromUser"] as? PFUser {
                        
                        if sender.username != nil {
                            let senderUsername = sender.username! as String
                            println("senderUsername is \(senderUsername)")
                            println("sentEmotionText is \(sentEmotionText)")
                            cell.setLabel("\(senderUsername) is \(sentEmotionText)")
                            
                            // cell.feedItemLabel!.text = senderUsername
                            
                            //println(cell.feedItemLabel.text)
                        }
                        
                    }
                    
                }
                
                var initialThumbnail = UIImage(named: "question_mark")
                cell.feedItemThumbnail.image = initialThumbnail
                
                // Display flag image
                
                // replace with object?["thumbnail"] or something like that
                
                
                if let thumbnail = object?["photo"] as? PFFile {
                    println(thumbnail)
                    cell.feedItemThumbnail.file = thumbnail
                    cell.feedItemThumbnail.loadInBackground()
                
                }
                
                if let createdAtDate = object!.createdAt as NSDate? {
                    cell.feedItemTime.text = timeAgoSinceDate(createdAtDate, numericDates: true)
                }
                
                
            }
            
        }
        return cell
    }
    
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekOfYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitSecond
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components(unitFlags, fromDate: earliest, toDate: latest, options: nil)
        
        if (components.year >= 2) {
            return "\(components.year) years ago"
        } else if (components.year >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month >= 2) {
            return "\(components.month) months ago"
        } else if (components.month >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) weeks ago"
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day >= 2) {
            return "\(components.day) days ago"
        } else if (components.day >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour >= 2) {
            return "\(components.hour) hours ago"
        } else if (components.hour >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute >= 2) {
            return "\(components.minute) minutes ago"
        } else if (components.minute >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second >= 3) {
            return "\(components.second) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    
    // Sets the height for the table rows
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // get the object
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var selectedObject = self.objectAtIndexPath(indexPath)!
    
        var imageView: PFImageView = PFImageView()
        imageView.file = selectedObject["photo"] as? PFFile // actual photo, not the thumbnail
        imageView.loadInBackground { (photo, error) -> Void in
            if error == nil {
                var backgroundView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                backgroundView.backgroundColor = UIColor.blackColor()
                backgroundView.alpha = 0.8
                backgroundView.tag = 3
                self.view.addSubview(backgroundView)
                
                var displayedImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                displayedImage.image = photo
                displayedImage.tag = 3
                // delete the following line of code to display fullscreen iamge
                displayedImage.contentMode = UIViewContentMode.ScaleAspectFit
                self.view.addSubview(displayedImage)
                // PUT IN A UI GESTURE RECOGNIZER WITH SELECTOR "hideMessage"
                self.tapGesture = UITapGestureRecognizer(target: self, action: "hideMessage")
                self.view.addGestureRecognizer(self.tapGesture)
               
            }
            
        }
        
    }

    func hideMessage() {
        for subview in self.view.subviews {
            if subview.tag == 3 {
                subview.removeFromSuperview()
            }
        }
        self.view.removeGestureRecognizer(self.tapGesture)
    }
    
    func cleanUpOldMugs() {
        var query = PFQuery(className: "Activity")
        query.whereKey("toUser", equalTo: PFUser.currentUser()!)
        query.whereKey("fromUser", notEqualTo: PFUser.currentUser()!)
        query.whereKey("createdAt", lessThan: twentyFourHoursAgoDate)
        query.whereKeyExists("fromUser")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // find succeeded
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        object.deleteInBackground()
                    }
                }
                } else {
                    // no old mugs found
                    println("no mugs older than 24 hours found")
                    }
            
        }
    }
    
    
    
}