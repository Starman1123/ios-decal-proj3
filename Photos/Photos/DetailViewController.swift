//
//  DetailViewController.swift
//  Photos
//
//  Created by Sheng Wang on 11/16/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var likesNumber: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var likeButton: UIButton!

    var photo: Photo!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image ?? nil
        self.likesNumber.text = String(photo.likes) + " likes"
        self.date.text = "time created: " + photo.date
        self.username.text = "Username: " + photo.username
        
        _ = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: photo.url2)!) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imageView.image = UIImage(data: data!)
                    self.imageView.setNeedsLayout()
                })
            }
            }.resume()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func likeButtonClicked(sender: AnyObject) {
        debugPrint("likeButtonClicked")
        likeButton.setImage(UIImage(named: "LikeFilled.png"), forState: .Normal)
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
