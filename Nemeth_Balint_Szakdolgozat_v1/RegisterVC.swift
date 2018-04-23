//
//  RegisterVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 24..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class RegisterVC: UIViewController {

    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var checkImg: CheckBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func registerBtnPressed(_ sender: Any) {
        
        guard ((firstNameField.text?.characters.count)! > 0) && ((lastNameField.text?.characters.count)! > 0) && ((emailAddressField.text?.characters.count)! > 0) && ((passwordField.text?.characters.count)! > 0) else {
            let alert = UIAlertController(title: "Missing information", message: "You must enter all the informations!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if let firstName = firstNameField.text , (firstName.characters.count > 0) {
            if let lastName = lastNameField.text, (lastName.characters.count > 0) {
                if let email = emailAddressField.text , (email.characters.count > 0) {
            
                    if let password = passwordField.text {
                        
                        if password.characters.count > 5 {
                
                            if checkImg.isChecked == false {
                                
                                let alert = UIAlertController(title: "Terms and conditions", message: "You must accept the terms and conditions", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                
                                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                                    
                                    if error != nil {
                                    
                                        let alert = UIAlertController(title: "There was a problem authenticating", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    } else {
                                    
                                        print("RITA: Succesfully created an account")
                                    
                                        if let user = user {
                                    
                                            let userData = ["provider": user.providerID,
                                                            "name": (firstName + " " + lastName),
                                                            "email": email]
                                            self.completeSignIn(id: user.uid, userData: userData)
                                        }
                                    }
                                })
                            }
                            
                        } else {
                            
                            let alert = UIAlertController(title: "Error", message: "The lenght of your password is needed to be 6 charachters or more!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let chageRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        chageRequest?.displayName = userData["name"]
        chageRequest?.commitChanges(completion: { (error) in
            if error != nil {
                
                print("RITA: Something occured, when changing the display name")
            } else {
                
                print("RITA: DisplayName is updated")
            }
        })
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
//        email confirmation...
//        let user = Auth.auth().currentUser
//        user?.sendEmailVerification(completion: { (error) in
//
//            if (error != nil) {
//
//                print("BALINT: Error occured sending the verification email")
//            } else {
//
//                print("BALINT: Email was sent succesfully")
//            }
//        })
        
        print("BALINT Data saved to keychainresult: \(keychainResult)")
        
        performSegue(withIdentifier: "StartVC", sender: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
