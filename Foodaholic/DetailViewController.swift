//
//  DetailViewController.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/10/5.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit
import Nuke
import Firebase
import FirebaseAuth
import FirebaseDatabase


//protocol DetailViewControllerDelegate: class {
//    func didGetData()
//}

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
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
   
    
     
//    var deleteButton: UIBarButtonItem!
    var mealCommentObject: String = ""
    var restaurantPlace: String = ""
//    weak var detailDelegate: DetailViewControllerDelegate?
    
    //Mark: Action
    
  
    @IBAction func myOptionalButton(sender: AnyObject) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default){(action:UIAlertAction) -> Void in
      
            self.performSegueWithIdentifier("EditViewController", sender: self)
            override func prepareForSegue(UIStoryBoardSegue!, sender: AnyObject){
            
                if segue.identifier == "EditViewController"{
                    let destinationController = segue.destinationViewController as? OtherUserViewController
                    destinationController!.meal = self.meal
                }
            }
            })
        
        alert.addAction(UIAlertAction(title: "Delete", style: .Destructive){(action:UIAlertAction) -> Void in
            
            self.deleteComment()
            })

        alert.addAction(UIAlertAction(title: "Canacel", style: .Cancel, handler: {(action: UIAlertAction) -> Void in
            
            
        }))
        
        
        presentViewController(alert, animated: true, completion: nil)
        
        
    }

        
    func deleteComment(){
        FIRAnalytics.logEventWithName("delete_comment", parameters: nil)
        let firebase = FIRDatabase.database().reference()
        let restCommentID = meal!.restCommentID
        firebase.child("RestaurantsComments").child(restCommentID).removeValueWithCompletionBlock{(error, ref) in
            if let error = error{
                print("error:\(error)")
                
            }else{
//                self.dismissViewControllerAnimated(true, completion: nil)
                
                NSNotificationCenter.defaultCenter().postNotificationName("didRemoveItem", object: nil)
//                let ResaturantMealTableVC = self.navigationController?.viewControllers[1] as! ResaturantMealTableViewController
//                self.navigationController?.popToViewController(ResaturantMealTableViewController, animated: true)
                
//                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [ResaturantMealTableViewController];
//                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
                
                for aViewController in viewControllers {
                    if(aViewController is ResaturantMealTableViewController){
                        self.navigationController!.popToViewController(aViewController, animated: true);
                    }
                }

            }
            
        }
        
    }
   


    
    
    
    
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
        
        
        
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
            if (meal.userID) == uid {
                self.navigationItem.rightBarButtonItem = self.deleteButton
            }else{
                self.navigationItem.rightBarButtonItem = nil
                

            }
            
        }

       

        let restaurantID = meal.restaurantID
        retrievedRestaurantLocation(restaurantID!)
        
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "otherUserProfile"{
            let destinationController = segue.destinationViewController as? OtherUserViewController
            destinationController!.meal = self.meal
            
            
        }else if deleteButton === sender{
            FIRAnalytics.logEventWithName("delete_comment", parameters: nil)
            let firebase = FIRDatabase.database().reference()
            let restCommentID = meal!.restCommentID
            firebase.child("RestaurantsComments").child(restCommentID).removeValueWithCompletionBlock{(error, ref) in
                if error != nil{
                    print("error:\(error)")
                 
                }
                else{
//                   self.detailDelegate?.didGetData()

                }
        }
    }
    }
 
    
    
    
    func retrievedRestaurantLocation(restaurantID: String){
        let reference = FIRDatabase.database().reference()
        reference.child("restaurants").queryOrderedByKey().queryEqualToValue("\(restaurantID)").observeEventType(.Value, withBlock: {snapshot in
            let  snapshots = snapshot.children.allObjects
            for restInfo in snapshots{
                let restCountry = restInfo.value["restCountry"] as? String ?? ""
                let restCity = restInfo.value["restCity"] as? String ?? ""
                
                self.restaurantPlace = restCity + " , " + restCountry
                self.restPlace.text = self.restaurantPlace
            }
            })
        
    }
    
    
     
}


