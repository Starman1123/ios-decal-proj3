//
//  LoginViewController.swift
//  Photos
//
//  Created by Sheng Wang on 11/24/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let item: UIBarButtonItem = UIBarButtonItem(title: "cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelButtonTapped:"))
        self.navigationItem.rightBarButtonItem = item
        webView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //webView.hidden = false
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
            }
        }
        
        let request = NSURLRequest(URL: InstagramAPI.getCode().URL!, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        //print("url is \(InstagramAPI.getCode().URL!)")
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //debugPrint(request.URLString)
        let urlString = request.URLString
        print("urlString is \(urlString)")
        print("range of it is \(urlString.rangeOfString(InstagramAPI.redirectURI + "?code="))")
        if let range = urlString.rangeOfString(InstagramAPI.redirectURI + "?code=") {
            
            let location = range.endIndex
            let code = urlString.substringFromIndex(location)
            print("code is \(code)")
            requestAccessToken(code)
            return false
        }
        return true
    }
    
    func requestAccessToken(code: String) {
        let request = InstagramAPI.getRequestAccessTokenURLStringAndParams(code)
        print("request is \(request)")
        Alamofire.request(.POST, request.URLString, parameters: request.Params)
            .responseJSON {
                (_, _, result) in
                print("\(result)")
                switch result {
                case .Success(let jsonObject):
                    //debugPrint(jsonObject)
                    let json = JSON(jsonObject)
                    
                    if let accessToken = json["access_token"].string {
                        print("access_token is \(accessToken)")
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.access_token = accessToken
                        let ac = UIAlertController(title: "Photos", message: "You have successfully signed in!", preferredStyle: UIAlertControllerStyle.Alert)
                        let action = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                        ac.addAction(action)
                        self.presentViewController(ac, animated: true, completion: nil)
                    }
                case .Failure:
                    break;
                }
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.hidden = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
}



