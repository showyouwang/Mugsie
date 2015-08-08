//
//  AppDelegate.swift
//  Mugsie
//
//  Created by Show Wang on 5/6/15.
//  Copyright (c) 2015 Show Wang. All rights reserved.
//

import UIKit
import Parse
import Bolts


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        // We use the local datastore so that users don't always have to download all of their mug thumbnails everytime they access the stash tab.
        
        
        // Initialize Parse.
        Parse.setApplicationId("8696QDBZhLrqy0gYTlPHFwfHuhVtzeyzQsciiku7",
            clientKey: "DK5z3k8l4nrGDF3oSMR93RN7CdY7fxdgLHDGcqaf")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // Following line of code, along with the changes in info.plist, make it so that the status bar is hidden on all views.
        application.setStatusBarHidden(true, withAnimation: .None)
        
        // This is to perform auto-login with Parse. If there's a current user logged-in, then we make the first screen the TabBarController. Otherwise, the SignupViewController will be root.
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle());
        let rootController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            self.window!.rootViewController = rootController
        }
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

