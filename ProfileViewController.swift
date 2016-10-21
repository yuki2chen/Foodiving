//
//  ProfileViewController.swift
//  Foodaholic
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
    var userUid = ""
    var userPhotoURL: NSURL?
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
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2
        self.profilePicture.clipsToBounds = true
        
        uploadUserInfo()
        retriveData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
    
    
    //Mark: upload to storage
    
    func uploadUserInfo(){
    if let user = FIRAuth.auth()?.currentUser {
        
        let name = user.displayName
        let uid = user.uid
        username = name!
        userUid = uid
        self.userName.text = name
        
        
        
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://foodaholic-e6dde.appspot.com")
        let profilePicRef = storageRef.child(user.uid + ".jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        profilePicRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                
                print("unable to download image")
            } else {
                
                if (data != nil ){
                    
                    print("User already has an image to download , no need to download from facebook")
                    self.profilePicture.image = UIImage(data: data!)
                }
            }
        }
        
        
        
        if (self.profilePicture.image == nil){
            
            let profilePic = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "picture.type(large)"],HTTPMethod: "GET")
            profilePic.startWithCompletionHandler({(connection, result, error) -> Void in
                if(error == nil)
                {
                    
                    let result = result as! [String: AnyObject]
                    
                    print(result)
                    
                    guard
                        let picture = result["picture"] as? [String:AnyObject],
                        let data = picture["data"] as? [String:AnyObject],
                        let urlString = data["url"] as? String,
                        let url = NSURL(string: urlString)
                        else {return}
                    
                    
                    let metadata = FIRStorageMetadata()
                    metadata.contentType = "image/jpeg"
                    
                    if let imageData = NSData(contentsOfURL: url){
                        
                        profilePicRef.putData(imageData,metadata: metadata) {
                            metadata,error in
                            
                            if(error == nil){
                                
                                print("upload successful")
                                
                                guard let photoURL = metadata?.downloadURL() else {
                                    print("fail to download photoURL")
                                    return}
                                
                                guard let photoData = NSData(contentsOfURL: photoURL) else { return }
                                
                                self.profilePicture.image = UIImage(data: photoData)
                                
                                guard let photoString = metadata?.downloadURL()?.absoluteString else{return}
                                self.saveFacebookInfoToFirebase(photoString)
                                self.retriveData()
                                
                            }
                            else{
                                print("Error in download image ")
                            }
                        }
                    }
                }
            })
        }
    }
}
    
    
    
    // Mark: save FacebookInfo To Firebase
    
    func saveFacebookInfoToFirebase(photoString: String){
        let facebookInfo: [String: AnyObject] = ["userName":username,"photoString":photoString]
        let facebookInfoReference = FIRDatabase.database().reference()
        
        facebookInfoReference.child("Users").child(userUid).setValue(facebookInfo)
        
        
        
    }
    
    
    
    
    //Mark: retrieve meal photo data
    
    func retriveData(){
        
        meals = []
        

        let mealInfoReference = FIRDatabase.database().reference()
        
        mealInfoReference.child("RestaurantsComments").queryOrderedByChild("userID").queryEqualToValue(userUid).observeEventType(.Value, withBlock:
            { snapshot in
                let snapshots = snapshot.children.allObjects
                
                for mealInfo in snapshots {
                    guard
                    let mealName = mealInfo.value["mealName"] as? String,
                    let price = mealInfo.value["price"] as? String,
                    let photoString = mealInfo.value["photoString"] as? String,
                    let tasteRating = mealInfo.value["tasteRating"] as? Int,
                    let serviceRating = mealInfo.value["serviceRating"] as?  Int,
                    let revisitRating = mealInfo.value["revisitRating"] as?  Int,
                    let environmentRating = mealInfo.value["environmentRating"] as?  Int,
                    let comment = mealInfo.value["comment"] as? String,
                    let userID = mealInfo.value["userID"] as? String,
                    let restID = mealInfo.value["restaurantId"] as? String
                        else { continue }
                    let meal = Meal(mealName: mealName, price: price,tasteRating: tasteRating, serviceRating: serviceRating, revisitRating: revisitRating, environmentRating: environmentRating, comment: comment)
                    
                    meal.photoString = photoString
                    meal.userID = userID
                    meal.restaurantID = restID
                    self.meals.append(meal)
                    self.mealPhotoStringArray.append(photoString)
//                    print(photoString)
                }
                self.collectionView.reloadData()
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
