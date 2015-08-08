//
//  FriendsTableViewController.swift
//  Mugsie
//
//  Created by Show Wang on 5/29/15.
//  Copyright (c) 2015 Show Wang. All rights reserved.
//

import UIKit
import Parse

class FriendsTableViewController: PFQueryTableViewController, UISearchBarDelegate {
    
    // this is the default search text used in the search bar delegate.
    var searchText = ""
    
    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        // perform logout here, this is the logout button
        PFUser.logOutInBackground()
        // perform segue back to the login screen here
        self.performSegueWithIdentifier("logoutSegue", sender: sender)
    }
    
    
    
    // MARK: This will get you the global user list as opposed to the friend list
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
      
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        // i dont think the following code is going to do much, not sure why it's here...
        self.parseClassName = className
    }
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
        // this is the actual code that ends up setting what ends up being queried. my guess is the default is to just populate the fields with PFUser usernames
        self.parseClassName = "_User"
    }


    
    // MARK: UNCOMMENT THE FOLLOWING CODE TO START SETTING UP THE FRIENDS LIST
    /*
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
        
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        // i dont think the following code is going to do much, not sure why it's here...
        self.parseClassName = className
        // self.parseClassName = "Friendship"
    }
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
        // this is the actual code that ends up setting what ends up being queried.
        self.parseClassName = "Friendship"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fixes annoying UI bug
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
    }
    
    // MARK: tableView
    override func queryForTable() -> PFQuery {
        var query : PFQuery
        
        if searchText.isEmpty {
            query = PFQuery(className: "Friendship")
            query.whereKey("currentUser", equalTo: PFUser.currentUser()!)
            query.includeKey("theFriend")
        } else {
            // username search
            var userNameSearch = PFUser.query()
            userNameSearch!.whereKey("username", containsString: searchText)
            
            // email search
            var emailSearch = PFUser.query()
            emailSearch!.whereKey("email", equalTo: searchText)
            
            /*
            // phone number search
            var additionalSearch = PFUser.query()
            additionalSearch.whereKey("additional", equalTo: searchText)
            */

            // or them together
            query = PFQuery.orQueryWithSubqueries([userNameSearch!, emailSearch!])
        }
        
        return query
    }
    
    
    
    // MARK: Add friend
    func addFriend(friend: PFUser) {
        //        var areFriends = PFQuery(className: self.parseClassName)
        var areFriends = PFQuery(className: "Friendship")
        areFriends.whereKey("currentUser", equalTo: PFUser.currentUser()!)
        areFriends.whereKey("theFriend", equalTo: friend)
        areFriends.countObjectsInBackgroundWithBlock { (count, _) -> Void in
            if count > 0 {
                // already friends
                println("Not adding, already friends.")
            } else {
                // add friend
                var bff = PFObject(className: "Friendship")
                bff["currentUser"] = PFUser.currentUser()
                bff["theFriend"] = friend // friend is the PFUser being passed into this function
                bff.saveInBackground() // Save to parse
                println("adding \(PFUser.currentUser()!.username!) -> \(friend.username!)")
            }
        }
    }
    
    
    // MARK: Search Bar
    // delegate in story board
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // add minimum length of search
        searchText = searchBar.text
        self.loadObjects()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // clear out search box
        searchBar.text = nil
        // clear out search variable
        searchText = ""
        // reload the table
        self.loadObjects()
        // hide keyboard
        searchBar.resignFirstResponder()
    }
    
    */
    
    
}
