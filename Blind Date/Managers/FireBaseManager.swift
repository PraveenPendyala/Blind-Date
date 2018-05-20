//
//  FireBaseManager.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 11/4/17.
//  Copyright © 2017 Praveen Pendyala. All rights reserved.
//

import Firebase

final class FirebaseManager {
    

    // MARK: -
    // MARK: Properties
    
    private static var sharedInstance : FirebaseManager?
    static var shared : FirebaseManager {
        if ( sharedInstance != nil) { }
        else { sharedInstance = FirebaseManager() }
        return sharedInstance!
    }
    
    let userRef       = Database.database().reference().child("users")
    let messagesRef   = Database.database().reference().child("messages")
    
    // MARK: -
    // MARK: Init
    
    private init() {
        userRef.keepSynced(true)
    }
    
    
    // MARK: -
    // MARK: Dispose
    
    static func dispose() {
        FirebaseManager.shared.userRef.removeAllObservers()
        FirebaseManager.sharedInstance = nil
    }
}
