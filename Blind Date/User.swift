//
//  User.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 8/22/17.
//  Copyright © 2017 Praveen Pendyala. All rights reserved.
//

import Foundation

struct User: Codable {
    
    // MARK: -
    // MARK: Properties
    
    private var facebookId = ""
    private var gender     = ""
    private var name       = ""
    private var profilePic = ""
    private var location   = ""
    
    
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
    
    
    // MARK: -
    // MARK: Public Methods
    
    func getFirebaseDict() -> NSDictionary {
        return [ "facebookId" : self.facebookId,
                 "gender" : self.gender,
                 "name" : self.name,
                 "profilePic" : self.profilePic,
                 "location" : self.location]
    }
}
