//
//  UserThreads.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 8/16/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import Foundation

public class UserThread : Printable, Hashable {
    
    private(set) var objectId : String!
    public var post : Post!
    public var user : User!
    
    init(dictionary: NSDictionary) {
        self.objectId = dictionary["objectId"] as? String
        let p = dictionary["post"] as! NSDictionary
        self.post = Post(dictionary: p)
        let u = dictionary["user"] as! NSDictionary
        self.user = User(dictionary: u)
    }
    
    init(post: Post) {
        self.post = post
    }
    
    public var hashValue: Int {
        return self.post.objectId.hashValue
    }
    
    public var description: String { get {return "name: \(self.post.name)";} }

    class func threadsFromArray(array: [NSDictionary]) -> UserThreads {
        var threads = UserThreads()
        for entry in array {
            let user_thread = UserThread(dictionary: entry)
            if threads.contains(user_thread) == false {
                threads.insert(user_thread)
            }
        }
        return threads
    }
}

public func ==(lhs: UserThread, rhs: UserThread) -> Bool {
    return (lhs.post.objectId == rhs.post.objectId)
}

public typealias UserThreads = Set<UserThread>
