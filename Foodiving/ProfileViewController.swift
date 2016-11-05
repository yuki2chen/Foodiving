//
//  ProfileViewController.swift
//  Foodiving
//
//  Created by onechun🌾 on 2016/10/11.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FirebaseAuth
import FirebaseStorage
import Firebase
import Nuke

class ProfileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //Mark: Properties
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let reuseIdentifier = "CollectionCell"
    var username = ""
//    var userPhotoURL: NSURL?
    var mealPhotoStringArray: [String] = []
    var meals = [Meal]()
    
    
    //Mark: Actions
    
    @IBAction func logOutButton(sender: AnyObject) {
        
        try! FIRAuth.auth()!.signOut()
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
        let coverViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("CoverViewController")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = coverViewController
        
        //self.presentViewController(CoverViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    //Mark: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 245/255, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 226/255, blue: 82/255, alpha: 0.5)
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)]
        
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2
        self.profilePicture.clipsToBounds = true
        
        retrieveUserInfo()
        
    }
    
    
    //Mark: retrieveUserInfo
    
    func retrieveUserInfo(){
    
        let userInfoReference = FIRDatabase.database().reference()
        if let user = FIRAuth.auth()?.currentUser{
            
            retriveData(user.uid)
            
            userInfoReference.child("Users").child(user.uid).observeSingleEventOfType(.Value, withBlock: {
                snapshot in
            
                    let userName = snapshot.value?["userName"] as? String ?? ""
                    let userPhotoString = snapshot.value?["photoString"] as? String ?? ""
                    
                    if let userPhotoUrl = NSURL(string: userPhotoString){
                    self.profilePicture.nk_setImageWith(userPhotoUrl)
                    }
                    self.userName.text = userName

            })
        }
    }
    
    
    //Mark: retrieve meal photo data
    
    func retriveData(userUid: String){
        
        let mealInfoReference = FIRDatabase.database().reference()
        
        mealInfoReference.child("RestaurantsComments").queryOrderedByChild("userID").queryEqualToValue(userUid).observeEventType(.Value, withBlock:
            { snapshot in
                
//                let snapshots = snapshot.children.allObjects
                
                self.meals = []
                self.mealPhotoStringArray = []
                
                for snapshots in snapshot.children {
                    guard
                        let mealInfo = snapshots as? FIRDataSnapshot,
                        let mealName = mealInfo.value?["mealName"] as? String,
                        let price = mealInfo.value?["price"] as? String,
                        let photoString = mealInfo.value?["photoString"] as? String,
                        let tasteRating = mealInfo.value?["tasteRating"] as? Int,
                        let serviceRating = mealInfo.value?["serviceRating"] as?  Int,
                        let revisitRating = mealInfo.value?["revisitRating"] as?  Int,
                        let environmentRating = mealInfo.value?["environmentRating"] as?  Int,
                        let comment = mealInfo.value?["comment"] as? String,
                        let userID = mealInfo.value?["userID"] as? String,
                        let restID = mealInfo.value?["restaurantId"] as? String,
                        let timestamp = mealInfo.value?["timestamp"] as? Int
                        else { continue }
                    let meal = Meal(mealName: mealName, price: price,tasteRating: tasteRating, serviceRating: serviceRating, revisitRating: revisitRating, environmentRating: environmentRating, comment: comment)
                    
                    meal.photoString = photoString
                    meal.userID = userID
                    meal.restaurantID = restID
                    meal.restCommentID = mealInfo.key
                    meal.timestamp = timestamp
                    self.meals.append(meal)
                    self.mealPhotoStringArray.append(photoString)
                    
                }
//                let result = self.meals.sort({$0.timestamp > $1.timestamp})
//                self.meals = result
                dispatch_async(dispatch_get_main_queue()){
                    self.collectionView.reloadData()
                }

                
                
        })
        
        
    }
    
    func retrieveRestData(restID: String){
        let restFirebase = FIRDatabase.database().reference()
        restFirebase.child("restaurants").queryOrderedByKey().queryEqualToValue(restID).observeEventType(.Value, withBlock: {
            
            snapshot in
            
        })
    }
    
    
    
    //Mark: look collection detail
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailFromPicture"{
            let destinationController = segue.destinationViewController as! DetailViewController
            
            if let selectedCellsquare = sender as? ProfileCollectionViewCell{
                let indexPath = collectionView.indexPathForCell(selectedCellsquare)
                let selectedPhoto = meals[indexPath!.row]
                destinationController.meal = selectedPhoto
            }
            
            
        }
    }
    
    
    
    
    
    //Mark: UICollectionView datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mealPhotoStringArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellsquare = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProfileCollectionViewCell
        
        cellsquare.backgroundColor = UIColor.whiteColor()
        let mealPhoto = mealPhotoStringArray[indexPath.row]
        if let mealPhotoURL = NSURL(string: mealPhoto) {
            
            cellsquare.mealPhoto.nk_setImageWith(mealPhotoURL)
        }
        
        return cellsquare
    }
    
    
}



