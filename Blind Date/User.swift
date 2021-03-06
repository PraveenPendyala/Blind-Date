//
//  User.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 8/22/17.
//  Copyright © 2017 Praveen Pendyala. All rights reserved.
//

import Foundation
import FBSDKCoreKit

struct User: Codable {
    
    // MARK: -
    // MARK: Properties
    
    var city                 = ""
    private var country      = ""
    var facebookId           = ""
    private var gender       = ""
    private var interestedIn = ""
    var name                 = ""
    var profilePic           = ""
    private var state        = ""
    private var zip          = ""
    var id                   = ""
    
    
    // MARK: -
    // MARK: Init
    
    init(_ fbProfile: FBSDKProfile) {
        facebookId = fbProfile.userID
        name       = fbProfile.name
        profilePic = fbProfile.imageURL(for: FBSDKProfilePictureMode.normal, size: UIScreen.main.bounds.size).absoluteString
    }
    
    init(_ dict: [String: Any], _ id: String = "") {
        self.city       = dict["city"] as? String ?? ""
        self.name       = dict["name"] as? String ?? ""
        self.profilePic = dict["profilePic"] as? String ?? ""
        self.facebookId = dict["facebookId"] as? String ?? ""
        self.id         = id
    }
    
    
    // MARK: -
    // MARK: Public Methods
    
    func getFirebaseDict() -> [AnyHashable: Any] {
        return ["facebookId" : self.facebookId,
                      "name" : self.name,
                "profilePic" : self.profilePic]
    }
}
