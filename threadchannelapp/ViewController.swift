//
//  ViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/2/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//


import UIKit
import Alamofire


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var posts:[Post]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.Instance.postsWithCompletion { (posts, error) -> () in
            if error == nil {
                self.posts = posts
                self.collectionView.reloadData()
            }
        }
 
        navigationItem.title = "Thread Channel"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posts = self.posts {
            println(posts.count)
            return posts.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.initCell(self.view, post: self.posts![indexPath.row])
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
            return CGSize(width: 104, height: 104)
        } else if (self.view.frame.height == 667.0 && self.view.frame.width == 375 ) {
            //iphone 6
            return CGSize(width: 122, height: 122)
//            return CGSize(width: 122, height: 166)

        } else if (self.view.frame.height == 736.0 && self.view.frame.width == 414.0 ) {
            //iphone 6plus
            return CGSize(width: 136, height: 136)
           // return CGSize(width: 136, height: 166)

        }
        //default 5s
        return CGSize(width: 104, height: 104)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("gotolook", sender: posts[indexPath.row])
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let post = sender as? Post
        let lookVC = segue.destinationViewController as? LookViewController
        lookVC?.post = post
    }
}

