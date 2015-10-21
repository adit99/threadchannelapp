//
//  LookViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 4/25/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

class LookViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var threadButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var post:Post!
    var looks:[Look]!
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let post = self.post
        if post == nil {
            navigationItem.title = "Today | \(Date.today())"
            API.Instance.trendingPostWithCompletion { (trending, error) -> () in
                if error == nil {
                    self.post = trending.post
                    println(trending)
                    self.load()
                } else {
                    //need some error
                    println("couldnt get trending post")
                }
            }
        } else {
            //move to app delagate?
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.contentMode = .ScaleAspectFit
            let image = UIImage(named: "logo")
            imageView.image = image
            navigationItem.titleView = imageView
            load()
        }
    }
    
    func load() {
        //load the image
        let url = NSURL(string: post.imageURL)
        postImageView.setImageWithURL(url)

        //load the looks
        API.Instance.looksWithCompletion(post.objectId) { (looks, error) -> () in
            if error == nil {
                self.looks = looks
                if self.looks.count > 0 {
                    let url = NSURL(string: looks[0].imageURL)
                    self.collectionView.reloadData()
                }
            }
        }
        
        if User.currentUser!.newThreads!.contains(UserThread(post: post)) {
            threadButton.selected = true
        }
        
        threadButton.setImage(UIImage(named:"thread_grey.png"),forState:UIControlState.Normal)
        threadButton.setImage(UIImage(named:"thread_green.png"),forState:UIControlState.Selected)
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let looks = self.looks {
            return looks.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LookViewCell", forIndexPath: indexPath) as! LookViewCell
        cell.initCell(self.view, look: self.looks![indexPath.row])
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
        
        if self.view.frame.height == 568.0 && self.view.frame.width == 320.0 {
            //iphone 5s
            return CGSize(width: 156, height: 198)
        } else if (self.view.frame.height == 667.0 && self.view.frame.width == 375 ) {
            //iphone 6
            //return CGSize(width: 122, height: 166)
            return CGSize(width: 184, height: 240)
        } else if (self.view.frame.height == 736.0 && self.view.frame.width == 414.0 ) {
            //iphone 6plus
            return CGSize(width: 204, height: 260)
        }
        //default 5s
        return CGSize(width: 156, height: 198)
    }
    
    @IBAction func threadTapped(sender: UIButton) {
        sender.selected = !sender.selected
        if (sender.selected) {
            User.currentUser!.newThreads!.insert(UserThread(post: post))
        } else {
            User.currentUser!.newThreads!.remove(UserThread(post: post))
        }
        
         NSNotificationCenter.defaultCenter().postNotificationName(valueForAPIKey(keyname: "userThreadsChanged"), object: nil)
    }

    @IBAction func shareTapped(sender: UIButton) {
    }
}

//Redux
//TODO: Need to debug bizarre bug with sections


class LookViewController2: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
    var post:Post!
    var looks:[Look]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.registerClass(Look2ViewCellImage.self, forCellWithReuseIdentifier: "Look2ViewCellImage")
        self.collectionView!.registerClass(Look2ViewCellButton.self, forCellWithReuseIdentifier: "Look2ViewCellButton")
        
        let post = self.post
        if post == nil {
            navigationItem.title = "Today | \(Date.today())"
            API.Instance.trendingPostWithCompletion { (trending, error) -> () in
                if error == nil {
                    self.post = trending.post
                    println(trending)
                    self.load()
                } else {
                    //need some error
                    println("couldnt get trending post")
                }
            }
        } else {
            //move to app delagate?
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.contentMode = .ScaleAspectFit
            let image = UIImage(named: "logo")
            imageView.image = image
            navigationItem.titleView = imageView
            load()
        }
        
    }
    
    func load() {
        //load the looks
        API.Instance.looksWithCompletion(post.objectId) { (looks, error) -> () in
            if error == nil {
                self.looks = looks
                if self.looks.count > 0 {
                    let url = NSURL(string: looks[0].imageURL)
                    self.collectionView?.reloadData()
                }
            }
        }
        
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let looks = self.looks {
            return 3
        } else {
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            return 2
        default:
            if let looks = self.looks {
                return looks.count
            } else {
                return 0
            }
        }
    }
    
    //flow layout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        switch(section) {
        case 0:
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        case 1:
            return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        default:
            return UIEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 2.0)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch (indexPath.section) {
        case 0:
            return CGSize(width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height/2)
        case 1:
            return CGSize(width: 44, height: 44)
        default:
            if self.view.frame.height == 568.0 && self.view.frame.width == 320.0 {
                //iphone 5s
                return CGSize(width: 156, height: 198)
            } else if (self.view.frame.height == 667.0 && self.view.frame.width == 375 ) {
                //iphone 6
                //return CGSize(width: 122, height: 166)
                return CGSize(width: 184, height: 240)
            } else if (self.view.frame.height == 736.0 && self.view.frame.width == 414.0 ) {
                //iphone 6plus
                return CGSize(width: 204, height: 260)
            }
            //default 5s
            return CGSize(width: 156, height: 198)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        switch(section) {
        case 1:
            return 200.0
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
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if (indexPath.section == 0) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Look2ViewCellImage", forIndexPath: indexPath) as! Look2ViewCellImage
            cell.initCell(self.view, imageURL: post.imageURL)
            return cell
        }
        else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Look2ViewCellButton", forIndexPath: indexPath) as! Look2ViewCellButton
                cell.initCell(self.view, imageSelected: "thread_green.png", imageNormal: "thread_grey.png", vc: self, selector: "threadTapped:")
                
                if User.currentUser!.newThreads!.contains(UserThread(post: post)) {
                    cell.button.selected = true
                }
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Look2ViewCellButton", forIndexPath: indexPath) as! Look2ViewCellButton
                cell.initCell(self.view, imageSelected: "share_green.png", imageNormal: "share_grey.png", vc: self, selector: "shareTapped:")
                return cell
            }
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Look2ViewCellImage", forIndexPath: indexPath) as! Look2ViewCellImage
        cell.initCell(self.view, imageURL: self.looks![indexPath.row].imageURL)
        //cell.initCell(self.view, imageURL: post.imageURL)
        return cell
    }
    
    func threadTapped(sender: UIButton) {
        sender.selected = !sender.selected
        if (sender.selected) {
            User.currentUser!.newThreads!.insert(UserThread(post: post))
        } else {
            User.currentUser!.newThreads!.remove(UserThread(post: post))
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(valueForAPIKey(keyname: "userThreadsChanged"), object: nil)
        
    }
    
    func shareTapped(sender: UIButton) {
        sender.selected = !sender.selected
    }
    
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    }
}
