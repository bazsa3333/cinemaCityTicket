//
//  CustomCinemaCinema.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 11..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import Foundation

class CustomCinemaCinema {
    
    private var _name: String!
    private var _ids = [String]()
    private var _movieIds = [String]()
    private var _nameId: String!
    private var _cityName: String!
    
    var name: String {
        
        return _name
    }
    
    var ids: [String] {
        
        return _ids
    }
    
    var movieIds: [String] {
        
        return _movieIds
    }
    
    var nameId: String {
        
        return _nameId
    }
    
    var cityName: String {
        
        return _cityName
    }
    
    init(name: String, ids: [String], nameId: String, cityName: String, movieIds: [String]) {
        
        self._name = name
        self._ids = ids
        self._nameId = nameId
        self._cityName = cityName
        self._movieIds = movieIds
    }
}
