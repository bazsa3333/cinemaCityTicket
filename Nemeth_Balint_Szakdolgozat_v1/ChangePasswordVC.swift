//
//  ChangePasswordVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 04. 25..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func okBtnTapped(_ sender: Any) {
        
        guard ((oldPasswordField.text?.characters.count)! > 0) && ((newPasswordField.text?.characters.count)! > 0) else {
            let alert = UIAlertController(title: "Missing information", message: "You must enter all the informations!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

            return
        }

        if let oldPassword = oldPasswordField.text, (oldPassword.characters.count > 0) {

            if let newPassword = newPasswordField.text, (newPassword.characters.count > 0) {

                if newPassword.characters.count > 5 {

                    let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: oldPassword)

                    Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in

                        if error != nil {

                            print("RITA: Couldn't reautenticate!")
                            let alert = UIAlertController(title: "Error", message: "The password you provided to the Old Password field is wrong!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            
                            Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in

                                if error != nil {

                                    print("RITA: Something went wrong with the password renewal! \(error?.localizedDescription)")
                                } else {

                                    self.performSegue(withIdentifier: "backToStartVC", sender: nil)
                                }
                            })
                        }
                    })
                } else {

                    let alert = UIAlertController(title: "Error", message: "The lenght of your new password is needed to be 6 charachters or more!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
