//
//  CollectionViewCell.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/3/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit
import iCarousel
import Toucan

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
        let url = NSURL(string: imageURL)
        image.setImageWithURL(url)
        image.contentMode = .ScaleAspectFit
        contentView.addSubview(image)
        setNeedsLayout()
    }
    
    func initCell(containerView: UIView, namedImage: String) {
        image.image = UIImage(named: namedImage)
        image.contentMode = .ScaleAspectFit
        contentView.addSubview(image)
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image.frame = self.contentView.frame
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

class Look2ViewCellScroll : UICollectionViewCell {
    var scrollView = UIScrollView()
    
    func initCell(containerView: UIView, looks: [Look]) {
        
        if looks.count > 0 {
            let imageView = UIImageView()
            let url = NSURL(string: looks[0].imageURL)
            imageView.setImageWithURL(url)
            imageView.frame.size.height = self.frame.size.height
            imageView.frame.size.width = self.frame.size.width
            imageView.contentMode = .ScaleAspectFit
            scrollView.addSubview(imageView)
            scrollView.contentSize = imageView.frame.size
            contentView.addSubview(scrollView)
        }
        scrollView.frame.size.height = self.frame.size.height
        scrollView.frame.size.width  = self.frame.size.width
    }
}

class Look2ViewCellCarousel : UICollectionViewCell {
    var carousel = iCarousel()
    
    func initCell(dataSource: iCarouselDataSource, delegate: iCarouselDelegate) {
       
        carousel.frame.size.width = self.frame.size.width
        carousel.frame.size.height = self.frame.size.height
        
        carousel.delegate = delegate
        carousel.dataSource = dataSource
        carousel.type = .Rotary
        carousel.center = contentView.center
        contentView.addSubview(carousel)
    }
}

class Look2ViewCellPage : UICollectionViewCell {
    var pageControl = UIPageControl()
    
    func initCell(numPages: Int) {
        let color = CIColor(red: 169/255, green: 202/255, blue: 62/255)

        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(CIColor: color)
        pageControl.pageIndicatorTintColor  = UIColor.grayColor()
        pageControl.tintColor = UIColor(CIColor: color)
        pageControl.center = contentView.center
        contentView.addSubview(pageControl)
    }
    
    func setPage(pageIndex: Int) {
        pageControl.currentPage = pageIndex
    }
}

//Profile View

class ProfileViewCell : UICollectionViewCell {
    var image = UIImageView()
    
    func initCell(containerView: UIView, profilePicURL: String?) {

        if let profileURL = profilePicURL {
        
            let url = NSURL(string: profileURL)
            let data = NSData(contentsOfURL: url!)
            let profileImage = UIImage(data: data!)
            let color = CIColor(red: 169/255, green: 202/255, blue: 62/255)
        
            self.image.image  = Toucan(image: profileImage!).resize(CGSize(width: 86, height: 86), fitMode: Toucan.Resize.FitMode.Crop).image
        
            self.image.image = Toucan(image: self.image.image!).maskWithEllipse(borderWidth: 2, borderColor: UIColor(CIColor: color)).image

            image.contentMode = .ScaleAspectFit
            image.frame.size.height = self.frame.size.height
            image.frame.size.width  = self.frame.size.width
            contentView.addSubview(image)
        }
    }
}

//TODO: fix all the other cells to match these semantics
//Align frame of subviews to content View
class LabelViewCell : UICollectionViewCell {
    var nameLabel = UILabel()
    
    func initCell(containerView: UIView) {
        let user = User.currentUser!
        let text = user.firstName! + " " + String([user.lastName![user.lastName!.startIndex]])
        
        let attributedText = NSMutableAttributedString(
            string: text,
            attributes: [NSFontAttributeName:UIFont(
                name: "AmericanTypewriter",
                size: 16.0)!])
        
        nameLabel.attributedText = attributedText
        //nameLabel.textColor = UIColor.blackColor()
        nameLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(nameLabel)
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = self.contentView.frame
    }
}

class ThreadInfoViewCell : UICollectionViewCell {
    var threadCount = UILabel()
    var threadImage = UIImageView()
    
    func initCell(containerView: UIView) {
       
        //thread image
        threadImage.image = UIImage(named: "thread_green")
        threadImage.contentMode = .ScaleAspectFit
        contentView.addSubview(threadImage)
        
        //thread count
        let user = User.currentUser!
        let text = user.newThreads!.count.description
        let attributedText = NSMutableAttributedString(
            string: text,
            attributes: [NSFontAttributeName:UIFont(
                name: "AmericanTypewriter",
                size: 16.0)!])
        
        threadCount.attributedText = attributedText
        threadCount.textAlignment = NSTextAlignment.Center
        contentView.addSubview(threadCount)
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        threadImage.frame = contentView.frame
        threadCount.frame = contentView.frame
        
        threadImage.frame.origin.x = self.contentView.frame.origin.x - 15
        threadCount.frame.origin.x = self.contentView.frame.origin.x + 15
    }    
}

class EditButtonViewCell : UICollectionViewCell {
    var button  = UIButton()
    
    func initCell(containerView: UIView, vc: UIViewController, selector: Selector) {
        button.setTitle("Edit", forState:UIControlState.Normal)
        button.setTitleColor(UIColor.greenColor(), forState:UIControlState.Normal)
        button.addTarget(vc, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(button)
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        button.frame = self.contentView.frame
    }
}




