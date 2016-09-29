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

struct RestaurantInDatabaseStruct {
    let restaurantName: String!
    let address: String!

}



class ResaturantMealTableViewController: UITableViewController {

    var restaurants = [RestaurantInDatabaseStruct]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let restaurantInfoDatabase = FIRDatabase.database().reference()
        restaurantInfoDatabase.child("Restaurants").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            let restaurantName = snapshot.value!["name"] as! String
            let address = snapshot.value!["address"] as! String
            
            self.restaurants.insert(RestaurantInDatabaseStruct(restaurantName:restaurantName,address:address), atIndex:0)
            self.tableView.reloadData()
            
            }
        )
        
        
        RestaurantInDatabase()
    }

    //Mark: -Create Database
    func RestaurantInDatabase(){
        let restaurantName =  "drip cafe"
        let address = "city_hall"
        
        let restaurantInfoDatabase: [String: AnyObject] = ["name": restaurantName ,"address": address]
        let restaurantReference = FIRDatabase.database().reference()
        
        restaurantReference.child("Restaurants").childByAutoId().setValue(restaurantInfoDatabase)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
//        let labelOfName = cell?.viewWithTag(1) as! UILabel
//        labelOfName.text = restaurants[indexPath.row].restaurantName
        let labelOfAddress = cell?.viewWithTag(2) as! UILabel
        labelOfAddress.text = restaurants[indexPath.row].address
        
        return cell!
        
        
    }
}
