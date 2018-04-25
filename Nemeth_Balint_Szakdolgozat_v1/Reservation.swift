//
//  Reservation.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 04. 25..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import Foundation

class Reservation {
    
    private var _name: String!
    private var _date: String!
    private var _seats: String!
    private var _cinemaName: String!
    private var _time: String!
    
    var name: String {
        
        return _name
    }
    
    var date: String {
        
        return _date
    }
    
    var seats: String {
        
        return _seats
    }
    
    var cinemaName: String {
        
        return _cinemaName
    }
    
    var time: String {
        
        return _time
    }
    
    init(name: String, date: String, seats: String, cinemaName: String, time: String) {
        
        self._name = name
        self._date = date
        self._seats = seats
        self._cinemaName = cinemaName
        self._time = time
    }
}
