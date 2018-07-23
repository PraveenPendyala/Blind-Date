//
//  UsersViewController.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 4/25/18.
//  Copyright © 2018 Praveen Pendyala. All rights reserved.
//

import UIKit

final class UsersViewController: UIViewController {
    
    
    // MARK: -
    // MARK: Properties
    
    private var users        = [User]()
    private var currentIndex = 0
    
    // MARK: -
    // MARK: IBOutlets
    
    @IBOutlet private weak var usersCollectionView: UICollectionView!
    
    
    // MARK: -
    // MARK: IBActions
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        if currentIndex > 0 {
            currentIndex -= 1
            self.usersCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0),
                                                  at: .centeredHorizontally,
                                            animated: true)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if currentIndex < self.users.count - 1 {
            currentIndex += 1
            self.usersCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0),
                                                  at: .centeredHorizontally,
                                            animated: true)
        }
    }
    
    
    // MARK: -
    // MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usersCollectionView.delegate        = self
        self.usersCollectionView.dataSource      = self
        self.usersCollectionView.register(UINib(nibName: "UserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserCollectionViewCell")
        FirebaseManager.shared.userRef.observe(.value) { (data) in
            if let users = data.value as? [String: [String: Any]] {
                self.users = users.map({ User($0.value, $0.key) })
                self.usersCollectionView.reloadData()
            }
        }
    }
}


// MARK: -
// MARK: UICollectionView Datasource & Delegate

extension UsersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        cell.configure(self.users[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}


// MARK: -
// MARK: Storyboard Initializable

extension UsersViewController: StoryboardInitializable {
    static func instantiateFromStoryboard() -> UsersViewController {
        return Storyboards.Main.instantiateViewController(withIdentifier: "UsersViewController") as! UsersViewController
    }
}


// MARK: -
// MARK: UserCollectionViewCellDelegate

extension UsersViewController: UserCollectionViewCellDelegate {
    func startConversationWith(_ convoId: String) {
        let dataSource = DemoChatDataSource(convoId, pageSize: 50)
        let chatVC = DemoChatViewController()
        chatVC.dataSource = dataSource
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
