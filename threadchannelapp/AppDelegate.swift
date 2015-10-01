//
//  AppDelegate.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/2/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor(CIColor: CIColor(red: 169/255, green: 202/255, blue: 62/255))  // Back buttons and such
        navigationBarAppearace.barTintColor = UIColor.whiteColor()
        //navigationBarAppearace.barTintColor = UIColor(CIColor: CIColor(red: 169/255, green: 202/255, blue: 62/255))
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(CIColor: CIColor(red: 169/255, green: 202/255, blue: 62/255))]
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        println("app will resign active")
        if User.currentUser?.threads != User.currentUser?.newThreads {
            User.currentUser?.synchronize()
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        println("app in background")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        println("app terminated")

    }


}

