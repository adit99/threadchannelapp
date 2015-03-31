//
//  ViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/2/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    let imagesArray = ["babydoll",  "offshoulder", "otcsocks",
                       "paperbag", "tutu", "turtleneck",
                       "Peplum", "Raglan", "Singlet",
                       "cocooncoat", "doublebreasted", "Iridescent"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.Instance.posts()
        navigationItem.title = "Today | March 3"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.initCell(self.view, image: UIImage(named: imagesArray[indexPath.row])!)
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
            println("5s")
            return CGSize(width: 104, height: 104)
        } else if (self.view.frame.height == 667.0 && self.view.frame.width == 375 ) {
            //iphone 6
            return CGSize(width: 122, height: 166)
        } else if (self.view.frame.height == 736.0 && self.view.frame.width == 414.0 ) {
            //iphone 6plus
            return CGSize(width: 136, height: 166)
        }
        //default 5s
        return CGSize(width: 104, height: 104)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //self.performSegueWithIdentifier("gotodetails", sender: indexPath)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       let detailsViewController = segue.destinationViewController as! DetailsViewController
        let indexPath = sender as! NSIndexPath
        detailsViewController.image = UIImage(named: imagesArray[indexPath.row])!
    }
}

