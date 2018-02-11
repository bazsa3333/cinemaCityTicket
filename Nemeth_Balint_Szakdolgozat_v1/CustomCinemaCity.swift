//
//  CustomCinemaCity.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 10..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import Foundation

class CustomCinemaCity {
    
    private var _name: String!
    
    var name: String {
        
        return _name
    }
    
    init(name: String) {
        
        self._name = name
    }
}
