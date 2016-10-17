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
    var photoString: String = ""
    @IBOutlet weak var photoDetail: UIImageView!
    @IBOutlet weak var mealNameDetail: UILabel!
    @IBOutlet weak var priceDetail: UILabel!
    @IBOutlet weak var tasteRateDetail: RatingControl!
    @IBOutlet weak var serviceRateDetail: RatingControlService!
    @IBOutlet weak var revisitRateDetail: RatingControlRevisit!
    @IBOutlet weak var environmentRateDetail: RatingControlEnvironment!
    @IBOutlet weak var commentDetail: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        mealNameDetail.text = meal?.mealName
        priceDetail.text = meal?.price
        tasteRateDetail.rating = Int(meal!.tasteRating)
//        serviceRateDetail.rating = Int(meal!.serviceRating)
//        revisitRateDetail.rating = Int(meal!.revisitRating)
//        environmentRateDetail.rating = Int(meal!.environmentRating)
        commentDetail.text = meal?.comment
        let photoUrl = NSURL(string: meal!.photoString!)
        let photoData = NSData(contentsOfURL: photoUrl!)
        self.photoDetail.image = UIImage(data: photoData!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

  
}
