//
//  searchRestaurant.swift
//  Foodiving
//
//  Created by onechun🌾 on 2016/10/7.
//  Copyright © 2016年 onechun. All rights reserved.
//

import Foundation
import MapKit
class searchRestaurantModel {
    
    
    var restaurantDict: [String:AnyObject] = [:]
    
    
    func restaurantHelper(restaurants: AnyObject){
        
        guard let restaurantsInfo = restaurants as? NSDictionary else{
            return
        }
        let id = restaurantsInfo.valueForKey("id") as? String ?? ""
        let name = restaurantsInfo.valueForKey("name") as? String ?? ""
        
        
        
        guard let locationInfo = restaurantsInfo["location"] as? NSDictionary else{
            return
        }
        let restLat = locationInfo.valueForKey("lat") as? Double ?? 0.0
        let restLng = locationInfo.valueForKey("lng") as? Double ?? 0.0
        let restCity = locationInfo.valueForKey("city") as? String ?? ""
        let restCountry = locationInfo.valueForKey("country") as? String ?? ""
        let postalCode = locationInfo.valueForKey("postalCode") as? String ?? ""
        let address = locationInfo.valueForKey("formattedAddress") as? [String] ?? []
        
        
        restaurantDict["id"] = id
        restaurantDict["name"] = name
        restaurantDict["restLat"] = restLat
        restaurantDict["restLng"] = restLng
        restaurantDict["restCity"] = restCity
        restaurantDict["restCountry"] = restCountry
        restaurantDict["postalCode"] = postalCode
        restaurantDict["address"] = address
                
        
        
        
        
        
        //print(restaurants["name"]!)
        
        
    }
    
    
    
}





