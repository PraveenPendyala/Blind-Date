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
    private var postalCode      = ""
    
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
                let user = User(userData, self.postalCode)
                if let firebaseId = Auth.auth().currentUser?.uid {
                    FirebaseManager.shared.userRef.setValue(user.getFirebaseDict(), forKey: firebaseId)
                    self.performSegue(withIdentifier: "CharUserTVC", sender: self)
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
            
            if let placemarks = placemarks, placemarks.count > 0 {
                self.locationManager.stopUpdatingLocation()
                self.postalCode = placemarks[0].postalCode ?? ""
                print("Postal code updated to: \(self.postalCode)")
            }else{
                print("No placemarks found.")
            }
        })
    }
}

