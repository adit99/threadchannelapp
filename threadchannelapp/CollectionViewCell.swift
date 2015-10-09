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

class LookPosterViewCell : UICollectionViewCell {
    
    //var label = UILabel()
    
    //    override func awakeFromNib() {
    //        super.awakeFromNib()
    //        label.setTranslatesAutoresizingMaskIntoConstraints(false)
    //        contentView.addSubview(label)
    //    }
    
    //}
    
    func initCell(containerView: UIView, text: String) {
        var image = UIImageView(frame: CGRectMake(0, 0, 82, 82))
        let url = NSURL(string: "http://static1.squarespace.com/static/53698760e4b07b6993bcd67d/t/557c7195e4b0a5d8f4b54b5e/1434218904320/Palazzo_Pants.jpg?format=1000w")
        image.setImageWithURL(url)
        contentView.addSubview(image)
    }
}

class Look2ViewCell: UICollectionViewCell {
    
    //var label = UILabel()
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        label.setTranslatesAutoresizingMaskIntoConstraints(false)
//        contentView.addSubview(label)
//    }
    
    //}
    
    func initCell(containerView: UIView, text: String) {
        var newLabel = UILabel(frame: CGRectMake(10, 20, 50.0, 20.0))
        newLabel.text = text
       // label.text = text

        contentView.addSubview(newLabel)
    }
}

class ThreadViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func initCell(containerView: UIView, post: Post) {
        let url = NSURL(string: post.imageURL)
        imageView.setImageWithURL(url)
    }
}