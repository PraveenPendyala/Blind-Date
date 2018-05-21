//
//  ChatUserTableViewModel.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 5/20/18.
//  Copyright © 2018 Praveen Pendyala. All rights reserved.
//

import FirebaseAuth

final class ChatUserTableViewModel: NSObject, ChatUserTableViewCellDatasource {
    
    
    // MARK: -
    // MARK: Properties
    
    var convoId     = ""
    var userName    = ""
    var pictureUrl  = ""
    
    
    // MARK: -
    // MARK: Init
    
    init(_ convoId: String) {
        self.convoId = convoId
    }
    
    
    // MARK: -
    // MARK: Public Methods
    
    func loadUserInfo(_ completion: @escaping () -> Void) {
        if !self.userName.isEmpty { return }
        let users = convoId.components(separatedBy: "_")
        let authId = Auth.auth().currentUser!.uid
        for id in users {
            if id != authId {
                FirebaseManager.shared.userRef.child(id).observeSingleEvent(of: .value) { (snapshot) in
                    if let userDict = snapshot.value as? [String:Any] {
                        let user = User(userDict)
                        self.userName   = user.name
                        self.pictureUrl = user.profilePic
                        completion()
                    }
                }
                return
            }
        }
    }
}
