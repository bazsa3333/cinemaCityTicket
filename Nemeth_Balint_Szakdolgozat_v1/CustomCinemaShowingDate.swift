//
//  CustomCinemaShowing.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 15..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import Foundation

class CustomCinemaShowingDate {
    
    private var _date: String!
    private var _movieId: String!
    private var _dateId: String!
    private var _cinameName: String!
    
    var date: String {
        
        return _date
    }
    
    var movieId: String {
        
        return _movieId
    }
    
    var dateId: String {
        
        return _dateId
    }
    
    var cinemaName: String {
        
        return _cinameName
    }
    
    init(date: String, movieId: String, dateId: String, cinemaName: String) {
        
        self._date = date
        self._movieId = movieId
        self._dateId = dateId
        self._cinameName = cinemaName
    }
}
