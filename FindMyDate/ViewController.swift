//
//  ViewController.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-05-25.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    var fbLoginSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 250, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
//        if (FBSDKAccessToken.current()) != nil {
//            // User is logged in, use 'accessToken' here.
//            performSegue(withIdentifier: "loginSegue", sender: nil)
//        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        else{
            print(result)
            fbLoginSuccess = true
        }
        
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true)
        {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                if error != nil {
                    print("Something went wrong with our fb user", error ?? "")
                    return
                }
            }

            performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
}

