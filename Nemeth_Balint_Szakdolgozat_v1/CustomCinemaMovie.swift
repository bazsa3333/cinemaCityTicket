//
//  CustomCinemaMovie.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 12..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import Foundation

class CustomCinemaMovie {
    
    private var _name: String!
    private var _id: String!
    private var _cinemaName: String!
    private var _picture: String!
    private var _description: String!
    private var _genre: String!
    private var _length: String!
    private var _rating: String!
    private var _release: String!
    
    var name: String {
        
        return _name
    }
    
    var id: String {
        
        return _id
    }
    
    var cinemaName: String {
        
        return _cinemaName
    }
    
    var picture: String {
        
        return _picture
    }
    
    var description: String {
        
        return _description
    }
    
    var genre: String {
        
        return _genre
    }
    
    var length: String {
        
        return _length
    }
    
    var rating: String {
        
        return _rating
    }
    
    var release: String {
        
        return _release
    }
    
    init(name: String, id: String, cinemaName: String, picture: String, description: String, genre: String, length: String, rating: String, release: String) {
        
        self._name = name
        self._id = id
        self._cinemaName = cinemaName
        self._picture = picture
        self._description = description
        self._genre = genre
        self._length = length
        self._rating = rating
        self._release = release
    }
}
