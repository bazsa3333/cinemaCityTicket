//
//  Showing.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 03..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import Foundation

class Showing {
    
    private var _date: String!
    private var _time: String!
    
    var date: String {
        
        return _date
    }
    
    var time: String {
        
        return _time
    }
    
    init(date: String, time: String) {
        
        self._date = date
        self._time = time
    }
}
