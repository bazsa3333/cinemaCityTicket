//
//  CustomCinemaShowingTime.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 16..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import Foundation

class CustomCinemaShowingTime {
    
    private var _hour: String!
    private var _minute: String!
    
    var hour: String {
        
        return _hour
    }
    
    var minute: String {
        
        return _minute
    }
    
    init(hour: String, minute: String) {
        
        self._hour = hour
        self._minute = minute
    }
}
