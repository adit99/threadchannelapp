//
//  Date.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 4/19/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

class Date {
    static let months = ["Jan", "Feb", "March", "April", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]
    
    class func today() -> NSString {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        let month = components.month
        let day = components.day
        
        return "\(months[month]) \(day)"
    }
}
