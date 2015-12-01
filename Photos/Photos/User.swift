//
//  User.swift
//  Photos
//
//  Created by Sheng Wang on 11/25/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import Foundation


class User {
    
    var profile_url: String!
    var username : String!

    init (data: NSDictionary) {
        // FILL ME IN
        // HINT: use nested .valueForKey() calls, and then cast using 'as! TYPE'
        username = data["username"] as! String
        profile_url = data["profile_picture"] as! String
    }
}