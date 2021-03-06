//
//  TrendingViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 8/20/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

class TrendingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
        
        @IBOutlet weak var threadButton: UIButton!
        @IBOutlet weak var shareButton: UIButton!
        
        var post:Post!
        var looks:[Look]!
        
        @IBOutlet weak var postImageView: UIImageView!
        @IBOutlet weak var collectionView: UICollectionView!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //move to app delagate?
            navigationItem.title = "Today | \(Date.today())"
            
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
            
            
            //       let user_likes_post = User.currentUser!.threads!.filter({ ($0.objectId == self.post.objectId) })
            //       if user_likes_post.count > 0 {
            //            threadButton.selected = true
            //        }
            
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
        }
        
        @IBAction func shareTapped(sender: UIButton) {
        }
}

