//
//  SignupViewController.swift
//  Mugsie
//
//  Created by Show Wang on 5/11/15.
//  Copyright (c) 2015 Show Wang. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UITextFieldDelegate {

    
    
    // Create an empty activity indicator view, which will be used later on in order show activity on clicking the sign-up button
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // Username text field
    @IBOutlet weak var username: UITextField!
    
    // Password text field
    @IBOutlet weak var password: UITextField!
    
    // First name text field
    @IBOutlet weak var firstName: UITextField!
    
    // Last name text field
    @IBOutlet weak var lastName: UITextField!
    
    // Email Text field
    @IBOutlet weak var email: UITextField!
    
    // This segmented control shifts between the login and signup logic
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // This is the signup button
    @IBOutlet weak var signupButton: UIButton!
    
    // This is the login button
    @IBOutlet weak var loginButton: UIButton!
    
    var defaultMugArray: [Mug] = []
    
    
    @IBAction func newUser(sender: AnyObject) {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.loginButton.hidden = false
            self.signupButton.hidden = true
            self.firstName.hidden = true
            self.lastName.hidden = true
            self.email.hidden = true
        } else {
            self.signupButton.hidden = false
            self.loginButton.hidden = true
            self.firstName.hidden = false
            self.lastName.hidden = false
            self.email.hidden = false
        }
    // Don't really remember why this is a connected IBAction, I think it's hooked up to the segmented control
    }
  
    // Function for displaying an alert to the screen
    func displayAlert(title: String, error: String) {
        // Creates the alert controller using default style
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        // Creates an "OK" button (but does not add to the alert controller yet)
        var okButton = UIAlertAction(title: "OK", style: .Default, handler: {(alert: UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            // Completion handler is set up to dismiss the alert box on clicking the OK button
            
            // Run code here after clicking the OK button
        })
        // Add the OK button to the alert controller
        alert.addAction(okButton)
        // Present the alert to the user
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    // This is the signup button
    @IBAction func signUp(sender: AnyObject) {
        var error = ""
        //Check to see user has inputted a username and password
        if username.text == "" || password.text == "" {
            error = "Please enter a username and password"
        }
        
        /* Insert password or username length checks here, e.g.
        else if count(password.text) <=4 {
            //Do some action
        }
        */
        
        // If there's an error, display the error alert
        if error != "" {
            
            displayAlert("Error in form", error: error)
            /*
            let alert = UIAlertController(title: "Error in form", message: error, preferredStyle: UIAlertControllerStyle.Alert)
    
            // let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
            let okButton = UIAlertAction(title: "OK", style: .Default, handler: {(alert: UIAlertAction!) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(okButton)
            self.presentViewController(alert, animated: true, completion: nil) */
        }
        // No errors, sign up the user
        else {
            // Parse saves user data in a PFUser object
            var user = PFUser()
            // Set the username and password to be passed to Parse as the username and the password in the text fields
            user.username = username.text
            user.password = password.text
            user["firstName"] = firstName.text
            user["lastName"] = lastName.text
            
            // Uncomment below if you want to add more text fields to the signup. Useful if you want to add password retrieval later on.
            /*
            user.email = "email@example.com"
            // other fields can be set just like with PFObject
            user["phone"] = "415-392-0202"
            */
            
            
            // The following code creates an activity indicator when they click on sign up so they know there's something going on in the background
            // This could be created with interface builder, but I lifted the code from somewhere to create it programmatically instead
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            // Center the activity indicator
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            
            // Animate the activity indicator on sign up attempt
            activityIndicator.startAnimating()
            // Ignore user interaction so they can't do other stuff while we're doing the sign up
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                
            // signUpInBackgroundWithBlock is a Parse method that signs in the user. Requires importing Parse library
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, signupError: NSError?) -> Void in
                
                // Regardless of whether signup is successful with Parse, stop animating the activity indicator and allow user to control interaction again
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                })
                
                if let signupError = signupError {
                    let errorString = signupError.userInfo?["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    error = errorString as! String
                    self.displayAlert("Could not sign up", error: error)
                   
                } else {
                    // Hooray! Let them use the app now.
                    self.initDefaultMugArray()
                    self.logIn("signUp")
                    
                }
            }
            
        }
        
    }
    
    
    @IBAction func logIn(sender: AnyObject) {
        
        // Logic for clicking Login button
        
        // Parse saves user data in a PFUser object
        var user = PFUser()
        // Set the username and password to be passed to Parse as the username and the password in the text fields
        user.username = username.text
        user.password = password.text
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        // Center the activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        
        // Animate the activity indicator on sign up attempt
        activityIndicator.startAnimating()
        // Ignore user interaction so they can't do other stuff while we're doing the sign up
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        // The logInWithUsernameInBackground method is done asynchronously.
        PFUser.logInWithUsernameInBackground(username.text, password: password.text) {
            (user: PFUser?, loginError: NSError?) -> Void in
            
            // Since it's asynchronous, we want to run the activity indicator while it's happening to show the user that something is going on. UI has to be updated on the main queue so we use GCD here.
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            })
            
            if user != nil {
                // Do stuff after successful login.
                
                println("successful login")
                if let signupSender = sender as? String {
                    println("logging in immediately after signup")
                    // coming in from the signup button
                    // save defaultMugArray to Parse since this is the first time we are logging in
                    
                    self.saveDefaultMugArrayToParse()
                }
                
                self.performSegueWithIdentifier("successfulLogInSegue", sender: sender)
                
            } else {
                let errorString = loginError?.userInfo?["error"] as? NSString
                let error = errorString as! String
                
                // The login failed. Check error to see why.
    
                self.displayAlert("Could not login", error: error)
                
            
            }
        }

    }
    
    // Initializes the default Mug array to send to Parse whenever a new account gets created.
    private func initDefaultMugArray() {
        
        var items = [Mug]()
        println("items is \(items)")
        let inputFile = NSBundle.mainBundle().pathForResource("defaultEmotions", ofType: "plist")
        println("inputFile is \(inputFile)")
        let inputDataArray = NSArray(contentsOfFile: inputFile!)
        println("inputDataArray is \(inputDataArray)")
        for inputItem in inputDataArray as! [Dictionary<String, String>] {
            println("inputItem is \(inputItem)")
            let mug = Mug(dataDictionary: inputItem)
            println("mug is \(mug)")
            items.append(mug)
        }
        
        defaultMugArray = items
        println("defaultMugArray is \(defaultMugArray)")
    }
    
    func saveDefaultMugArrayToParse() {
        
        //var user = PFUser.currentUser()!
        /*
        var user = PFObject(className: "UserMugRelation")
        user["user"] = PFUser.currentUser()!
        */
        //var relation = user.relationForKey("mugs")
        var savedMugArray = [PFObject]()
        
        for mug in defaultMugArray {
            var userMugs = PFObject(className: "UserMugs")
            userMugs["createdBy"] = PFUser.currentUser()!
            userMugs["emotionText"] = mug.emotionText
            userMugs["customMug"] = mug.customMug
            savedMugArray.append(userMugs)
            
        }
        
        PFObject.saveAllInBackground(savedMugArray)
        
        //PFObject.saveAllInBackground(savedMugArray, block: { (success, error) -> Void in
            //for mug in savedMugArray {
                //relation.addObject(mug)
            //}
        //})
        //user.saveInBackground()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signupButton.hidden = true
        self.username.delegate = self
        self.password.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Configure the segue for successful login
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "successfulLogInSegue" {
            
            // Do some stuff to allow transition of data across the segue
            /* e.g.
            let playlistImageView = sender!.view as! UIImageView
            if let index = find(playlistsArray, playlistImageView){
                
                let playlistDetailController = segue.destinationViewController as! PlaylistDetailViewController
                playlistDetailController.playlist = Playlist(index: index)
            }
            */
            
        }
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
