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
    
    private var users                             = [ChatUserTableViewModel]()
    
    
    // MARK: -
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: -
    // MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeUsers()
        self.tableView.dataSource       = self
        self.tableView.delegate         = self
        self.tableView.tableFooterView  = UIView()
        self.tableView.register( UINib(nibName: "ChatUserTableViewCell", bundle: nil),
                        forCellReuseIdentifier: "ChatUserTableViewCell")
    }
    
    // MARK: -
    // MARK: Private Methods
    
    private func observeUsers() {
        let userId = Auth.auth().currentUser!.uid
        FirebaseManager.shared.userRef.child("\(userId)/conversations").observe(.value) { (snapshot) in
            if let convo = snapshot.value as? [String:Any] {
                self.users = convo.map({ ChatUserTableViewModel($0.key) })
                self.tableView.reloadData()
            }
        }
    }
}


// MARK: -
// MARK: -

extension ChatUserTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserTableViewCell", for: indexPath) as! ChatUserTableViewCell
        cell.configure(self.users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource = DemoChatDataSource(self.users[indexPath.row].convoId, pageSize: 50)
        let chatVC = DemoChatViewController()
        chatVC.title      = self.users[indexPath.row].userName
        chatVC.dataSource = dataSource
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
