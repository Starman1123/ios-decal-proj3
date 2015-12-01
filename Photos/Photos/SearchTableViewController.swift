//
//  SearchTableViewController.swift
//  Photos
//
//  Created by Sheng Wang on 11/25/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    var userList :Array<User> = Array<User>()
    var imageCache: NSCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.tag = indexPath.row
        
        
        let user: User = userList[indexPath.row]
        if imageCache.objectForKey(indexPath.row) != nil {
            cell.imageView!.image = imageCache.objectForKey(user.profile_url!) as? UIImage
            cell.textLabel!.text = user.username
            cell.imageView!.layer.cornerRadius = (cell.imageView?.frame.size.width)!/2
            cell.imageView!.clipsToBounds = true
            cell.setNeedsLayout()
        }
        else {
            cell.imageView?.image = UIImage(named: "default_user.png")
            print(user.profile_url)
            NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: user.profile_url)!, completionHandler: { (data :NSData?, response :NSURLResponse?, error :NSError?) -> Void in
                if error == nil {
                    if cell.tag == indexPath.row {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell.imageView!.image = UIImage(data: data!)
                            cell.imageView!.layer.cornerRadius = (cell.imageView?.frame.size.width)!/2
                            cell.imageView!.clipsToBounds = true
                            cell.textLabel?.text = user.username
                            self.imageCache.setObject(UIImage(data: data!)!, forKey: user.profile_url!)
                            cell.setNeedsLayout()
                        })
                    }
                }
            }).resume()
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
        if (searchBar.text?.characters.count<3 || searchBar.text?.containsString(" ") != false) {
            userList.removeAll()
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            return
        }
        InstagramAPI().loadUsers(searchBar.text!, completion: didLoadUsers)
    }
    
    func didLoadUsers(users: [User]) {
        self.userList = users
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true);
        return false;
    }

    func didTapView(){
        self.view.endEditing(true)
    }
}
