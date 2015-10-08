//
//  LookViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 4/25/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit
import Spring

class LookViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate  {

    @IBOutlet weak var threadButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var post:Post!
    var looks:[Look]!
    var panning:Bool = true
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
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
        
        println(self.view.frame.origin.x)
        println(self.view.frame.origin.y)
        println("collection view")
        println(self.collectionView.frame.origin.x)
        println(self.collectionView.frame.origin.y)
        
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
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        
        
        println(self.view.frame.origin.x)
        println(self.view.frame.origin.y)
        println("collection view")
        println(self.collectionView.frame.origin.x)
        println(self.collectionView.frame.origin.y)

        let translation = sender.translationInView(sender.view!)
        let velocity = sender.velocityInView(sender.view!)

        if (translation.y > 0.0) {
            println("moving down")
            //where is the view
            if ((self.view.frame.origin.y + translation.y) < 0.0) {
                UIView.animateWithDuration(0.5, animations: {
                    self.view.frame.origin.y += translation.y
                })
            }
        } else if (translation.y < 0.0) {
            println("moving up")
            if self.panning == true {
                self.collectionView.scrollEnabled = false
                UIView.animateWithDuration(1.0, animations: {
                    self.view.frame.origin.y -= 66.0
                    }, completion: { finished in
                        self.panning = false
                        self.collectionView.scrollEnabled = true
                })
                
            }
            
            //where is the view
//            if ((self.view.frame.origin.y + translation.y) >= (0.0 - 399.0)) {
//                println("move view")
//                UIView.animateWithDuration(0.5, animations: {
//                    self.view.frame.origin.y += translation.y
//                })
//            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        println("should recognize gesture?")
        return true
    }
}
