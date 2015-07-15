//
//  User.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 7/4/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

var _currentUser: User?
let _currentUserKey = "currentUser"

public class User : Printable {

    private(set) var objectId : String!
    private(set) var username : String!
    private(set) var email : String!
    private(set) var password : String!
    private(set) var sessionToken : String!
    public var threads : [Post]?
    private var dictionary : NSDictionary?

    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
    
    init(dictionary: NSDictionary) {
        self.objectId = dictionary["objectId"] as! String
        self.username = dictionary["username"] as! String
        self.email = dictionary["email"] as! String
        self.sessionToken = dictionary["sessionToken"] as! String
        self.password = ""
        self.dictionary = dictionary
    }
    
    class func postsFromArray(array: [NSDictionary]) -> [Post] {
        var posts = [Post]()
        for entry in array {
            let thread = entry["post"] as! NSDictionary
            let post = Post(dictionary: thread)
            posts.append(post)
        }
        return posts
    }

    
    public var description: String { get {return "username: \(username)";} }

    class var currentUser : User? {
        get {
        if _currentUser == nil {
        var data = NSUserDefaults.standardUserDefaults().objectForKey(_currentUserKey) as? NSData
        if (data != nil) {
        var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
        _currentUser = User(dictionary: dictionary)
        }
        }
        return _currentUser
        }
        
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: _currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: _currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}




