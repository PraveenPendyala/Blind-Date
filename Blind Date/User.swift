//
//  User.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 8/22/17.
//  Copyright © 2017 Praveen Pendyala. All rights reserved.
//

struct User: Codable {
    
    // MARK: -
    // MARK: Properties
    
    var facebookId = ""
    var gender     = ""
    var name       = ""
    var profilePic = ""
    var location   = ""
    
    
    // MARK: -
    // MARK: Init
    
    init(_ dict: [String: Any], _ postalCode: String) {
        facebookId = dict["id"] as? String ?? ""
        gender     = dict["gender"] as? String ?? ""
        name       = dict["name"] as? String ?? ""
        if let pictureDict = dict["picture"] as? [String: Any],
        let dataDict = pictureDict["data"] as? [String: Any] {
            self.profilePic = dataDict["url"] as? String ?? ""
        }
        location   = postalCode
    }
}
