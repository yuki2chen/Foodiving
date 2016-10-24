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

class CoverViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    
    //Mark: Properties
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginButton.hidden = true
        
        
        FIRAuth.auth()?.addAuthStateDidChangeListener{ auth, user in
        if user != nil{
            let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
            let TabBarController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TabBarController")
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = TabBarController
//            self.presentViewController(TabBarController, animated: true, completion: nil)
        }else{
            
            self.loginButton.center = self.view.center
            self.loginButton.readPermissions = ["public_profile","email","user_friends"]
            self.loginButton.delegate = self
            
            self.view!.addSubview(self.loginButton)
            self.loginButton.hidden = false

            
            self.view.backgroundColor = UIColor(red: 255/255, green: 226/255, blue: 82/255, alpha: 1)
            
            }
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            
        }else{
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)

        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            print("User logged in to firebase")
            
            }
        
        }
        
        
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        print("User did Logout")
    }
}
