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
    
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            print("BALINT: ID found in keychain")
            performSegue(withIdentifier: "ResponseVC", sender: nil)
        }
    }
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                
                print("BALINT: Unable to authenticate with Facebook")
            }else if result?.isCancelled == true {
                
                print("BALINT: User cancelled Facebook authentication")
            }else {
                
                print("BALINT: Succesfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if error != nil {
                
                print("BALINT: Unable to authenticate with Firebase")
            }else {
                
                print("BALINT: Succesfully authenticated with Firebase")
                
                if let user = user {
                    
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("BALINT Data saved to keychainresult: \(keychainResult)")
        
        performSegue(withIdentifier: "ResponseVC", sender: nil)
    }
    

}
