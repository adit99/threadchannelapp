//
//  Trending.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/30/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

public class Trending : Printable, NilLiteralConvertible {
    private(set) var post: Post!
    private(set) var date: NSDate!
    
    public var description: String { get {return "name: \(post.name)\nimageURL: \(post.imageURL)\ndate: \(date)";} }

    init(dictionary: NSDictionary) {
        self.post = Post(dictionary: dictionary["post"] as! NSDictionary)
        let dateString = (dictionary["date"] as! NSDictionary)["iso"] as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-ddThh:mm:ss.SSSZ"
        self.date = dateFormatter.dateFromString(dateString)
    }
    
    public required init(nilLiteral: ()) {
        post = nil
        date = nil
    }
}