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
        private static let usersURL = "https://api.parse.com/1/users"
        
        case Posts()
        case Looks([String: AnyObject])
        case Users()
    
        var path: String {
            switch self {
                case .Posts():
                    return "/classes/post"
                case .Looks(_):
                    return "classes/look"
                case .Users():
                    return ""
            }
        }
        
        var method: Alamofire.Method {
            switch self {
                case .Posts:
                    return .GET
                case .Looks:
                    return .GET
                case .Users:
                    return .GET
            }
        }
    
        var URLRequest: NSURLRequest {
            let URL = NSURL(string: Router.baseURL)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            
            let userURL = NSURL(string: Router.usersURL)!
            let userMutableURLRequest = NSMutableURLRequest(URL: userURL.URLByAppendingPathComponent(path))
            userMutableURLRequest.HTTPMethod = method.rawValue
            
            switch self {
                case .Posts():
                    return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
    
                case .Looks(let params):
                    return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                
                case .Users():
                    return Alamofire.ParameterEncoding.URL.encode(userMutableURLRequest, parameters: nil).0
                
                default:
                    return mutableURLRequest
            }
        }
    }
    
    func postsWithCompletion(completion: (posts: [Post], error: NSError?) -> ()) {
        let manager = self.Manager()
        
        manager.request(API.Router.Posts())
            .responseJSON { (request, response, JSON, error) in
                if error == nil {
                    let results = (JSON as! NSDictionary)["results"] as! [NSDictionary]
                    let posts = Post.postsFromArray(results)
                    completion(posts: posts, error: nil)
                } else {
                    println(error)
                    completion(posts: [Post](), error: error)
                }
        }
    }
    
    func looksWithCompletion(postObjectId: String, completion: (looks: [Look], error: NSError?) -> ()) {
        let manager = self.Manager()
        
        var p1 = [String: AnyObject]()
        p1["__type"] = "Pointer"
        p1["className"] = "post"
        p1["objectId"] = postObjectId

        var p2 = [String: AnyObject]()
        p2["post"] = p1
        
        var p3 = [String: AnyObject]()
        p3["where"] = p2
        p3["include"] = "post"

        manager.request(API.Router.Looks(p3))
            .responseJSON { (request, response, JSON, error) in
                if error == nil {
                    let results = (JSON as! NSDictionary)["results"] as! [NSDictionary]
                    //println(results)
                    let looks = Look.looksFromArray(results)
                    completion(looks: looks, error: nil)
                } else {
                    println(error)
                    completion(looks: [Look](), error: error)
                }
        }
    }
    
    func signUpWithCompletion(user: User, completion: (user: User, error: NSError?) -> ()) {
        let manager = self.Manager()

        
        manager.request(API.Router.Users())
            .responseJSON { (request, response, JSON, error) in
                if error == nil {
                    let results = (JSON as! NSDictionary)["results"] as! [NSDictionary]
                    println(results)
                } else {
                    println(error)
                }
        }
    }
    
    //unused
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