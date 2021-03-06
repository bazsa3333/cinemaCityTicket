//
//  Cinema.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 01..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import Foundation

class Cinema {
    
    private var _name: String!
    private var _pos: Int!
    
    var name: String {
        
        return _name
    }
    
    var pos: Int {
        
        return _pos
    }
    
    init(name: String, pos: Int) {
        
        self._name = name
        self._pos = pos
    }
}
