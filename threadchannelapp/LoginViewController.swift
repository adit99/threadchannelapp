//
//  LoginViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 7/4/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Mixpanel

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.hidden = true
        
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookLoginButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func onLogin(sender: UIButton) {
        
        let user = User(username: username.text!, email: "", password: self.password.text!)
        activity.hidden = false
        activity.hidesWhenStopped = true
        activity.startAnimating()
        self.view.alpha = 0.6
        API.Instance.loginWithCompletion(user) { (user, error) -> () in
            self.activity.stopAnimating()
            self.view.alpha = 1
            if error == nil {
                User.currentUser = user
                
                let appStoryboard = UIStoryboard(name: "app", bundle: nil)
                let vc = appStoryboard.instantiateViewControllerWithIdentifier("AppViewController") as! AppViewController
                self.parentViewController!.presentViewController(vc, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertView()
                alert.title = "Login failed"
                alert.message = "\(error!.domain)"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
    }
    
    //Facebook Login
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        
        if error == nil {
            
            activity.hidden = false
            activity.startAnimating()
            self.view.alpha = 0.6
            
            //link the user
            API.Instance.loginWithFacebookWithCompletion(FBSDKAccessToken.currentAccessToken()) { (user, error) -> () in
            
                if error == nil {
                    
                    
                    
                    //before we move VC's get some user info (name and pic) from FBK API
                    var params = [String: AnyObject]()
                    params["fields"] = "first_name, last_name, picture.type(large), email"
                    let fbk = FBSDKGraphRequest(graphPath: "me", parameters: params)
                    fbk.startWithCompletionHandler{(connection:FBSDKGraphRequestConnection!,JSON:AnyObject?, error:NSError!) -> Void in
                        if error == nil {
                            print(JSON)
                            let result = JSON as! NSDictionary
                            let firstName = result["first_name"] as! String
                            let lastName = result["last_name"] as! String
                            let email = result["email"] as? String
                            let picture = result["picture"] as! NSDictionary
                            let data = picture["data"] as! NSDictionary
                            let profilePicUrl = data["url"] as! String
                           
                            
                            user!.setFacebookFields(firstName, lastName: lastName, profilePicUrl: profilePicUrl, email: email)
                            User.currentUser = user!
                           
                            //mixpanel - signup and user info
                            let mixpanel: Mixpanel = Mixpanel.sharedInstance()
                            mixpanel.track("user signup")
                            mixpanel.createAlias(firstName+lastName, forDistinctID: mixpanel.distinctId)
                            
                            var userProps = [String: AnyObject]()
                            userProps["email"] = email
                            userProps["first_name"] = firstName
                            userProps["last_name"]  = lastName
                            userProps["signup_date"] = Date.today()
                            mixpanel.people.set(userProps)
                            
                            self.activity.stopAnimating()
                            self.view.alpha = 1
                            
                            let appStoryboard = UIStoryboard(name: "app", bundle: nil)
                            let vc = appStoryboard.instantiateViewControllerWithIdentifier("AppViewController") as! AppViewController
                            self.presentViewController(vc, animated: true, completion: nil)
                            
                        } //else?
                    }//else?
                } else {
                    let alert = UIAlertView()
                    alert.title = "Login with Facebook failed1"
                    alert.message = "\(error!.domain)"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                }
            }
        }
        else {
            let alert = UIAlertView()
            alert.title = "Login with Facebook failed2"
            alert.message = "\(error!.domain)"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("facebook logout")
    }
    
}
