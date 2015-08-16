//
//  LoginViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 7/4/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.hidden = true
        
        //hack, this need to move to app delegate
        if User.currentUser != nil {
            
            var appStoryboard = UIStoryboard(name: "app", bundle: nil)
            let vc = appStoryboard.instantiateViewControllerWithIdentifier("AppViewController") as! AppViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBAction func onLogin(sender: UIButton) {
        
        var user = User(username: username.text, email: "", password: self.password.text)
        activity.hidden = false
        activity.hidesWhenStopped = true
        activity.startAnimating()
        self.view.alpha = 0.6
        API.Instance.loginWithCompletion(user) { (user, error) -> () in
            self.activity.stopAnimating()
            self.view.alpha = 1
            if error == nil {
                User.currentUser = user
                
                var appStoryboard = UIStoryboard(name: "app", bundle: nil)
                let vc = appStoryboard.instantiateViewControllerWithIdentifier("AppViewController") as! AppViewController
                self.presentViewController(vc, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertView()
                alert.title = "Login failed"
                alert.message = "\(error!.domain)"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
    }
}
