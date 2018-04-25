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
    private var _timeId: String!
    private var _movieId: String!
    private var _dateId: String!
    private var _cityName: String!
    private var _cinemaId: String!
    
    private var _tickets: String!
    
    var hour: String {
        
        return _hour
    }
    
    var minute: String {
        
        return _minute
    }
    
    var timeId: String {
        
        return _timeId
    }
    
    var movieId: String {
        
        return _movieId
    }
    
    var dateId: String {
        
        return _dateId
    }
    
    var cityName: String {
        
        return _cityName
    }
    
    var cinemaId: String {
        
        return _cinemaId
    }
    
    var tickets: String {
        
        return _tickets
    }
    
    init(hour: String, minute: String, timeId: String, movieId: String, dateId: String, cityName: String, cinemaId: String) {
        
        self._hour = hour
        self._minute = minute
        self._timeId = timeId
        self._movieId = movieId
        self._dateId = dateId
        self._cityName = cityName
        self._cinemaId = cinemaId
    }
    
    init(cinemaId: String, movieId: String, dateId: String, timeId: String, tickets: String, cityName: String) {
        
        self._cinemaId = cinemaId
        self._movieId = movieId
        self._dateId = dateId
        self._timeId = timeId
        self._tickets = tickets
        self._cityName = cityName
    }
}
