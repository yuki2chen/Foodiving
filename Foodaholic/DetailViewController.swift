//
//  DetailViewController.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/10/5.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var meal: Meal?
    @IBOutlet weak var photoDetail: UIImageView!
    @IBOutlet weak var mealNameDetail: UILabel!
    @IBOutlet weak var priceDetail: UILabel!
    @IBOutlet weak var tasteRateDetail: RatingControl!
    @IBOutlet weak var serviceRateDetail: RatingControlService!
    @IBOutlet weak var revisitRateDetail: RatingControlRevisit!
    @IBOutlet weak var environmentRateDetail: RatingControlEnvironment!
    @IBOutlet weak var commentDetail: UILabel!
   
    @IBOutlet weak var userNameDisplay: UIButton!
    @IBAction func usernamebutton(sender: AnyObject) {
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        mealNameDetail.text = meal?.mealName
        priceDetail.text = meal?.price
        tasteRateDetail.rating = Int(meal!.tasteRating)
        
//        serviceRateDetail.rating = Int(meal!.serviceRating)
//        revisitRateDetail.rating = Int(meal!.revisitRating)
//        environmentRateDetail.rating = Int(meal!.environmentRating)
        commentDetail.text = meal?.comment
//        userNameDisplay.titleLabel?.text = meal!.userName
        userNameDisplay.setTitle("\(meal!.userName)",forState: .Normal)
        let photoUrl = NSURL(string: meal!.photoString!)
        let photoData = NSData(contentsOfURL: photoUrl!)
        self.photoDetail.image = UIImage(data: photoData!)
        // Do any additional setup after loading the view.
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
