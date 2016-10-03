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
//    var photo: UIImage?
//    var tasteRating: Int
    var comment: String
    
    
    
    // MARK: Archiving Paths
    // 創建一個文件路徑數據   need?????
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")

    
    
    
    
    // MARK: Types
    struct propertyKey {
        static let mealNameKey = "maelName"
        static let priceKey = "price"
        static let photoKey = "photo"
        static let tasteRatingKey = "tasteRating"
        static let commentKey = "comment"
        
    }
    
    // MARK: Initialization

    init?(mealName: String, price: String,comment: String){
        self.mealName = mealName
        self.price = price
//        self.photo = photo
//        self.tasteRating = tasteRating
        self.comment = comment
        
        super.init()
//        if mealName.isEmpty || tasteRating < 0 {
//            return nil
//        }
    }
    
    
    
    
    // MARK: NSCoding
//    func encodeWithCoder(aCoder: NSCoder){
//        aCoder.encodeObject(mealName,forKey: propertyKey.mealNameKey)
//        aCoder.encodeObject(price,forKey: propertyKey.priceKey)
//        aCoder.encodeObject(photo,forKey: propertyKey.photoKey)
//        aCoder.encodeObject(tasteRating,forKey: propertyKey.tasteRatingKey)
//        aCoder.encodeObject(comment,forKey: propertyKey.commentKey)
//    }
//    
//    required convenience init?(coder aDecoder: NSCoder) {
//        let mealName = aDecoder.decodeObjectForKey(propertyKey.mealNameKey) as! String
//        let price = aDecoder.decodeObjectForKey(propertyKey.priceKey) as! String
//        let photo = aDecoder.decodeObjectForKey(propertyKey.photoKey) as? UIImage
//        let tasteRating = aDecoder.decodeIntegerForKey(propertyKey.tasteRatingKey)
//        let comment = aDecoder.decodeObjectForKey(propertyKey.commentKey) as? String
//        self.init(mealName: String, price: String, photo: UIImage? ,tasteRating: Int,comment: String)
//    }
//    
    
    
}