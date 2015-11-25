//
//  misc.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 11/24/15.
//  Copyright © 2015 threadchannel. All rights reserved.
//

import Foundation

extension NSData {
    
    /// Return hexadecimal string representation of NSData bytes
    @objc(kdj_hexadecimalString)
    public var hexadecimalString: NSString {
        var bytes = [UInt8](count: length, repeatedValue: 0)
        getBytes(&bytes, length: length)
        
        let hexString = NSMutableString()
        for byte in bytes {
            hexString.appendFormat("%02x", UInt(byte))
        }
        
        return NSString(string: hexString)
    }
}