//
//  CoverViewController.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/10/11.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseStorage
import Firebase

protocol CoverViewControllerDelegate: class {
    
    func didLoginError(error: ErrorType)
    
}


class CoverViewController: UIViewController,FBSDKLoginButtonDelegate, CoverViewControllerDelegate {
    
    
    //Mark: Properties
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
//    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    weak var delegate: CoverViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 255/255, green: 226/255, blue: 82/255, alpha: 1)

//        self.loginButton.hidden = true
        
        delegate = self
        
        FIRAuth.auth()?.addAuthStateDidChangeListener{ auth, user in
            
            if let user = user {
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
                let TabBarController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TabBarController")
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = TabBarController
                self.uploadUserInfo(user)
                self.view.backgroundColor = UIColor(red: 255/255, green: 226/255, blue: 82/255, alpha: 1)
                
            }
            else {
                
//                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile","email","user_friends"]
                self.loginButton.delegate = self
                
                self.view!.addSubview(self.loginButton)
                self.loginButton.hidden = false
                
                self.view.backgroundColor = UIColor(red: 255/255, green: 226/255, blue: 82/255, alpha: 1)
                
            }
            
        }
    }
    
    
    // MARK: FBSDKLoginButtonDelegate
    
    func loginButton(loginButton: FBSDKLoginButton!,didCompleteWithResult result: FBSDKLoginManagerLoginResult!,error: NSError!){
        print("User Logged In")
        loadingSpinner.startAnimating()
        
        self.loginButton.hidden = true
        
        if (error != nil){
            self.loginButton.hidden = false
            loadingSpinner.stopAnimating()
            
        }else if(result.isCancelled) {
            self.loginButton.hidden = false
            loadingSpinner.stopAnimating()
            
        }
        else{
            
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                
                
                
                
            }
            
        }
        
        
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        
    }
    
    
    //Mark: upload to storage
    
    enum UploadUserInfoError: ErrorType {
        
        case missingPictureURL, downloadPictureError,missingUserName
        
    }
    
    func uploadUserInfo(user: FIRUser) {
        
        let profilePic = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "picture.type(large)"],HTTPMethod: "GET")
        profilePic.startWithCompletionHandler { (connection, result, error) -> Void in
            
            if let error = error {
                
                self.delegate?.didLoginError(error)
                
            }
            else {
                
                let result = result as! [String: AnyObject]
                
                guard
                    let picture = result["picture"] as? [String:AnyObject],
                    let data = picture["data"] as? [String:AnyObject],
                    let urlString = data["url"] as? String,
                    let url = NSURL(string: urlString)
                    else {
                        
                        self.delegate?.didLoginError(UploadUserInfoError.missingPictureURL)
                        
                        return
                        
                }
                
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                
                if let imageData = NSData(contentsOfURL: url) {
                    
                    let storage = FIRStorage.storage()
                    let storageRef = storage.referenceForURL("gs://foodiving.appspot.com")
                    let profilePicRef = storageRef.child("userPhoto/\(user.uid).jpg")

                    
                    profilePicRef.putData(imageData,metadata: metadata) { metadata, error in
                        
                        if let error = error {
                            
                            self.delegate?.didLoginError(error)
                            
                        }
                        else {
                            
                            guard
                                let photoURL = metadata?.downloadURL(),
                                let photoData = NSData(contentsOfURL: photoURL),
                                let photoImage = UIImage(data: photoData)
                                else {
                                    
                                    self.delegate?.didLoginError(UploadUserInfoError.missingPictureURL)
                                    
                                    return
                                    
                            }
                            
//                            let storageReference = FIRStorage.storage().reference()
//                            let userPhotoName = NSUUID().UUIDString
//                            let userPhoto = storageReference.child("userPhoto/\(userPhotoName).jpg")
//                            
//                            let metadata = FIRStorageMetadata()
//                            metadata.contentType = "Image/jpeg"
                            profilePicRef.putData(UIImageJPEGRepresentation(photoImage, 0.2)!,metadata: metadata){(data,error) in
                                
                                if let error = error {
                                    
                                    self.delegate?.didLoginError(error)
                                    
                                }
                                else {
                                    
                                    print("upload successful")
                                    guard
                                        let photoURLString = data?.downloadURL()?.absoluteString
                                        else {
                                            
                                            self.delegate?.didLoginError(UploadUserInfoError.missingPictureURL)
                                            
                                            return
                                            
                                    }
                                    
                                    guard
                                        let userName = user.displayName
                                        
                                        else{
                                            self.delegate?.didLoginError(UploadUserInfoError.missingUserName)
                                            
                                            return
                                    }
                                    
                                    let userInfodatabase: [String: AnyObject] = [
                                        "userName": userName,
                                        "photoString": photoURLString
                                    ]
                                    
                                    
                                    let userReference = FIRDatabase.database().reference()
                                    
                                    userReference.child("Users").child(user.uid).setValue(userInfodatabase)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
        }
    }
        // MARK: CoverViewControllerDelegate
        
        func didLoginError(error: ErrorType) {
            
            print(error)
            
        }
        
}

