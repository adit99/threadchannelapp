//
//  ThreadChannelAPI.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/29/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import Foundation
import Alamofire



func valueForAPIKey(#keyname:String) -> String {
    let filePath = NSBundle.mainBundle().pathForResource("threadchannel", ofType:"plist")
    let plist = NSDictionary(contentsOfFile:filePath!)
    let value:String = plist?.objectForKey(keyname) as! String
    return value
}

class API {
    
    class var Instance : API {
        struct Static {
            static let instance = API()
        }
        return Static.instance
    }
  
    private func Manager() -> Alamofire.Manager {
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["X-Parse-Application-Id"] = valueForAPIKey(keyname: "ParseAppID")
        defaultHeaders["X-Parse-REST-API-Key"] = valueForAPIKey(keyname: "ParseAPIKey")
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        return Alamofire.Manager(configuration: configuration)
    }
  
    enum Router: URLRequestConvertible {
        private static let baseURL = valueForAPIKey(keyname: "baseURL")
        
        case Posts()
    
        var path: String {
            switch self {
                case .Posts():
                    return "/classes/post"
            }
        }
        
        var method: Alamofire.Method {
            switch self {
                case .Posts:
                    return .GET
            }
        }
    
        var URLRequest: NSURLRequest {
            let URL = NSURL(string: Router.baseURL)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            
            switch self {
                case .Posts():
                    return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
    
                default:
                    return mutableURLRequest
            }
        }
    }
    
    func posts() {
        
        let manager = self.Manager()
        
        manager.request(API.Router.Posts())
            .responseJSON { (request, response, JSON, error) in
                println(request)
                println(error)
                println(JSON)
        }
    }
    
    class func request() {

        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["X-Parse-Application-Id"] = valueForAPIKey(keyname: "ParseAppID")
        defaultHeaders["X-Parse-REST-API-Key"] = valueForAPIKey(keyname: "ParseAPIKey")

        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        let manager = Alamofire.Manager(configuration: configuration)
        let url = Router.baseURL + "classes/look/"

        var params = [String: AnyObject]()
        params["name"] = "iridescent"
        
        var parameters = [String: AnyObject]()
        parameters["where"] = params
        
        let URL = NSURL(string: url)!
        var request = NSURLRequest(URL: URL)
        
        request = Alamofire.ParameterEncoding.URL.encode(request, parameters: parameters).0
        
        manager.request(request)
        //manager.request(.GET, url, parameters: parameters)
            .responseJSON { (request, response, JSON, error) in
                println(request)
                println(error)
                println(JSON)
        }
    }
    
    
    
}