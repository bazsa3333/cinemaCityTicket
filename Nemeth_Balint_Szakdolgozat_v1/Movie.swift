//
//  Showing.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 01..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import Foundation

class Showing {
    
    private var _name: String!
    
    var name: String {
        
        return _name
    }
    
    init(name: String) {
        
        self._name = name
    }
}
