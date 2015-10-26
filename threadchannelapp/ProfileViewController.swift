//
//  ProfileViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 5/23/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit
import Toucan

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
            self.userName.text = firstName + " " + [lastName[lastName.startIndex]]
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
            var profileImage = UIImage(data: data!)
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
        let post = User.currentUser!.newThreads![advance(User.currentUser!.newThreads!.startIndex, indexPath.row)].post
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
         let post = User.currentUser!.newThreads![advance(User.currentUser!.newThreads!.startIndex, indexPath.row)].post
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
