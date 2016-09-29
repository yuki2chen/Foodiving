//
//  ResaturantMealTableViewController.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/9/29.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class ResaturantMealTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RestaurantInDatabase()
    }

    //Mark: -Create Database
    func RestaurantInDatabase(){
        let restaurantName =  "drip cafe"
        let address = "city Hall "
        let restaurantInfoDatabase: [String: AnyObject] = [restaurantName: restaurantName ,address: address]
        let restaurantReference = FIRDatabase.database().reference()
        
        restaurantReference.child("Restaurant").childByAutoId().setValue(restaurantInfoDatabase)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    
}
