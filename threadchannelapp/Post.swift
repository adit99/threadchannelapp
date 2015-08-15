//
//  Post.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/30/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

public class Post : Printable, Hashable {
    private(set) var objectId : String!
    private(set) var name : String!
    private(set) var imageURL : String!
    public var hashValue: Int {
        return self.objectId.hashValue
    }
    
    public var description: String { get {return "name: \(name)";} }

    init(dictionary: NSDictionary) {
        self.objectId = dictionary["objectId"] as? String
        self.name = dictionary["name"] as? String
       // self.imageURL = dictionary["imageURL"] as! String
        if let image = dictionary["image"] as? NSDictionary {
            self.imageURL = image["url"] as! String
        }
        self.objectId = dictionary["objectId"] as? String
    }
    
    class func postsFromArray(array: [NSDictionary]) -> [Post] {
        var posts = [Post]()
        for entry in array {
            let post = Post(dictionary: entry)
            posts.append(post)
        }
        return posts
    }
    
    class func threadsFromArray(array: [NSDictionary]) -> Set<Post> {
        var threads = Set<Post>()
        for entry in array {
            let post = Post(dictionary: entry)
            if threads.contains(post) == false {
                threads.insert(post)
            }
        }
        return threads
    }
}

public func ==(lhs: Post, rhs: Post) -> Bool {
    return (lhs.objectId == rhs.objectId)
}