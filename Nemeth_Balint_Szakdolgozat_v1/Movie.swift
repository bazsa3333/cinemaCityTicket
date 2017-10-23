//
//  Showing.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 01..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import Foundation

class Movie {
    
    private var _name: String!
    private var _moviePos: Int!
    private var _cinemaPos: Int!
    
    var name: String {
        
        return _name
    }
    
    var moviePos: Int {
        
        return _moviePos
    }
    
    var cinemaPos: Int {
        
        return _cinemaPos
    }
    
    init(name: String, moviePos: Int, cinemaPos: Int) {
        
        self._name = name
        self._moviePos = moviePos
        self._cinemaPos = cinemaPos
    }
}
