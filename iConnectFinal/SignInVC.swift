//
//  ViewController.swift
//  iConnectFinal
//
//  Created by Lingeswaran Kandasamy on 5/27/17.
//  Copyright © 2017 Lingeswaran Kandasamy. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookButtonTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self){ (result, error) in
            if error != nil {
            print("LIN: unable to login Facebook")
            } else if result?.isCancelled == true {
                print("Lin: User Cancelled")
            } else{
                print("Lin: Succcessfully Authenticated Facebook")
                let credintials = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credintials)
            }
        
        }
        
        
    }
    func firebaseAuth(_ credentials: AuthCredential){
        Auth.auth().signIn(with: credentials, completion: { (user, Error)in
            if Error != nil {
                print ("LIN: Unable to Authenticate with firwbase- \(String(describing: Error))")
    
            }else {
                print ("LIN: Successfully Authenticate with firebase")
            }
        })
    }
}

