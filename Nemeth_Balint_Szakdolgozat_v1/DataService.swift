//
//  DataService.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 23..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

//URL of the database - reference - u can find it in the gooleservice-info.plist
let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    //create the singelton - everyone has access to it
    static let ds = DataService()
    
    //DB references
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_CITIES = DB_BASE.child("cities")
    private var _REF_CINEMAS = DB_BASE.child("cinemas")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_CITIES: DatabaseReference {
        
        return _REF_CITIES
    }
    
    var REF_CINEMAS: DatabaseReference {
        
        return _REF_CINEMAS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
