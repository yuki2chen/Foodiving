//
//  OtherUserViewController.swift
//  Foodiving
//
//  Created by onechun🌾 on 2016/10/18.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit
import Nuke
import Firebase

class OtherUserViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhotoImage: UIImageView!
    @IBOutlet weak var otherUserMealView: UICollectionView!
    var meal: Meal?
    var mealPhotoStringArray: [String] = []
    var meals = [Meal]()
    private let reuseIdentifier = "OtherCollectionCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otherUserMealView.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 245/255, alpha: 1)

        otherUserMealView.delegate = self
        otherUserMealView.dataSource = self
        
        userNameLabel.text = meal?.userName
        
        self.userPhotoImage.nk_setImageWith(NSURL(string: (meal?.userPhotoString)!)!)
        navigationItem.title = "Profile"
        retriveData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func retriveData(){
        
        let userID = meal?.userID
        
        meals = []
        let mealInfoReference = FIRDatabase.database().reference()
        
        mealInfoReference.child("RestaurantsComments").queryOrderedByChild("userID").queryEqualToValue(userID).observeEventType(.Value, withBlock:
            { snapshot in
//                let snapshots = snapshot.children.allObjects
                
                
                 for snapshot in snapshot.children {
                    print(snapshot.children)
                    guard
                        let mealInfo = snapshot as? FIRDataSnapshot ,
                        let mealName = mealInfo.value?["mealName"] as? String,
                        let price = mealInfo.value?["price"] as? String,
                        let photoString = mealInfo.value?["photoString"] as? String,
                        let tasteRating = mealInfo.value?["tasteRating"] as? Int,
                        let serviceRating = mealInfo.value?["serviceRating"] as?  Int,
                        let revisitRating = mealInfo.value?["revisitRating"] as?  Int,
                        let environmentRating = mealInfo.value?["environmentRating"] as?  Int,
                        let comment = mealInfo.value?["comment"] as? String,
                        let userID = mealInfo.value?["userID"] as? String,
                        let restID = mealInfo.value?["restaurantId"] as? String
                        else { continue }
                    let meal = Meal(mealName: mealName, price: price,tasteRating: tasteRating, serviceRating: serviceRating, revisitRating: revisitRating, environmentRating: environmentRating, comment: comment)
                    
                    meal.photoString = photoString
                    meal.userID = userID
                    meal.restaurantID = restID
                    meal.restCommentID = mealInfo.key
                    self.meals.append(meal)
                    self.mealPhotoStringArray.append(photoString)
                }
                 self.otherUserMealView.reloadData()
        })
        
        
       
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMealDetail"{
            let destinationController = segue.destinationViewController as? DetailViewController

            if let selectedCellSquare = sender as? OtherUserCollectionViewCell{
                let indexPath = otherUserMealView.indexPathForCell(selectedCellSquare)
                let selectedPhoto = meals[indexPath!.row]
                destinationController!.meal = selectedPhoto
            }
        
        
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mealPhotoStringArray.count
    }
    

     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellsquare = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! OtherUserCollectionViewCell
        
        let mealPhotoString = mealPhotoStringArray[indexPath.row]
        if let mealPhotoURL = NSURL(string: mealPhotoString){
            
            cellsquare.photoImage.nk_setImageWith(mealPhotoURL)
            
        }
      return cellsquare
    }

    
    
}
