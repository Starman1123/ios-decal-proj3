//
//  PhotosCollectionViewController.swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    var photos: Array<Photo> = Array<Photo>()
    var imageCache: NSCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let item: UIBarButtonItem = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("loginButtonTapped:"))
        self.navigationItem.rightBarButtonItem = item
        
        var intNum = 0
        if self.title == "Berkeley" {
            intNum = 1
        }

        let api = InstagramAPI()
        api.loadPhotos(intNum, completion: didLoadPhotos)
        
        
        print("intNum is \(intNum)")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width/2-5 , height: UIScreen.mainScreen().bounds.width/2-5)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        
        // FILL ME IN
    }

    /* 
     * IMPLEMENT ANY COLLECTION VIEW DELEGATE METHODS YOU FIND NECESSARY
     * Examples include cellForItemAtIndexPath, numberOfSections, etc.
     */
    
    func loginButtonTapped(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
        let nv = UINavigationController(rootViewController: vc)
        self.presentViewController(nv, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.tags = [indexPath.section, indexPath.row]
        if photos.count>0 {
            
            if imageCache.objectForKey(photos[indexPath.section*2+indexPath.row].url) != nil {
                cell.imageView.image = imageCache.objectForKey(photos[indexPath.section*2+indexPath.row].url) as? UIImage
            }
            else
            {
                cell.imageView.image = nil
                let photo = photos[indexPath.section*2+indexPath.row]
                
                _ = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: photo.url)!) {
                    (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    if error == nil {
                        if cell.tags == [indexPath.section,indexPath.row] {
                            dispatch_async(dispatch_get_main_queue(), {
                                cell.imageView.image = UIImage(data: data!)
                                self.imageCache.setObject(UIImage(data: data!)!, forKey: photo.url)
                                cell.setNeedsLayout()
                            })
                        }
                    }
                }.resume()
            }
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        vc.photo = photos[indexPath.section*2+indexPath.row]
        vc.image = imageCache.objectForKey(vc.photo.url) as! UIImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (photos.count)/2 ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func didLoadPhotos(photos: [Photo]) {
        self.photos = photos
        collectionView!.reloadData()
    }
    
}

class CollectionViewCell: UICollectionViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    var imageView: UIImageView!
    var tags = [0,0]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - 10))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)
    }
}

