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
    
    private var users = [User]()
    
    // MARK: -
    // MARK: IBOutlets
    
    @IBOutlet private weak var usersCollectionView: UICollectionView!
    
    
    // MARK: -
    // MARK: IBActions
    
    @IBAction func previousButtonTapped(_ sender: Any) {
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    
    // MARK: -
    // MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usersCollectionView.delegate   = self
        self.usersCollectionView.dataSource = self
        self.usersCollectionView.register(UINib(nibName: "UserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserCollectionViewCell")
        FirebaseManager.shared.userRef.obs
    }
}


// MARK: -
// MARK: UICollectionView Datasource & Delegate

extension UsersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        return cell
    }
}
