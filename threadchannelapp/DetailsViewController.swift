//
//  DetailsViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/3/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var image: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var subImageView: UIImageView!
    
    let imagesArray = ["culottes1",  "culottes2", "culottes3",
        "culottes4", "culottes5", "culottes6"]
    var imageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        println(screenSize.width)
        println(screenSize.height)
        
        imageView.frame.size.height = screenSize.height / 2
        imageView.contentMode = .ScaleToFill
        imageView.image = image
        
        pageControl.numberOfPages = imagesArray.count
        subImageView.image = UIImage(named: imagesArray[0])!
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "onSubImageSwipe:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        swipeRight.numberOfTouchesRequired = 1
        self.subImageView.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "onSubImageSwipe:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeLeft.numberOfTouchesRequired = 1
        self.subImageView.addGestureRecognizer(swipeLeft)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onSubImageSwipe(sender: UISwipeGestureRecognizer) {
        println("onswipe")
        if (sender.direction  == .Left && imageIndex < imagesArray.count - 1) {
            imageIndex += 1
        }
        
        if (sender.direction  == .Right && imageIndex > 0) {
            imageIndex -= 1
        }
        UIView.animateWithDuration(1.2) {
            self.pageControl.currentPage = self.imageIndex
            self.subImageView.image = UIImage(named: self.imagesArray[self.imageIndex])!
        }
    }
}
