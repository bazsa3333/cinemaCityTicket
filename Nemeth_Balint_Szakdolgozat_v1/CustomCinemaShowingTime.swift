//
//  CustomCinemaShowingTime.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 16..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import Foundation

class CustomCinemaShowingTime {
    
    private var _time: String!
    
    var time: String {
        
        return _time
    }
    
    init(time: String) {
        
        self._time = time
    }
}
