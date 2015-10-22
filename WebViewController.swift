//
//  WebViewController.swift
//  threadchannelapp
//
//  Created by Aditya Jayaraman on 10/21/15.
//  Copyright (c) 2015 threadchannel. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.scalesPageToFit = true
        let requestObj = NSURLRequest(URL: NSURL(string: url)!)
        webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
