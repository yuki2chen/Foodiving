//
//  Restaurants.swift
//  Foodiving
//
//  Created by onechun🌾 on 2016/10/25.
//  Copyright © 2016年 onechun. All rights reserved.
//

import Foundation


class Restaurants{
    
    
    var restName: String
    var restCity: String
    var restCountry: String
    var restLat: Double
    var restLng: Double
    
    init(restName: String ,restCity: String, restCountry: String, restLat: Double, restLng: Double){
        self.restName = restName
        self.restCity = restCity
        self.restCountry = restCountry
        self.restLat = restLat
        self.restLng = restLng
    }
}