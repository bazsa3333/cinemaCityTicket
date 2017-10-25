//
//  ResponseVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 23..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class ResponseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutBtnTapped(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("BALINT: ID removed from keychain \(keychainResult)")
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }

}
