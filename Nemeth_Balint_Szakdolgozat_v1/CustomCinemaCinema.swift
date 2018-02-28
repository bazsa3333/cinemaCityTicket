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
    private var _ids = [String]()
    
    var name: String {
        
        return _name
    }
    
    var ids: [String] {
        
        return _ids
    }
    
    init(name: String, ids: [String]) {
        
        self._name = name
        self._ids = ids
    }
}
