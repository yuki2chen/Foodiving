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
import FirebaseStorage



class ResaturantMealTableViewController: UITableViewController {
    
    //Mark: Properties
    
    var meals = [Meal]()
    var photoURL: String = ""
    var restDic: [String: AnyObject] = [:]
    
    //Mark: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(restDic)
        retreiveData()
        self.navigationItem.title = restDic["name"] as? String ?? ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    
    // Mark: Retrieve data
    
    func retreiveData() {
        
        meals = []
        let restaurantId = restDic["id"] as? String ?? ""
        print(restaurantId)
        let mealInfoDatabase = FIRDatabase.database().reference()
        mealInfoDatabase.child("RestaurantsComments").queryOrderedByChild("restaurantId").queryEqualToValue("\(restaurantId)").observeEventType(.Value, withBlock: {
            
            snapshot in
            print(snapshot.value)
            let snapshots = snapshot.children.allObjects
            for commentSnap in snapshots{
                
                let mealName = commentSnap.value["mealName"] as? String ?? ""
                let price = commentSnap.value["price"] as? String ?? ""
                self.photoURL = commentSnap.value["photoURL"] as? String ?? ""
                let tasteRating = commentSnap.value["tasteRating"] as?  Int ?? 0
                let comment = commentSnap.value["comment"] as? String ?? ""
                
                self.meals.append(Meal(mealName: mealName,price: price,tasteRating: tasteRating, comment: comment))
            }
            
            
            self.tableView.reloadData()
        })
    }
    
    
    // Mark: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail"{
            
            let mealDetailViewController = segue.destinationViewController as! DetailViewController
            
            if let selectedMealCell = sender as? ResaturantMealTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                let selectedPhoto = photoURL
                mealDetailViewController.meal = selectedMeal
                mealDetailViewController.photoURL = selectedPhoto
            }
        }else if segue.identifier == "AddItem"{
            let destinationController = segue.destinationViewController as! CommentViewController
            print(restDic)
            destinationController.restDictionary = self.restDic
            print("add new meal")
            
        }
    }
    
    
    
    
    
    // Mark: Action
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
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
        cell.priceLabel.text = String(meal.price)
        cell.ratingControl.rating = Int(meal.tasteRating)
        let photoUrl = NSURL(string: photoURL)
        let photoData = NSData(contentsOfURL: photoUrl!)
        cell.photoImageView.image = UIImage(data: photoData!)
        
        
        return cell
        
    }
}
