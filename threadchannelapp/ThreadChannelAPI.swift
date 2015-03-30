//
//  ThreadChannelAPI.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/29/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import Foundation
import Alamofire

class API {
    static var baseURL = "https://api.parse.com/1/"
    
    class func request() {

        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["X-Parse-Application-Id"] = "tTMrjreYSpOUgIkMslJHJc1slcbY5g4yZvl9DRyw"
        defaultHeaders["X-Parse-REST-API-Key"] = "Ece7hzKGE9UNLLgqLQ122dVxTxqFdZ0fLYtQ7CZ1"

        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        let manager = Alamofire.Manager(configuration: configuration)
        
        let url = baseURL + "classes/look/zVPbUNWl0n"

        manager.request(.GET, url, parameters: [:])
            .responseJSON { (request, response, JSON, error) in
            println(JSON)
        }
    }
    
}