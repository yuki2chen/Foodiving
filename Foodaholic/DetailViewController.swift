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
   
    @IBOutlet weak var serviceRateDetail: RatingControlService!
    @IBOutlet weak var userNameDisplay: UIButton!
    
     
    var deleteButton: UIBarButtonItem!
    
    
    
    
    //Mark: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let meal = meal else {return}

        photoDetail.clipsToBounds = true
        mealNameDetail.text = meal.mealName
        priceDetail.text = meal.price
        
        tasteRateDetail.rating = meal.tasteRating
        serviceRateDetail.rating = meal.serviceRating
        revisitRateDetail.rating = Int(meal.revisitRating)
        environmentRateDetail.rating = Int(meal.environmentRating)
        commentDetail.text = meal.comment
        userNameDisplay.setTitle("\(meal.userName)",forState: .Normal)
        self.photoDetail.nk_setImageWith(NSURL(string: meal.photoString!)!)
        
        self.deleteButton = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
            if (meal.userID) == uid {
            self.navigationItem.rightBarButtonItem = self.deleteButton
            }else{
                self.navigationItem.rightBarButtonItem = nil
            }

        }

        
        
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
    

    
    
    
  
}