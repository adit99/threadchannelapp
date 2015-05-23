//
//  AppViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 5/23/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

class AppViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = mainStoryboard.instantiateInitialViewController() as! UINavigationController
        let mainTabImage = UIImage(named: "home")?.imageWithRenderingMode(.AlwaysOriginal)

        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = profileStoryboard.instantiateInitialViewController() as! UINavigationController
        let profileTabImage = UIImage(named: "profile")?.imageWithRenderingMode(.AlwaysOriginal)
        
        let controllers = [mainVC, profileVC]
        viewControllers = controllers
        
        tabBar.barTintColor = UIColor(CIColor: CIColor(red: 96/255, green: 96/255, blue: 96/255))
        tabBar.tintColor = UIColor.whiteColor()
        
        mainVC.tabBarItem = UITabBarItem(title: "Home", image: mainTabImage, tag: 1)
        mainVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], forState: .Normal)
        mainVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.greenColor()], forState: .Selected)
        
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: profileTabImage, tag: 1)
        profileVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], forState: .Normal)
        profileVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.greenColor()], forState: .Selected)
        
        selectedIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
