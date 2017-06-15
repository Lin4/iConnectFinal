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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    @IBOutlet weak var txtEmail: FancyTextFields!
    @IBOutlet weak var txtPassword: FancyTextFields!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.hideKeyboardWhenTappedAround()
    }
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "KEY_UID"){
            performSegue(withIdentifier: "gotoFeed", sender: nil)
        }
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
                if let user = user{
                    let userData = ["provider": credentials.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        
        if let email = txtEmail.text, let pwd = txtPassword.text {
            
            Auth.auth().signIn(withEmail: email, password: pwd) { (user, error) in
                            if error == nil {
                    print("Lin: EmailUser authenticated with Firebase")
                                if let user = user{
                                    let userData = ["provider": user.providerID]
                                    self.completeSignIn(id: (user.uid), userData: userData)
                                }

                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd) { (user, error) in
                        if error != nil {
                            print("Lin: unable to EmailUser authenticated with Firebase")
                        } else {
                            print("Lin: Authentication Success" )
                            if let user = user{
                            let userData = ["provider": user.providerID]
                            self.completeSignIn(id: (user.uid), userData: userData)
                            }
                        
                        }
                    }
                }
            }
        }
        
    }
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
            DataServices.ds.createFirebaseDBUser(uid: id, userDate: userData)
           //let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
            let keychainResult = KeychainWrapper.standard.set("Some String", forKey: "KEY_UID")
            print("Lin : Data saved to key chain \(keychainResult)")
            performSegue(withIdentifier: "gotoFeed", sender: nil)
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
