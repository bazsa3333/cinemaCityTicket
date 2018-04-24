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
    @IBOutlet weak var recommendationBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendationBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            print("BALINT: ID found in keychain")
            logInBtn.setImage(UIImage(named: "SignOutBtn"), for: UIControlState.normal)
            label.text = Auth.auth().currentUser?.displayName
            signUpBtn.isHidden = true
            recommendationBtn.isHidden = false
            label.isHidden = false
            profileBtn.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
            recommendationBtn.isHidden = true
            profileBtn.isHidden = true
            
        }
    }
    @IBAction func signUpBtnTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "RegisterVC", sender: nil)
    }
    @IBAction func comingSoonBtnTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "comingSoonVC", sender: nil)
    }
    @IBAction func recommendationBtnTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "recommendationVC", sender: nil)
    }
    
    @IBAction func databaseBtnTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "databaseVC", sender: nil)
    }
    
    @IBAction func profileBtnTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "profileVC", sender: nil)
    }
}
