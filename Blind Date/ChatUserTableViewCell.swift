//
//  ChatUserTableViewCell.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 9/4/17.
//  Copyright © 2017 Praveen Pendyala. All rights reserved.
//

import UIKit

protocol ChatUserTableViewCellDatasource: NSObjectProtocol {
    var convoId     : String { get }
    var userName    : String { get }
    var pictureUrl  : String { get }
    func loadUserInfo(_ completion: @escaping () -> Void)
}

class ChatUserTableViewCell: UITableViewCell {
    
    
    // MARK: -
    // MARK: Properties
    
    weak var delegate: ChatUserTableViewCellDatasource?
    
    
    // MARK: -
    // MARK: Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.layer.cornerRadius   = self.userImageView.frame.height/2
        self.userImageView.clipsToBounds        = true
    }
    
    // MARK: -
    // MARK: IBOutlets
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    
    
    // MARK: -
    // MARK: Public Methods
    
    func configure(_ datasource: ChatUserTableViewCellDatasource) {
        self.delegate = datasource
        self.userImageView.kf.indicatorType = .activity
        self.loadUI()
        datasource.loadUserInfo {
            self.loadUI()
        }
    }
    
    
    // MARK: -
    // MARK: Private Methods
    
    private func loadUI() {
        let url = URL(string: self.delegate?.pictureUrl ?? "")
        self.userImageView.kf.setImage(with: url)
        self.userNameLabel.text = self.delegate?.userName
    }
}
