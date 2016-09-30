//
//  CommentViewController.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/9/30.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate{

    //Mark: Properties
    @IBOutlet weak var mealNameLabel: UILabel!
    
    @IBOutlet weak var mealNameTextField: UITextField!
    @IBOutlet weak var priceNameLabel: UILabel!
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var serviceChargeNameLabel: UILabel!
    
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var environmentRateLabel: UILabel!
    
    @IBOutlet weak var environmentRatingControl: RatingControl!
    @IBOutlet weak var serviceRateLabel: UILabel!
    
    @IBOutlet weak var revisitRateLabel: UILabel!
    
    @IBOutlet weak var tasteRateLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    
    //Mark: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController){
        //當cancel時  忽略picker
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerController(picker:UIImagePickerController,didFinishPickingMediaWithInfo info:[String : AnyObject]){
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //display
        photoImageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)

    }
    
     //Mark: Action
    
    @IBAction func postButton(sender: AnyObject) {
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        //當點擊時 keyboard會關閉
        mealNameTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        commentTextField.resignFirstResponder()
        
        //Mark: create a image picker controller
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .SavedPhotosAlbum
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    

    
    
}
