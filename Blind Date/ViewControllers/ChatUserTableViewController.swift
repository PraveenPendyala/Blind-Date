//
//  ChatUserTableViewController.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 9/4/17.
//  Copyright © 2017 Praveen Pendyala. All rights reserved.
//

import UIKit
import FirebaseAuth
class ChatUserTableViewController: UIViewController {
    
    
    // MARK: -
    // MARK: Properties
    
    private var users                             = [User]()
    
    
    // MARK: -
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: -
    // MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeUsers()
        self.tableView.register( UINib(nibName: "ChatUserTableViewCell", bundle: nil),
                        forCellReuseIdentifier: "ChatUserTableViewCell")
    }
    
    // MARK: -
    // MARK: Private Methods
    
    private func observeUsers() {
        let userId = Auth.auth().currentUser!.uid
        FirebaseManager.shared.messagesRef.queryOrdered(byChild: "users/\(userId)").queryEqual(toValue: true).observe(.childAdded) { (snapshot) in
            if let userData = snapshot.value as? [String: Any] {
                print("\(userData)")
            }
        }
    }
}


// MARK: -
// MARK: -

extension ChatUserTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserTableViewCell", for: indexPath)
        return cell
    }
}
