//
//  Look.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/30/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

public class Look : Printable {
    private(set) var blogURL : String!
    private(set) var imageURL : String!
    private(set) var name : String!

    public var description: String { get {return "name: \(name)";} }
    
    init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as! String
        self.blogURL = dictionary["blogURL"] as? String
        self.imageURL = dictionary["imageURL"] as! String
    }
    
    class func looksFromArray(array: [NSDictionary]) -> [Look] {
        var looks = [Look]()
        for entry in array {
            let look = Look(dictionary: entry)
            looks.append(look)
        }
        return looks
    }
}