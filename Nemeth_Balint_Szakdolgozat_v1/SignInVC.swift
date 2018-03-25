//
//  SignInVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 23..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        
//        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
//            
//            print("BALINT: ID found in keychain")
//            performSegue(withIdentifier: "ResponseVC", sender: nil)
//        }
    }
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                
                print("BALINT: Unable to authenticate with Facebook")
            } else if result?.isCancelled == true {
                
                print("BALINT: User cancelled Facebook authentication")
            } else {
                
                print("BALINT: Succesfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    @IBAction func logInBtnTapped(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text , (email.characters.count > 0 && password.characters.count > 0) {
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    
                    print("RITA: Email user authenticated with Firebase")
                    
                    if let user = user {
                        
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                        
                        if errorCode == AuthErrorCode.userNotFound {
                            
                            let alert = UIAlertController(title: "User not found", message: "You can register if you don't have an account", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else if errorCode == AuthErrorCode.wrongPassword {
                            
                            let alert = UIAlertController(title: "Password is incorrect!", message: "You must enter the right password", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            
                            let alert = UIAlertController(title: "There was a problem authenticating", message: "Try again!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                }
            })
        } else {
            
            let alert = UIAlertController(title: "Username and Password is required!", message: "You must enter both to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func firebaseAuth(_ credential: AuthCredential) {
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                
                print("BALINT: Unable to authenticate with Firebase")
            } else {
                
                print("BALINT: Succesfully authenticated with Firebase")
                
                if let user = user {
                    
                    let userData = ["provider": credential.provider,
                                    "name": Auth.auth().currentUser?.displayName,
                                    "email": Auth.auth().currentUser?.email]
                    self.completeSignIn(id: user.uid, userData: userData as! Dictionary<String, String>)
                }
                
            }
        })
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        let email = Auth.auth().currentUser!.email
        
        print("BALINT Data saved to keychainresult: \(keychainResult)")
        
        print(email!)
        performSegue(withIdentifier: "backToStartVC", sender: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
