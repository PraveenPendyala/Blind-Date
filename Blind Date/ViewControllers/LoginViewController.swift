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
import CoreLocation

final class LoginViewController: UIViewController {

    
    // MARK: -
    // MARK: Properties
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
                self.getFBUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        FirebaseManager.dispose()
    }
    
    private func getFBUserData() {
        // Create request for user's Facebook data
        let parameters = ["fields": "id, gender, name, picture"]
        let request    = FBSDKGraphRequest(graphPath:"me", parameters:parameters)
        let connection = FBSDKGraphRequestConnection()
        connection.add(request) { (connection, result, error) in
            if error != nil {
                // Some error checking here
            }
            else if let userData = result as? [String:Any] {
                let user = User(userData)
                if let firebaseId = Auth.auth().currentUser?.uid {
                    FirebaseManager.shared.userRef.child("\(firebaseId)").updateChildValues(user.getFirebaseDict())
                    self.performSegue(withIdentifier: "ChatUserTVC", sender: self)
                }
            }
        }
        connection.start()
    }
}


// MARK: -
// MARK: CLLocationManager Delegate

extension LoginViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)-> Void in
            if error != nil {
                print("Reverse geocoder failed with error: \(error?.localizedDescription ?? "")")
                return
            }
            
            if let placemark = placemarks?.first, let firebaseId = Auth.auth().currentUser?.uid {
                FirebaseManager.shared.userRef.child("\(firebaseId)").updateChildValues(placemark.getFirebaseDict())
            }else{
                print("No placemarks found.")
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

