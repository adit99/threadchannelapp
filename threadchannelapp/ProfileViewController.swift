//
//  ProfileViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 5/23/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit
import Toucan
import FBSDKCoreKit
import FBSDKLoginKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var threadCount: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //move to app delagate?
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        navigationItem.titleView = imageView
        
        initProfileFields()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userThreadsChanged", name: valueForAPIKey(keyname: "userThreadsChanged"), object: nil)
    }

    func initProfileFields() {
        
        let user = User.currentUser!
        
        //username or first name last name
        if let firstName = user.firstName {
            let lastName = user.lastName!
            self.userName.text = firstName + " " + String([lastName[lastName.startIndex]])
        } else {
            self.userName.text = user.username
        }
        
        //thread count
        self.threadCount.text = user.newThreads!.count.description

        //profile pic
        //TODO: this is probably not performant
        if let profilePicUrl  = user.profilePicURL {
            let url = NSURL(string: profilePicUrl)
            let data = NSData(contentsOfURL: url!)
            let profileImage = UIImage(data: data!)
            //self.profileImageView.setImageWithURL(url)
            let color = CIColor(red: 169/255, green: 202/255, blue: 62/255)

            self.profileImageView.image  = Toucan(image: profileImage!).resize(CGSize(width: 86, height: 86), fitMode: Toucan.Resize.FitMode.Crop).image
            
            self.profileImageView.image = Toucan(image: self.profileImageView.image!).maskWithEllipse(borderWidth: 2, borderColor: UIColor(CIColor: color)).image
        }
    
        
        //TODO: Circular profile image
        //Toucan(image: myImage).maskWithEllipse(borderWidth: 10, borderColor: UIColor.yellowColor()).image
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let threads = User.currentUser!.newThreads {
            return threads.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThreadViewCell", forIndexPath: indexPath) as! ThreadViewCell
        let post = User.currentUser!.newThreads![User.currentUser!.newThreads!.startIndex.advancedBy(indexPath.row)].post
        cell.initCell(self.view, post: post)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 2.0)
        return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if self.view.frame.width == 320.0 {
            //iphone 5s
            return CGSize(width: 104, height: 104)
        } else if (self.view.frame.width == 375 ) {
            //iphone 6
            return CGSize(width: 122, height: 122)
            //return CGSize(width: 122, height: 166)
        } else if (self.view.frame.width == 414.0 ) {
            //iphone 6plus
            return CGSize(width: 136, height: 136)
            // return CGSize(width: 136, height: 166)
            
        }
        //default 5s
        return CGSize(width: 104, height: 104)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Look", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LookViewController2") as! LookViewController2
        let post = User.currentUser!.newThreads![User.currentUser!.newThreads!.startIndex.advancedBy(indexPath.row)].post
        vc.post = post
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        self.navigationController!.pushViewController(vc, animated: true)
    }

    func userThreadsChanged() {
        self.reloadView()
    }
    
    //this is bad, should only reload whats changed, also if adding a thread show it in the begining
    func reloadView() {
//        self.userName.text = User.currentUser!.username
//        self.threadCount.text = User.currentUser!.newThreads!.count.description
        initProfileFields()
        
        self.collectionView.reloadData()
    }
}


//Profile2

class ProfileViewController2: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var imageArray = [UIImage]()
    var backgroundImage = UIImageView()
    
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.registerClass(Look2ViewCellImage.self, forCellWithReuseIdentifier: "Look2ViewCellImage")
        self.collectionView!.registerClass(ProfileViewCell.self, forCellWithReuseIdentifier: "ProfileViewCell")
        self.collectionView!.registerClass(LabelViewCell.self, forCellWithReuseIdentifier: "LabelViewCell")
        self.collectionView!.registerClass(ThreadInfoViewCell.self, forCellWithReuseIdentifier: "ThreadInfoViewCell")
        self.collectionView!.registerClass(EditButtonViewCell.self, forCellWithReuseIdentifier: "EditButtonViewCell")


        //move to app delagate?
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        navigationItem.titleView = imageView
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userThreadsChanged", name: valueForAPIKey(keyname: "userThreadsChanged"), object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "logoutTapped")
        
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let _ = User.currentUser!.newThreads {
            return 4
        } else {
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (section) {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return 1
            default:
                return User.currentUser!.newThreads!.count
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let user = User.currentUser!
        
        switch (indexPath.section) {
            case 0:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfileViewCell", forIndexPath: indexPath) as! ProfileViewCell
                
                cell.initCell(self.view, profilePicURL: user.profilePicURL)
                let imageView = UIImageView()
                imageView.setImageWithURL(NSURL(string: user.profilePicURL!))
                
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = view.bounds
                blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
                imageView.addSubview(blurEffectView)
                cell.backgroundView = imageView
                
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LabelViewCell", forIndexPath: indexPath) as! LabelViewCell
                cell.initCell(self.view)
                return cell
            case 2:
                    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThreadInfoViewCell", forIndexPath: indexPath) as! ThreadInfoViewCell
                    cell.initCell(self.view)
                    return cell
            default:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Look2ViewCellImage", forIndexPath: indexPath) as! Look2ViewCellImage
                if (indexPath.row < User.currentUser!.newThreads?.count) {

                    let post = User.currentUser!.newThreads![User.currentUser!.newThreads!.startIndex.advancedBy(indexPath.row)].post
                    cell.initCell(self.view, imageURL: post.imageURL)
                }
                return cell
        }
    }
    
    func userThreadsChanged() {
        self.reloadView()
    }
    
    //this is bad, should only reload whats changed, also if adding a thread show it in the begining
    func reloadView() {
        self.collectionView?.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch (indexPath.section) {
            case 0:
                return CGSize(width: UIScreen.mainScreen().bounds.size.width , height: UIScreen.mainScreen().bounds.size.height/6)
            case 1:
                return CGSize(width: UIScreen.mainScreen().bounds.size.width , height: UIScreen.mainScreen().bounds.size.height/18)
            case 2:
                return CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 32)
            default:
                if self.view.frame.height == 568.0 && self.view.frame.width == 320.0 {
                    //iphone 5s
                    return CGSize(width: 154, height: 154)
                } else if (self.view.frame.height == 667.0 && self.view.frame.width == 375 ) {
                    //iphone 6
                    return CGSize(width: 182, height: 182)
                } else if (self.view.frame.height == 736.0 && self.view.frame.width == 414.0 ) {
                    //iphone 6plus
                    return CGSize(width: 202, height: 202)
                }
                //default 5s
                return CGSize(width: 154, height: 154)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        switch (section) {
            case 0:
                return UIEdgeInsets(top: 2.0, left: 0.0, bottom: 1.0, right: 0.0)
            case 1:
                return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 1.0, right: 0.0)
            case 2:
                return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 1.0, right: 0.0)
            default:
                return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 1.0, right: 0.0)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        switch(section) {
        default:
            return 0.0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeMake(0, 0)
    }
    
    
     override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Look", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LookViewController2") as! LookViewController2
        let post = User.currentUser!.newThreads![User.currentUser!.newThreads!.startIndex.advancedBy(indexPath.row)].post
        vc.post = post
        self.collectionView!.deselectItemAtIndexPath(indexPath, animated: false)
        self.navigationController!.pushViewController(vc, animated: true)
    }
  
    
    func logoutTapped() {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            
        }
        actionSheetController.addAction(cancelAction)
        
        //Create and add first option action
        let logoutAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                User.currentUser!.logout()
        }
        actionSheetController.addAction(logoutAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
   
    }
}

