//
//  UserCollectionViewCell.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 4/29/18.
//  Copyright © 2018 Praveen Pendyala. All rights reserved.
//

import Kingfisher
import FirebaseAuth

protocol UserCollectionViewCellDelegate: NSObjectProtocol {
    func startConversationWith(_ convoId: String, _ user: User)
}

final class UserCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: -
    // MARK: Properties
    
    private var user    : User?
    weak var delegate   : UserCollectionViewCellDelegate?
    
    
    // MARK: -
    // MARK: IBOutlets
    
    @IBOutlet private weak var userImageView    : UIImageView!
    @IBOutlet private weak var nameLabel        : UILabel!
    @IBOutlet private weak var cityLabel        : UILabel!
    @IBOutlet private weak var chatButton       : UIButton!
    
    
    // MARK: -
    // MARK: IBActions
    
    @IBAction func chatButtonPressed(_ sender: Any) {
        FirebaseManager.shared.userRef.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String: Any], let otherUser = self.user {
                let currentUser     = User(data, Auth.auth().currentUser!.uid)
                self.createConversation(currentUser, otherUser)
            }
        }
    }
    
    // MARK: -
    // MARK: Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.chatButton.layer.cornerRadius = self.chatButton.frame.width/2
        self.chatButton.clipsToBounds      = true
    }
    
    // MARK: -
    // MARK: Public Methods
    
    func configure(_ user: User) {
        self.user           = user
        self.nameLabel.text = user.name
        self.cityLabel.text = user.city
        let url = URL(string: user.profilePic)
        self.userImageView.kf.indicatorType = .activity
        self.userImageView.kf.setImage(with: url)
    }
    
    
    // MARK: -
    // MARK: Private Methods
    
    private func createConversation(_ currentUser: User, _ otherUser: User) {
        let currentUserFBId = Double(currentUser.facebookId) ?? 0
        let otherUserFBId   = Double(otherUser.facebookId) ?? 0
        var convoId         = "\(Auth.auth().currentUser!.uid)_\(otherUser.id)"
        if otherUserFBId < currentUserFBId {
            convoId         = "\(otherUser.id)_\(Auth.auth().currentUser!.uid)"
        }
        FirebaseManager.shared.userRef.child("\(currentUser.id)/conversations/\(convoId)").setValue(true)
        FirebaseManager.shared.userRef.child("\(otherUser.id)/conversations/\(convoId)").setValue(true)
        delegate?.startConversationWith(convoId, otherUser)
    }
}
