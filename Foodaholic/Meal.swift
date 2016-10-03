//
//  Meal.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/10/1.
//  Copyright © 2016年 onechun. All rights reserved.
//

import Foundation
import UIKit






class Meal: NSObject{
    
    // MARK: Properties
    
    var mealName: String
    var price: String
    //var photo: UIImage?
    var tasteRating: Int
    var comment: String
    
    
    
    // MARK: Initialization
    
    init?(mealName: String, price: String,tasteRating: Int,comment: String){
        self.mealName = mealName
        self.price = price
        //self.photo = photo
        self.tasteRating = tasteRating
        self.comment = comment
        
        super.init()
        //if mealName.isEmpty || tasteRating < 0 {
        //return nil
        //}
    }
    
}