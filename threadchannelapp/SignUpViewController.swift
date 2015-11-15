//
//  SignUpViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 7/4/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        
        //alert.message = "username:\(self.username.text) email:\(self.email.text) password:\(self.password.text)"

        let user = User(username: self.username.text!, email: self.email.text!, password: self.password.text!)
        
        activity.hidden = false
        activity.hidesWhenStopped = true
        activity.startAnimating()
        self.view.alpha = 0.6
        
        API.Instance.signUpWithCompletion(user) { (user, error) -> () in
            self.activity.stopAnimating()
            self.view.alpha = 1
            if error == nil {
                User.currentUser = user
                let appStoryboard = UIStoryboard(name: "app", bundle: nil)
                let vc = appStoryboard.instantiateViewControllerWithIdentifier("AppViewController") as! AppViewController
                self.presentViewController(vc, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertView()
                alert.title = "Signup failed"
                alert.message = "\(error!.domain)"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
