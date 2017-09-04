//
//  User.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 8/22/17.
//  Copyright © 2017 Praveen Pendyala. All rights reserved.
//

class User {
    
    // MARK: -
    // MARK: Properties
    
    var facebookId = ""
    var gender     = ""
    var name       = ""
    var profilePic = ""
    var location   = ""
    
    
    // MARK: -
    // MARK: Init
    
    init(dict: [String: Any]) {
        facebookId = dict["facebookId"] as? String ?? ""
        gender     = dict["gender"] as? String ?? ""
        name       = dict["name"] as? String ?? ""
        profilePic = dict["profilePic"] as? String ?? ""
        location   = dict["location"] as? String ?? ""
    }
}
