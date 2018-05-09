//
//  UserCollectionViewCell.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 4/29/18.
//  Copyright © 2018 Praveen Pendyala. All rights reserved.
//

import Kingfisher

final class UserCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: -
    // MARK: IBOutlets
    
    @IBOutlet private weak var userImageView    : UIImageView!
    @IBOutlet private weak var nameLabel        : UILabel!
    @IBOutlet private weak var cityLabel        : UILabel!
    
    
    // MARK: -
    // MARK: Configure
    
    func configure(_ user: User) {
        self.nameLabel.text = user.name
        self.cityLabel.text = user.city
        let url = URL(string: user.profilePic)
        self.userImageView.kf.setImage(with: url)
    }
}
