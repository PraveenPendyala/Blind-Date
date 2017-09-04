//
//  ChatUserTableViewController.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 9/4/17.
//  Copyright © 2017 Praveen Pendyala. All rights reserved.
//

import UIKit
import Firebase

class ChatUserTableViewController: UIViewController {
    
    
    // MARK: -
    // MARK: Properties
    
    private lazy var userRef  : DatabaseReference = Database.database().reference().child("users")
    private var userRefHandle : DatabaseHandle?
    private var users                             = [User]()
    
    
    // MARK: -
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: -
    // MARK: Private Methods
    
    private func observeUsers() {
        userRefHandle = userRef.observe(.childAdded, with: { (snapshot) in
            if let userData = snapshot.value as? [String: Any] {
                self.users.append(User(dict: userData))
                self.tableView.reloadData()
            }else {
                print("Error! Could not decode user data")
            }
        })
    }
    
}
