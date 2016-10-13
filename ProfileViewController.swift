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

class ProfileViewController: UIViewController {
    
    //Mark: Properties
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    var username = ""
    var userUid = ""
    var userPhotoURL: NSURL?
    
    
    
    
    //Mark: Actions
    @IBAction func logOutButton(sender: AnyObject) {
        
        try! FIRAuth.auth()!.signOut()
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
        let CoverViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("CoverViewController")
        self.presentViewController(CoverViewController, animated: true, completion: nil)
    }
    
    
    
    
    //Mark: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2
        self.profilePicture.clipsToBounds = true
        
        if let user = FIRAuth.auth()?.currentUser {
            
            let name = user.displayName
            let uid = user.uid
            username = name!
            userUid = uid
            self.userName.text = name
            
            
            
    //Mark: upload to storage
            
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
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
