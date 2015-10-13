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

class ThreadViewCell: UICollectionViewCell {
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


class Look2ViewCell: UICollectionViewCell {
    
    func initCell(containerView: UIView, text: String) {
        var newLabel = UILabel(frame: CGRectMake(10, 20, 50.0, 20.0))
        newLabel.text = text
        contentView.addSubview(newLabel)
    }
}

class Look2ViewCellImage : UICollectionViewCell {
    
    func initCell(containerView: UIView, imageURL: String) {
        var image = UIImageView()
        let url = NSURL(string: imageURL)
        image.setImageWithURL(url)
        image.contentMode = .ScaleAspectFit
        contentView.addSubview(image)
        image.frame = self.frame
    }
}

class Look2ViewCellButton : UICollectionViewCell {
    
    func initCell(containerView: UIView, imageSelected: String, imageNormal: String) {
        var button = UIButton()
        button.setImage(UIImage(named:imageNormal),forState:UIControlState.Normal)
        button.setImage(UIImage(named:imageSelected),forState:UIControlState.Selected)
        button.imageView?.contentMode = .ScaleAspectFit
        contentView.addSubview(button)
        button.frame.size.height = self.frame.size.height
        button.frame.size.width  = self.frame.size.width
    }
}


