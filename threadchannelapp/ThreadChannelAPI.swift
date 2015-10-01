//
//  ThreadChannelAPI.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 3/29/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import Foundation
import Alamofire
import FBSDKCoreKit

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
        private static let threadsURL = "/1/classes/user_threads"
        
        case Posts()
        case Looks([String: AnyObject])
        case Login([String: AnyObject])
        case LoginWithFacebook([String: AnyObject])
        case Users()
        case Signup([String: AnyObject])
        case UserThreads([String: AnyObject])
        case Batch([String: AnyObject])
        case Trending([String: AnyObject])
        case Temp()
    
        var path: String {
            switch self {
                case .Posts():
                    return "classes/post"
                case .Looks(_):
                    return "classes/look"
                case .Login(_):
                    return "login"
                case .LoginWithFacebook(_):
                    return "users"
                case .Users():
                    return ""
                case .Signup(_):
                    return "users"
                case .UserThreads(_):
                    return "classes/user_threads"
                case .Batch(_):
                    return "batch"
                case .Trending(_):
                    return "classes/trending"
                case .Temp():
                    return "user_threads"
            }
        }
        
        var method: Alamofire.Method {
            switch self {
                case .Posts:
                    return .GET
                case .Looks:
                    return .GET
                case .Login:
                    return .GET
                case .LoginWithFacebook:
                    return .POST
                case .Users:
                    return .GET
                case .Signup:
                    return .POST
                case .UserThreads:
                    return .GET
                case .Batch:
                    return .POST
                case .Trending:
                    return .GET
                case .Temp():
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
                
                case .Login(let params):
                    return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                
                case .LoginWithFacebook(let params):
                    return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params).0
                
                case .Users():
                    return Alamofire.ParameterEncoding.URL.encode(userMutableURLRequest, parameters: nil).0
                
                case .Signup(let params):
                    return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params).0
                
                case .UserThreads(let params):
                    return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                
                case .Batch(let params):
                    return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params).0
                
                case .Trending(let params):
                    return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
                
                case .Temp():
                    return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
                
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

        var params = [String: AnyObject]()
        params["username"] = user.username
        params["password"] = user.password
        params["email"] = user.email
        
        manager.request(API.Router.Signup(params))
            .responseJSON { (request, response, JSON, error) in
                if error == nil {
                    let results = JSON  as! NSDictionary
                    println(results)
                    if let session = (results["sessionToken"] as? String) {
                        params["sessionToken"] = results["sessionToken"] as! String
                        params["objectId"] = results["objectId"] as! String
                        params["createdAt"] = results["createdAt"] as! String
                        completion(user: User(dictionary: params), error: nil)
                    } else {
                        var error = NSError(domain:
                            results["error"] as! String, code: results["code"] as! Int, userInfo: nil)
                        completion(user: user, error: error)
                    }
                } else {
                    println(error)
                }
        }
    }
    
    func loginWithCompletion(user: User, completion: (user: User, error: NSError?) -> ()) {
        let manager = self.Manager()
        
        var params = [String: AnyObject]()
        params["username"] = user.username
        params["password"] = user.password
        
        manager.request(API.Router.Login(params))
            .responseJSON { (request, response, JSON, error) in
                if error == nil {
                    let results = JSON  as! NSDictionary
                    //println(results)
                    if let session = (results["sessionToken"] as? String) {
                        var user = User(dictionary: results)
                        completion(user: user, error: nil)
                    } else {
                        var error = NSError(domain:
                            results["error"] as! String, code: results["code"] as! Int, userInfo: nil)
                        completion(user: user, error: error)
                    }
                } else {
                    println(error)
                    completion(user: user, error: error)
                }
        }
    }
    
    func loginWithFacebookWithCompletion(fbAccessToken: FBSDKAccessToken, completion: (user: User?, error: NSError?) -> ()) {
        let manager = self.Manager()
        
        var params = [String: AnyObject]()
        var authdata = [String: AnyObject]()
        var facebook = [String: AnyObject]()
        facebook["id"] = fbAccessToken.userID
        facebook["access_token"] = fbAccessToken.tokenString
        var date = Date.formatter(fbAccessToken.expirationDate)
        facebook["expiration_date"] = date
        
        authdata["facebook"] = facebook
        params["authData"] = authdata
        
        manager.request(API.Router.LoginWithFacebook(params))
            .responseJSON { (request, response, JSON, error) in
   
                if error == nil {
                    let results = JSON  as! NSDictionary
                    if let session = (results["sessionToken"] as? String) {
                        var user = User(dictionary: results)
                        completion(user: user, error: nil)
                    } else {
                        var error = NSError(domain:
                            results["error"] as! String, code: results["code"] as! Int, userInfo: nil)
                        completion(user: nil, error: error)
                    }
                } else {
                    println(error)
                    completion(user: nil, error: error)
                }
        }
    }
    
    
    func userThreadsWithCompletion(user: User, completion: (threads: UserThreads, error: NSError?) -> ()) {
        let manager = self.Manager()
        
        var p1 = [String: AnyObject]()
        p1["__type"] = "Pointer"
        p1["className"] = "_User"
        p1["objectId"] = user.objectId
        
        var p2 = [String: AnyObject]()
        p2["user"] = p1
        
        var p3 = [String: AnyObject]()
        p3["where"] = p2
        p3["include"] = "post,user"
        p3["order"] = "updatedAt"
        p3["limit"] = 100
        
        manager.request(API.Router.UserThreads(p3))
            .responseJSON { (request, response, JSON, error) in
                if error == nil {
                    let results = (JSON as! NSDictionary)["results"] as! [NSDictionary]
                    //println(results)
                    let threads = UserThread.threadsFromArray(results)
                    completion(threads: threads, error: nil)
                } else {
                    println(error)
                    completion(threads: UserThreads(), error: error)
                }
        }
    }

    func synchronizeUser(data: User.SyncData) {

        let manager = self.Manager()
    
        var d = [String: AnyObject]()
        var requests = [NSDictionary]()
        
        for addedthread in data.addedThreads {
            var at = [String: AnyObject]()
            at["method"] = "POST"
            at["path"] = API.Router.threadsURL
            
            var body = [String: AnyObject]()
            
            var post = [String: AnyObject]()
            post["__type"] = "Pointer"
            post["className"] = "post"
            post["objectId"] = addedthread.post!.objectId
            
            body["post"] = post
            
            var user = [String: AnyObject]()
            user["__type"] = "Pointer"
            user["className"] = "_User"
            user["objectId"] = data.user.objectId
            
            body["user"] = user
            
            at["body"] = body
            
            requests.append(at)
        }
        
        for deletedThread in data.deletedThreads {
            var rt = [String: AnyObject]()
            rt["method"] = "DELETE"
            let path = API.Router.threadsURL + "/" + deletedThread.objectId
            rt["path"] = path
            requests.append(rt)
        }
        
        d["requests"] = requests

        manager.request(API.Router.Batch(d))
            .responseJSON { (request, response, JSON, error) in
                if error == nil {
                    let results = (JSON) as! [NSDictionary]
                    for result in results {
                        //println(result)
                        if let success = result["success"] as? NSDictionary {
                            println(success)
                        } else if let err = result["error"] as? NSDictionary {
                            println(err)
                        }
                    }
                    API.Instance.userThreadsWithCompletion(User.currentUser!) { (threads, error) -> () in
                        if error == nil {
                            println("updating threads")
                            User.currentUser!.threads = threads
                            User.currentUser!.newThreads = threads
                        }
                    }
                } else {
                    println(error)
                }
        }

    }

    
    func trendingPostWithCompletion(completion: (trending: Trending, error: NSError?) -> ()) {
        let manager = self.Manager()
        
        var param = [String: AnyObject]()
        param["include"] = "post"
        
        manager.request(API.Router.Trending(param))
            .responseJSON { (request, response, JSON, error) in
                if error == nil {
                    let results = (JSON as! NSDictionary)["results"] as! [NSDictionary]
                    let trending = Trending(dictionary: results[0])
                    completion(trending: trending, error: nil)
                } else {
                    println(error)
                    completion(trending: nil, error: error)
                }
        }
    }
    
    //tester function
    func tempWithCompletion(completion: (error: NSError?) -> ()) {
        let manager = self.Manager()
        
      
        
        manager.request(API.Router.Temp())
            .responseJSON { (request, response, JSON, error) in
                if error == nil {
                    let results = (JSON as! NSDictionary)["results"] as! [NSDictionary]
                    println(results)
                    completion(error: nil)
                } else {
                    println(error)
                    completion(error: error)
                }
        }
    }
    
    
    
    //unused
    
    func userThreadsWithCompletion2(user: User, completion: (threads: [Post], error: NSError?) -> ()) {
        let manager = self.Manager()
        
        var p1 = [String: AnyObject]()
        p1["objectId"] = user.objectId
        
        var p3 = [String: AnyObject]()
        p3["where"] = p1
        p3["include"] = "post"
        
        manager.request(API.Router.UserThreads(p3))
            .responseJSON { (request, response, JSON, error) in
                if error == nil {
                    let results = (JSON as! NSDictionary)["results"] as! [NSDictionary]
                    //println(results)
                    let tdict = (results[0] as NSDictionary)["threads"] as! [NSDictionary]
                    let threads = Post.postsFromArray(tdict)
                    completion(threads: threads, error: nil)
                } else {
                    println(error)
                    completion(threads: [Post](), error: error)
                }
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