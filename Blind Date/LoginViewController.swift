//
//  LoginViewController.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 7/8/17.
//  Copyright © 2017 Praveen Pendyala. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

final class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        loginButton.delegate = self
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: -
// MARK: FBSDKLoginButtonDelegate

extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        else {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error)
                    return
                }
                // User is signed in
                // ...
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
}

