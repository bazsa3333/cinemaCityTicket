//
//  guestUserRegistrationVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 04. 24..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class guestUserRegistrationVC: UIViewController {

    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var checkImg: CheckBox!
    
    var time: CustomCinemaShowingTime?
    var seatLimit: Int?
    var userData: Dictionary<String, AnyObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func okBtnTapped(_ sender: Any) {
        
        guard ((firstNameField.text?.characters.count)! > 0) && ((lastNameField.text?.characters.count)! > 0) && ((emailField.text?.characters.count)! > 0) else {
            
            let alert = UIAlertController(title: "Missing information", message: "You must enter all the informations!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if let firstName = firstNameField.text , (firstName.characters.count > 0) {
            if let lastName = lastNameField.text, (lastName.characters.count > 0) {
                if let email = emailField.text , (email.characters.count > 0) {
                    
                            
                    if checkImg.isChecked == false {
                        
                        let alert = UIAlertController(title: "Terms and conditions", message: "You must accept the terms and conditions", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        
                        let uuid = UUID().uuidString
                        self.userData = ["name": (firstName + " " + lastName as AnyObject),
                                         "email": email as AnyObject]
                        
                        performSegue(withIdentifier: "SeatSelectorVC", sender: time)
                        
                    }
                            
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SeatSelectorVC" {
            
            if let seatSelectorVC = segue.destination as? SeatSelectorVC {
                
                if let time = sender as? CustomCinemaShowingTime {
                    
                    seatSelectorVC.time = time
                    seatSelectorVC.seatLimit = self.seatLimit
                    seatSelectorVC.userData = self.userData
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
