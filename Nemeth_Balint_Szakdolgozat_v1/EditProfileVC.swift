//
//  EditProfileVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 04. 25..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class EditProfileVC: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func deleteBtnTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "If you delete your account all of your history's going to be lost.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            
            if let password = self.passwordField.text, (password.characters.count > 0) {
                
                let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: password)
                Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
                    
                    if error != nil {
                        
                        print("RITA: Couldn't reautenticate!")
                        let alert = UIAlertController(title: "Error", message: (error?.localizedDescription)!, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let currentUserId = Auth.auth().currentUser?.uid
                        Auth.auth().currentUser?.delete(completion: { (error) in
                            
                            if error != nil {
                                
                                print("RITA: Something went worng with deleting the account!")
                            } else {
                                
                                let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
                                print("BALINT: ID removed from keychain \(keychainResult)")
                                let ref = DataService.ds.REF_USERS.child(currentUserId!)
                                ref.removeValue()
                                self.performSegue(withIdentifier: "backToStartVC", sender: nil)
                            }
                        })
                    }
                })
            } else {
                
                let alert = UIAlertController(title: "Missing information", message: "Provide your password to delete the account!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func okBtnTapped(_ sender: Any) {
        
        guard ((firstNameField.text?.characters.count)! > 0) && ((emailField.text?.characters.count)! > 0) && ((lastNameField.text?.characters.count)! > 0) && ((passwordField.text?.characters.count)! > 0) else {
            let alert = UIAlertController(title: "Missing information", message: "You must enter all the informations!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if let firstName = firstNameField.text, (firstName.characters.count > 0) {
            
            if let lastName = lastNameField.text, (lastName.characters.count > 0) {
                
                if let email = emailField.text, (email.characters.count > 0) {
                    
                    if let password = passwordField.text, (password.characters.count > 0) {
                        
                        let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: password)
                        
                        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
                            
                            if error != nil {
                                
                                print("RITA: Couldn't reautenticate!")
                                let alert = UIAlertController(title: "Error", message: (error?.localizedDescription)!, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                
                                Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                                    
                                    if error != nil {
                                        
                                        print("RITA: Something went wrong with the email renewal! \(error?.localizedDescription)")
                                    } else {
                                        
                                        let ref = DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!)
                                        ref.child("name").setValue(firstName + " " + lastName)
                                        ref.child("email").setValue(email)
                                        
                                        let chageRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                        chageRequest?.displayName = firstName + " " + lastName
                                        chageRequest?.commitChanges(completion: { (error) in
                                            if error != nil {
                                                
                                                print("RITA: Something occured, when changing the display name")
                                            } else {
                                                
                                                print("RITA: DisplayName is updated")
                                                self.performSegue(withIdentifier: "backToStartVC", sender: nil)
                                            }
                                        })
                                    }
                                }
                            }
                            
                        })
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
