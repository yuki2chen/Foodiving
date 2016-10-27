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
import Nuke


class ResaturantMealTableViewController: UITableViewController,DetailViewControllerDelegate  {
    
    //Mark: Properties
    
    var meals = [Meal]()
    var restDic: [String: AnyObject] = [:]
    
    @IBOutlet weak var mealDefaultPhoto: UIImageView!
    
    //Mark: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retreiveData()

        self.navigationItem.title = restDic["name"] as? String ?? ""
        tableView.separatorStyle = .None
        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ResaturantMealTableViewController.methodOfReceivedNotification), name:"didRemoveItem", object: nil)
        
    }
    
    
    
    
    // Mark: Retrieve data
    
    func retreiveData() {
        
        meals = []
        
        let restaurantId = restDic["id"] as? String ?? ""
        let mealInfoDatabase = FIRDatabase.database().reference()
//        let serverTimestamp = FIRServerValue.timestamp()
        mealInfoDatabase.child("RestaurantsComments").queryOrderedByChild("restaurantId").queryEqualToValue("\(restaurantId)").observeSingleEventOfType(.Value, withBlock: { snapshot in

            for snapshot in snapshot.children {
                
                let commentSnap = snapshot as! FIRDataSnapshot
                let mealName = commentSnap.value?["mealName"] as? String ?? ""
                let price = commentSnap.value?["price"] as? String ?? ""
                let photoString = commentSnap.value?["photoString"] as? String ?? ""
                let tasteRating = commentSnap.value?["tasteRating"] as?  Int ?? 0
                let serviceRating = commentSnap.value?["serviceRating"] as?  Int ?? 0
                let revisitRating = commentSnap.value?["revisitRating"] as?  Int ?? 0
                let environmentRating = commentSnap.value?["environmentRating"] as?  Int ?? 0
                let comment = commentSnap.value?["comment"] as? String ?? ""
                let userID = commentSnap.value?["userID"] as? String ?? ""
                let restID = commentSnap.value?["restaurantId"] as? String ?? ""
                let timestamp = commentSnap.value?["timestamp"] as? [String: String] ?? [:]
                
                
                
                let meal = Meal(mealName: mealName, price: price,tasteRating: tasteRating, serviceRating: serviceRating, revisitRating: revisitRating, environmentRating: environmentRating, comment: comment)
                
                meal.photoString = photoString
                meal.userID = userID
                meal.restaurantID = restID
                meal.restCommentID = commentSnap.key
                

                self.retreiveUserData(meal)
            
                if self.tableView != nil{
                    
                    self.tableView.reloadData()
                }
                
            }
// self.meals.sortInPlace({ $0.tasteRating < $1.tasteRating})
            
        })
       
    }
    
    
    
    
    func retreiveUserData(meal: Meal){
        
        
        let userInfoDatabase = FIRDatabase.database().reference()
        userInfoDatabase.child("Users").queryOrderedByKey().queryEqualToValue(meal.userID).observeSingleEventOfType(.Value, withBlock: {
            snapshot in
//            print (snapshot.value)
            let snapshots = snapshot.children.allObjects
            for commentsnap in snapshots{
            meal.userName = commentsnap.value?["userName"] as? String ?? ""
            meal.userPhotoString = commentsnap.value?["photoString"] as? String ?? ""
            self.meals.append(meal)
            
            }
            self.tableView.reloadData()

        })

    }
    
   
    func didEdit() {
        didget()
    }
    
    //Mark: notification from delete button
    
    func methodOfReceivedNotification(notification: NSNotification){
        
        meals = []
        retreiveData()
        self.tableView.reloadData()
    }
    
    

    
    //Mark: retreive server value
    
    func retreiveServerValues(){
// var sessionRef = FIRDatabase.database().reference("session")
        
    }
    
    
    
    
    // Mark: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail"{
            
            let mealDetailViewController = segue.destinationViewController as! DetailViewController
            
            if let selectedMealCell = sender as? ResaturantMealTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
                                
                mealDetailViewController.detailDelegate = self
            }
        }else if segue.identifier == "AddItem"{
            let destinationController = segue.destinationViewController as! CommentViewController
            destinationController.restDictionary = self.restDic
            
            destinationController.delegate = self
            print("add new meal")
            
        }
    }
    
    
    
    
    
    // Mark: Action
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
       
        
        
    }
    
    
    
    @IBAction func unwindToMealList2(sender: UIStoryboardSegue) {
        meals = []
        retreiveData()
        self.tableView.reloadData()
    }
  
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meals.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath: indexPath) as! ResaturantMealTableViewCell
        
        cell.photoImageView.image = nil
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath: indexPath) as! ResaturantMealTableViewCell
        
        
        let meal = meals[indexPath.row]
        let photoString = meal.photoString ?? ""
        
        cell.mealNameLabel.text = meal.mealName
        cell.priceLabel.text = String(meal.price)
        cell.ratingControl.rating = Int(meal.tasteRating)
        
    
        if let photoUrl = NSURL(string: photoString) {

            cell.photoImageView.nk_setImageWith(photoUrl)
        
            print(photoUrl)
            
            
        }
        
        
        
        return cell
        
    }
}

extension ResaturantMealTableViewController: CommentViewControllerdelegate {
    func  didget(){
        retreiveData()
    }

}