//
//  DetailViewController.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/10/5.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit
import Nuke
import FirebaseAuth
import FirebaseDatabase

class DetailViewController: UIViewController {

    //Mark: properties
    var meal: Meal?
    @IBOutlet weak var photoDetail: UIImageView!
    @IBOutlet weak var mealNameDetail: UILabel!
    @IBOutlet weak var priceDetail: UILabel!
    @IBOutlet weak var tasteRateDetail: RatingControl!
    @IBOutlet weak var revisitRateDetail: RatingControlRevisit!
    @IBOutlet weak var environmentRateDetail: RatingControlEnvironment!
    @IBOutlet weak var commentDetail: UILabel!
   
    @IBOutlet weak var restPlace: UILabel!
    @IBOutlet weak var serviceRateDetail: RatingControlService!
    @IBOutlet weak var userNameDisplay: UIButton!
    
    @IBOutlet weak var testButton: UIBarButtonItem!
    
     
    var deleteButton: UIBarButtonItem!
    var mealCommentObject: String = ""
    var restaurantPlace: String = ""
    
    
    //Mark: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let meal = meal else {return}

        photoDetail.clipsToBounds = true
        
        mealNameDetail.text = meal.mealName
        priceDetail.text = meal.price
        tasteRateDetail.rating = meal.tasteRating
        serviceRateDetail.rating = meal.serviceRating
        revisitRateDetail.rating = meal.revisitRating
        environmentRateDetail.rating = meal.environmentRating
        commentDetail.text = meal.comment
        userNameDisplay.setTitle("\(meal.userName)",forState: .Normal)
        self.photoDetail.nk_setImageWith(NSURL(string: meal.photoString!)!)
        
        self.deleteButton = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(deleteFunction(_:)))
        
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
            if (meal.userID) == uid {
                self.navigationItem.rightBarButtonItem = self.deleteButton
            }else{
                self.navigationItem.rightBarButtonItem = nil
                self.navigationItem.leftBarButtonItem = nil

            }
            
        }

        retrievedCommentID()
        
        let restaurantID = meal.restaurantID
        retrievedRestaurantLocation(restaurantID!)
        
        
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "otherUserProfile"{
            let destinationController = segue.destinationViewController as? OtherUserViewController
            destinationController!.meal = self.meal
        }
    }
 
    
    
    
    func retrievedRestaurantLocation(restaurantID: String){
        let reference = FIRDatabase.database().reference()
        reference.child("restaurants").queryOrderedByKey().queryEqualToValue("\(restaurantID)").observeEventType(.Value, withBlock: {snapshot in
            let  snapshots = snapshot.children.allObjects
            for restInfo in snapshots{
                let restCountry = restInfo.value["restCountry"] as? String ?? ""
                let restCity = restInfo.value["restCity"] as? String ?? ""
                
                self.restaurantPlace = restCity + "," + restCountry
                self.restPlace.text = self.restaurantPlace
            }
            })
        
    }
    
    
    
    
    
    
    
    //Mark: download RestaurantsComments key and delete it
    
    func retrievedCommentID(){
        let reference = FIRDatabase.database().reference()
        reference.child("RestaurantsComments").queryOrderedByKey().observeEventType(.ChildAdded, withBlock:{
            snapshot in
            let mealCommentObject = snapshot.key
            self.mealCommentObject = mealCommentObject
        })
    }

    
    func deleteFunction (sender: UIBarButtonItem) {
        
        if deleteButton == sender {
            
            let firebase = FIRDatabase.database().reference()
            firebase.child("RestaurantsComments").child(mealCommentObject).removeValueWithCompletionBlock{(error, ref) in
                if error != nil{
                    print("error:\(error)")
                    
                }else{
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("didRemoveItem", object: nil)
                    
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
}