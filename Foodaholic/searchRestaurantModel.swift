//
//  searchRestaurant.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/10/7.
//  Copyright © 2016年 onechun. All rights reserved.
//

import Foundation
class searchRestaurantModel {
    
    
    var restaurantDict: [String:AnyObject] = [:]
    
    
    //    var id: String = ""
    //    var name: String = ""
    //    var restLat: Double = 0.0
    //    var restLng: Double = 0.0
    
    //    init (id: String,name: String,restLat:Double,restLng:Double){
    //        self.id = id
    //        self.name = name
    //        self.restLat = restLat
    //        self.restLng = restLng
    //    }
    
    
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
        
        
        restaurantDict["id"] = id
        restaurantDict["name"] = name
        restaurantDict["restLat"] = restLat
        restaurantDict["restLng"] = restLng
        // self.searchRestaurants(id: id, name:name,restLat: locationLat, restLat: locationLat)
        
                
        
        //                    self.searchRestaurants.append(searchRestaurantModel(id: id, name: name, restLat: locationLat, restLng: locationLng))
        print(restaurants["name"]!)
        
        
    }
    
    
    
}





