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
    private var facebookId   = ""
    private var gender       = ""
    private var interestedIn = ""
    var name                 = ""
    private var profilePic   = ""
    private var state        = ""
    private var zip          = ""
    
    
    // MARK: -
    // MARK: Init
    
    init(_ fbProfile: FBSDKProfile) {
        facebookId = fbProfile.userID
        name       = fbProfile.name
        profilePic = fbProfile.imageURL(for: FBSDKProfilePictureMode.normal, size: UIScreen.main.bounds.size).absoluteString
    }
    
    
    // MARK: -
    // MARK: Public Methods
    
    func getFirebaseDict() -> [AnyHashable: Any] {
        return ["facebookId" : self.facebookId,
                      "name" : self.name,
                "profilePic" : self.profilePic]
    }
}
