//
//  Photo.swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import Foundation

class Photo {
    /* The number of likes the photo has. */
    var likes : Int!
    /* The string of the url to the photo file. */
    var url : String!
    var url2: String!
    /* The username of the photographer. */
    var username : String!
    var date: String!

    /* Parses a NSDictionary and creates a photo object. */
    init (data: NSDictionary) {
        // FILL ME IN
        // HINT: use nested .valueForKey() calls, and then cast using 'as! TYPE'
        likes = data["likes"]!["count"] as! Int
        url = data["images"]!["thumbnail"]!!["url"] as! String
        url2 = data["images"]!["low_resolution"]!!["url"] as! String
        username = data["user"]!["username"] as! String
        date = data["created_time"] as! String
    }

}