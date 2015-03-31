//
//  Post.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/30/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

class Post {
    private var name : String!
    private var imageURL : String!

    init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as! String
        self.imageURL = dictionary["imageURL"] as! String
    }
    
    class func postsFromArray(array: [NSDictionary]) -> [Post] {
        var posts = [Post]()
        for entry in array {
            let post = Post(dictionary: entry)
            posts.append(post)
        }
        return posts
    }
}