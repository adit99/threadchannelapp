//
//  File.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 10/27/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import Foundation

public class Retail : CustomStringConvertible {
    private(set) var logoURL : String!
    private(set) var linkURL : String!

    init(logoURL: String, linkURL: String) {
        self.logoURL = logoURL
        self.linkURL = linkURL
    }
    
    class func retailFromDictionary(entry: NSDictionary) -> [Retail] {
        var retails = [Retail]()
        let logoBase = "leto"
        let linkBase = "link"
        
        for i in 1...3 {
            let logo = logoBase + i.description
            let link = linkBase + i.description

            let lo = entry[logo] as? NSDictionary
            let li = entry[link] as? String
            
            if let logoURL = lo, linkURL = li {
                let retail = Retail(logoURL: logoURL["url"] as! String, linkURL: linkURL)
                retails.append(retail)
            }
        }
        return retails
    }
    
    public var description: String { get {return "logoURL: \(logoURL)";} }
}