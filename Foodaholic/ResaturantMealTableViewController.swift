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

//struct MealInDatabaseStruct {
//    let mealName: String!
//    let price: String!
////    let photo: UIImage!
////    let tasteRating: RatingControl
//    let comment: String!
//
//}

class ResaturantMealTableViewController: UITableViewController {
    var meals = [Meal]()
//    var mealsInDatabase = [MealInDatabaseStruct]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        
        let mealInfoDatabase = FIRDatabase.database().reference()
        mealInfoDatabase.child("Restaurants_comment").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            let mealName = snapshot.value!["mealName"] as! String
            let price = snapshot.value!["price"] as! String
//            let photo = snapshot.value!["photo"] as! UIImage
//            let tasteRating = snapshot.value!["tasteRating"] as! RatingControl
            let comment = snapshot.value!["comment"] as! String

            
            self.meals.insert(Meal(mealName: mealName,price: price,comment: comment)!, atIndex:0)
            self.tableView.reloadData()
            
            }
        )
        
        
    }

    
    
    
    //Mark: Navigation
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail"{
            
            let mealDetailViewController = segue.destinationViewController as! CommentViewController
            
            if let selectedMealCell = sender as? ResaturantMealTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
            }
            
        }else if segue.identifier == "AddItem"{
            
            print("add new meal")
            
        }
    }
    
    
    //Mark: Action

    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? CommentViewController, meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                meals.append(meal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            // Save the meals.
//            saveMeals()
        }
    }
    
    
    
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath: indexPath) as! ResaturantMealTableViewCell
        
        
        let meal = meals[indexPath.row]
        
        cell.mealNameLabel.text = meal.mealName
        cell.priceLabel.text = meal.price
//        cell.ratingControl.rating = meal.tasteRating
//        let labelOfName = cell?.viewWithTag(1) as! UILabel
//        labelOfName.text = restaurants[indexPath.row].restaurantName
//        let labelOfAddress = cell?.viewWithTag(2) as! UILabel
//        labelOfAddress.text = restaurants[indexPath.row].address
        
        return cell
        
        
    }
}
