//
//  StartVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 11. 26..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class StartVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor(red: 0.72, green: 0.72, blue: 0.72, alpha: 1.00)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            print("BALINT: ID found in keychain")
            logInBtn.setImage(UIImage(named: "SignOutBtn"), for: UIControlState.normal)
            label.text = Auth.auth().currentUser?.displayName
            signUpBtn.isHidden = true
            label.isHidden = false
        }
    }

    @IBAction func logInBtnTapped(_ sender: Any) {
        
        if logInBtn.currentImage == UIImage(named: "LogInBtn") {
            
            performSegue(withIdentifier: "LogInVC", sender: nil)
        } else {
            
            let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
            print("BALINT: ID removed from keychain \(keychainResult)")
            try! Auth.auth().signOut()
            logInBtn.setImage(UIImage(named: "LogInBtn"), for: UIControlState.normal)
            label.text = ""
            label.isHidden = true
            signUpBtn.isHidden = false
            
        }
    }
    @IBAction func signUpBtnTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "RegisterVC", sender: nil)
    }
}
