//
//  LookViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 4/25/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

class LookViewController: UIViewController {

    var post:Post!
    var looks:[Look]!
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var lookImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: post.imageURL)
        postImageView.setImageWithURL(url)

        API.Instance.looksWithCompletion(post.objectId) { (looks, error) -> () in
            if error == nil {
                self.looks = looks
                if self.looks.count > 0 {
                    let url = NSURL(string: looks[0].imageURL)
                    self.lookImageView.setImageWithURL(url)
                    self.pageControl.numberOfPages = looks.count
                }
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
