//
//  InstagramAPI.Swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import Foundation
import Alamofire


class InstagramAPI {

    let url1: NSURL = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=01825446a0d34fc5a7cee5ea7a4a59f7")!
    let url2: NSURL = NSURL(string: "https://api.instagram.com/v1/media/search?lat=37.8716667&lng=-122.2716667&client_id=01825446a0d34fc5a7cee5ea7a4a59f7")!
    static let baseURLString = "https://api.instagram.com"
    static let clientID = "01825446a0d34fc5a7cee5ea7a4a59f7"
    static let clientSecret = "245df10595f040908da523ab8a88b121"
    static let redirectURI = "http://shanew92.com/"
    static let getCodeURI = "https://api.instagram.com/oauth/authorize/?client_id=01825446a0d34fc5a7cee5ea7a4a59f7&redirect_uri=http://shanew92.com/&response_type=code"
    
    static func getRequestAccessTokenURLStringAndParams(code: String) -> (URLString: String, Params: [String: AnyObject]) {
        let params = ["client_id": self.clientID, "client_secret": self.clientSecret, "grant_type": "authorization_code", "redirect_uri": self.redirectURI, "code": code]
        let urlString = self.baseURLString + "/oauth/access_token"
        return (urlString, params)
    }
    
    static func getCode() -> NSURLRequest {
        let URLRequest = NSURLRequest(URL: NSURL(string: self.getCodeURI)!)
        return URLRequest
    }
    
    /* Connects with the Instagram API and pulls resources from the server. */
    func loadPhotos(urlNum: Int, completion: (([Photo]) -> Void)!) {
        /*
        * 1. Get the endpoint URL to the popular photos
        *    HINT: Look in Utils
        * 2. Create a Session
        * 3. Create a Data Task with a URL and completionHandler
        *    If no error:
        *       a. Get NSDictionary from the JSON object, from key the "photos"
        *       b. Create Array of NSDictionaries (one NSDictionary for each photo)
        *       c. For each NSDictionary, create a Photo object, and add to Photos array
        *       d. Wait for completion of Photos array
        */
        // FILL ME IN

        var url: NSURL = url1
        if urlNum == 1 {
            url = url2
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                //FIX ME
                var photos: [Photo]! = []
                do {
                    let feedDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    // FILL ME IN, REMEMBER TO USE FORCED DOWNCASTING
                    if let dataList = feedDictionary["data"] as? [[String : AnyObject]] {
                        for dic in dataList {
                            let photo: Photo = Photo(data: dic)
                            photos.append(photo)
                        }
                        if photos.count%2 != 0 {
                            photos.removeLast()
                        }
                    }
                    
                    // DO NOT CHANGE BELOW
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(photos)
                        }
                    }
                } catch let error as NSError {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}