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
