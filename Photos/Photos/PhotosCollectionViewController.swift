//
//  PhotosCollectionViewController.swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    var photos: [Photo]? = []
    var images: [String: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let api = InstagramAPI()
        api.loadPhotos(didLoadPhotos)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 170, height: 170)
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
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.tags = [indexPath.section, indexPath.row]
        cell.imageView.image = nil
        if photos!.count>0 {
            if ((images.keys.contains(photos![indexPath.section*2+indexPath.row].url)) != false) {
                cell.imageView.image = images[photos![indexPath.section*2+indexPath.row].url]
            }
            else
            {
                let photo = photos![indexPath.section*2+indexPath.row] 
                _ = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: photo.url)!) {
                    (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    if error == nil {
                        if cell.tags == [indexPath.section,indexPath.row] {
                            dispatch_async(dispatch_get_main_queue(), {
                                cell.imageView.image = UIImage(data: data!)
                                self.images[photo.url] = UIImage(data: data!)
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
        vc.photo = photos![indexPath.section*2+indexPath.row]
        vc.image = images[vc.photo.url]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (photos?.count)!/2 ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    /* Creates a session from a photo's url to download data to instantiate a UIImage. 
       It then sets this as the imageView's image. */
    func loadImageForCell(photo: Photo, imageView: UIImageView, cell: CollectionViewCell, indexPath: NSIndexPath) {
        _ = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: photo.url)!) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                if cell.tags == [indexPath.section,indexPath.row] {
                    imageView.image = UIImage(data: data!)
                    self.images[photo.url] = UIImage(data: data!)
                    cell.setNeedsLayout()
                }
            }
        }.resume()
    }
    
    /* Completion handler for API call. DO NOT CHANGE */
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

