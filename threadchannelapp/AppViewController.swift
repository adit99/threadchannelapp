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
        let mainTabImage = UIImage(named: "home_grey")?.imageWithRenderingMode(.AlwaysOriginal)
        mainTabImage
        
        let trendingStoryboard = UIStoryboard(name: "Look", bundle: nil)
        let trendingVC = trendingStoryboard.instantiateInitialViewController() as! UINavigationController
        let trendingImage = UIImage(named: "today_grey")?.imageWithRenderingMode(.AlwaysOriginal)
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = profileStoryboard.instantiateInitialViewController() as! UINavigationController
        let profileTabImage = UIImage(named: "profile_grey")?.imageWithRenderingMode(.AlwaysOriginal)
        
        let controllers = [mainVC, trendingVC, profileVC]
        viewControllers = controllers
        
       // tabBar.barTintColor = UIColor(CIColor: CIColor(red: 96/255, green: 96/255, blue: 96/255))
        tabBar.barTintColor = UIColor.whiteColor()
        tabBar.tintColor = UIColor.greenColor()
        
        mainVC.tabBarItem = UITabBarItem(title: "", image: mainTabImage, tag: 1)
        mainVC.tabBarItem.selectedImage = UIImage(named: "home_green")?.imageWithRenderingMode(.AlwaysOriginal)
        
        trendingVC.tabBarItem = UITabBarItem(title: "", image: trendingImage, tag: 1)
        trendingVC.tabBarItem.selectedImage = UIImage(named: "today_green")?.imageWithRenderingMode(.AlwaysOriginal)
        
        profileVC.tabBarItem = UITabBarItem(title: "", image: profileTabImage, tag: 1)
        profileVC.tabBarItem.selectedImage = UIImage(named: "profile_green")?.imageWithRenderingMode(.AlwaysOriginal)
//        profileVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], forState: .Normal)
//        profileVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.greenColor()], forState: .Selected)
        
        selectedIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
