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
    
    private var city         = ""
    private var country      = ""
    private var facebookId   = ""
    private var gender       = ""
    private var interestedIn = ""
    private var name         = ""
    private var profilePic   = ""
    private var state        = ""
    private var zip          = ""
    
    
    // MARK: -
    // MARK: Init
    
    init(_ dict: [String: Any]) {
        facebookId = dict["id"] as? String ?? ""
        gender     = dict["gender"] as? String ?? ""
        name       = dict["name"] as? String ?? ""
        if let pictureDict = dict["picture"] as? [String: Any],
        let dataDict = pictureDict["data"] as? [String: Any] {
            self.profilePic = dataDict["url"] as? String ?? ""
        }
    }
    
    
    // MARK: -
    // MARK: Public Methods
    
    func getFirebaseDict() -> [AnyHashable: Any] {
        return ["facebookId" : self.facebookId,
                    "gender" : self.gender,
                      "name" : self.name,
                "profilePic" : self.profilePic]
    }
}
