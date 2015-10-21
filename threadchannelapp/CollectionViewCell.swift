//
//  CollectionViewCell.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/3/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func initCell(containerView: UIView, post: Post) {
        let url = NSURL(string: post.imageURL)
        imageView.setImageWithURL(url)
    }
}

class LookViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func initCell(containerView: UIView, look: Look) {
        let url = NSURL(string: look.imageURL)
        imageView.setImageWithURL(url)
    }
}

class ThreadViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func initCell(containerView: UIView, post: Post) {
        let url = NSURL(string: post.imageURL)
        imageView.setImageWithURL(url)
    }
}


class Look2ViewCellImage : UICollectionViewCell {
    var image = UIImageView()
    
    func initCell(containerView: UIView, imageURL: String) {
        //image = UIImageView()
        let url = NSURL(string: imageURL)
        image.setImageWithURL(url)
        //image.contentMode = .ScaleAspectFill
        image.contentMode = .ScaleToFill
        contentView.addSubview(image)
        image.frame.size.height = self.frame.size.height
        image.frame.size.width  = self.frame.size.width
    }
}

class Look2ViewCellButton : UICollectionViewCell {
    var button  = UIButton()
    
    func initCell(containerView: UIView, imageSelected: String, imageNormal: String, vc: UIViewController, selector: Selector) {
        //button = UIButton()
        button.setImage(UIImage(named:imageNormal),forState:UIControlState.Normal)
        button.setImage(UIImage(named:imageSelected),forState:UIControlState.Selected)
        button.imageView?.contentMode = .ScaleAspectFit
        button.addTarget(vc, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        contentView.addSubview(button)
        button.frame.size.height = self.frame.size.height
        button.frame.size.width  = self.frame.size.width
    }
}
