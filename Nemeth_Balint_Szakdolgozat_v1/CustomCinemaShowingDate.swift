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
    private var _cityName: String!
    private var _cinemaId: String!
    
    var date: String {
        
        return _date
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
    
    init(date: String, movieId: String, dateId: String, cityName: String, cinemaId: String) {
        
        self._date = date
        self._movieId = movieId
        self._dateId = dateId
        self._cityName = cityName
        self._cinemaId = cinemaId
    }
}
