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

public class User : CustomStringConvertible {

    private(set) var objectId : String!
    private(set) var username : String!
    private(set) var email : String!
    private(set) var password : String!
    private(set) var sessionToken : String!
    public var threads : UserThreads?
    public var newThreads : UserThreads?
    private var dictionary : NSMutableDictionary?
    
    //facebook fields (not email is optional from fbk)
    private(set) var firstName : String?
    private(set) var lastName : String?
    private(set) var profilePicURL : String?
    
    public func setFacebookFields(firstName: String, lastName: String, profilePicUrl: String, email: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.profilePicURL = profilePicUrl
        
        if let e = email {
            self.email = e
        } else {
            self.email = ""
        }
        
        self.dictionary?.setValue(firstName, forKey: "first_name")
        self.dictionary?.setValue(lastName, forKey: "last_name")
        self.dictionary?.setValue(profilePicURL, forKey: "profile_pic_url")
        self.dictionary?.setValue(email, forKey: "email")
    }
    
    struct SyncData {
        var user: User
        var addedThreads : UserThreads
        var deletedThreads : UserThreads
    }

    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
    
    init(dictionary: NSDictionary) {
        self.objectId = dictionary["objectId"] as! String
        self.username = dictionary["username"] as! String
        self.email = dictionary["email"] as? String
        self.sessionToken = dictionary["sessionToken"] as? String
        self.password = ""
        
        //facebook fields
        self.firstName = dictionary["first_name"] as? String
        self.lastName  = dictionary["last_name"] as? String
        self.profilePicURL = dictionary["profile_pic_url"] as? String
        
        self.dictionary = dictionary.mutableCopy() as? NSMutableDictionary
    }
    
    public var description: String { get {return "username: \(username)";} }

    class var currentUser : User? {
        get {
        if _currentUser == nil {
        let data = NSUserDefaults.standardUserDefaults().objectForKey(_currentUserKey) as? NSData
        if (data != nil) {
        //var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
        do {
            let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            _currentUser = User(dictionary: dictionary as! NSDictionary)
        } catch  {
            print("error")
            assert(true)
        }
        }
        }
        return _currentUser
        }
        
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                //var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: nil, error: nil)
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: NSJSONWritingOptions.PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: _currentUserKey)
                } catch {
                    print("error")
                    assert(true)
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: _currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    public func synchronize() {
        
        //synchronize the threads
        //added threads
        let addedThreads = newThreads!.subtract(threads!)
        print("added Threads: \(addedThreads)")
        //deleted theads
        let deletedThreads = threads!.subtract(newThreads!)
        print("deleted threads: \(deletedThreads)")
    
        let data = User.SyncData(user:self, addedThreads: addedThreads, deletedThreads: deletedThreads)
        API.Instance.synchronizeUser(data)
    }
}




