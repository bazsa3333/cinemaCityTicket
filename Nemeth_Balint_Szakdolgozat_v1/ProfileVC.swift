//
//  ProfileVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 04. 25..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = Auth.auth().currentUser?.displayName
        emailLbl.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func reservationsBtnTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "reservationsVC", sender: nil)
    }
    @IBAction func editProfileBtnTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "editProfileVC", sender: nil)
    }
    
    @IBAction func changePasswordBtnTapped(_ sender: Any) {
        
        let ref = DataService.ds.REF_USERS
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for user in snapshot.children.allObjects as! [DataSnapshot] {
                
                
                if user.key == Auth.auth().currentUser?.uid {
                    
                    let userObject = user.value as? [String: AnyObject]
                    let provider = userObject?["provider"] as? String
                    
                    if provider == "facebook.com" {
                        
                        let alert = UIAlertController(title: "Error", message: "You cannot change Facebook provided account's password!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {

                        self.toChangePasswordVC()
                    }
                    
                }
            }
        })
    }
    
    func toChangePasswordVC() {
        
        performSegue(withIdentifier: "changePasswordVC", sender: nil)
    }
}
