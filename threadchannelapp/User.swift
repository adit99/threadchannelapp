//
//  User.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 7/4/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

public class User : Printable {

    private(set) var objectId : String!
    private(set) var username : String!
    private(set) var email : String!
    private(set) var password : String!

    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
    
    public var description: String { get {return "username: \(username)";} }
}