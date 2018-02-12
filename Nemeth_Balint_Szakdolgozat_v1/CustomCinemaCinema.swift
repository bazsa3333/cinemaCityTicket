//
//  CustomCinemaCinema.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 11..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import Foundation

class CustomCinemaCinema {
    
    private var _name: String!
    private var _id: String!
    
    var name: String {
        
        return _name
    }
    
    var id: String {
        
        return _id
    }
    
    init(name: String, id: String) {
        
        self._name = name
        self._id = id
    }
}
