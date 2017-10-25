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

    
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var checkImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func registerBtnPressed(_ sender: Any) {
        
        if let name = fullNameField.text , (name.characters.count > 0) {
            
            if let email = emailAddressField.text , (email.characters.count > 0) {
            
                if isValidEmail(testStr: email) {
                    
                    if let password = passwordField.text , (password.characters.count > 0) {
                        
                        if checkImg.image == UIImage(named: "uncheckedSign") {
                            
                            let alert = UIAlertController(title: "Terms and conditions", message: "You must accept the terms and conditions", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            
                                if error != nil {
                                
                                    let alert = UIAlertController(title: "There was a problem authenticating", message: "Try again!", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                
                                    print("RITA: Succesfully created an account")
                                
                                    if let user = user {
                                    
                                        let userData = ["provider": user.providerID,
                                                        "name": name,
                                                        "email": email]
                                        self.completeSignIn(id: user.uid, userData: userData)
                                    }
                                }
                            })
                        }
                    }
                } else {
                    
                    let alert = UIAlertController(title: "Invalid email!", message: "You entered an invalid email address", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                
                let alert = UIAlertController(title: "You must enter the email address", message: "Try again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            
            let alert = UIAlertController(title: "You must enter the name!", message: "Try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //meg kéne oldani, hogyha többször nyomom akkor ugráljon az állapotok között...
    @IBAction func checkboxPressed(_ sender: Any) {
        
        checkImg.image = UIImage(named: "checkedSign")
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        //email confirmation...
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
        
        performSegue(withIdentifier: "toResponseVC", sender: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
}
