//
//  Meal.swift
//  Foodiving
//
//  Created by onechun🌾 on 2016/10/1.
//  Copyright © 2016年 onechun. All rights reserved.
//

import Foundation
import UIKit


class Meal {
    
    
    
    // MARK: Properties
    
    var mealName: String
    var price: String
    var photoString: String?
    var tasteRating: Int
    var serviceRating: Int
    var revisitRating: Int
    var environmentRating: Int
    var comment: String

    var restaurantID: String?
    var userID: String = ""
    var userName: String = ""
    var userPhotoString: String = ""
    var restCommentID: String = ""
    
    var restName: String = ""
    var timestamp: Int = 0
    // MARK: Initialization
    
    init(mealName: String, price: String,tasteRating: Int,serviceRating:Int,revisitRating:Int,environmentRating:Int,comment: String) {
        self.mealName = mealName
        self.price = price
        self.tasteRating = tasteRating
        self.serviceRating = serviceRating
        self.revisitRating = revisitRating
        self.environmentRating = environmentRating
        self.comment = comment
        
        //if mealName.isEmpty || tasteRating < 0 {
        //return nil
        //}
    }
    
}