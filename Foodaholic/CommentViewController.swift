//
//  CommentViewController.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/9/30.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit
import Firebase

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
    
    
    @IBOutlet weak var tasteRateLabel: UILabel!
    @IBOutlet weak var tasteRatingControl: RatingControl!
    @IBOutlet weak var serviceRateLabel: UILabel!
    
    @IBOutlet weak var revisitRateLabel: UILabel!
    
    @IBOutlet weak var environmentRateLabel: UILabel!
    
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    
    @IBOutlet weak var PostButton: UIBarButtonItem!
    
    
    var meal: Meal?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //使圖案透視 可使用照片點選(autolayout完看是否需要）
        photoImageView.userInteractionEnabled = true
        
        
        //
        mealNameTextField.delegate = self
        priceTextField.delegate = self
        commentTextField.delegate = self
//        checkValidMealName()
        
        
        
        self.hideKeyboardWhenTappedAround()
        
        //點選cell時 會有儲存的資訊
        if let meal = meal{
            navigationItem.title = meal.mealName
            mealNameTextField.text = meal.mealName
            priceTextField.text = meal.price
//            photoImageView.image = meal.photo
            commentTextField.text = meal.comment
//            tasteRatingControl.rating = meal.tasteRating
        
            
        }
        
        
//        navigationItem.leftBarButtonItem = editButtonItem()
        
        //??
//        navigationItem.title = mealNameTextField.text
        
        
        
        
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
    
    
    //Mark: Navigation

    @IBAction func cancel(sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        
        if isPresentingInAddMealMode{
        dismissViewControllerAnimated(true, completion: nil)
        }else{
            navigationController!.popViewControllerAnimated(true)
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if PostButton === sender{
            let mealName = mealNameTextField.text ?? ""
            let price = String(priceTextField ?? "")
//            let photo = photoImageView.image
            let tasteRating = Double(tasteRatingControl.rating)
            let comment = commentTextField.text ?? ""
            meal = Meal(mealName: mealName, price: price,tasteRating: tasteRating,  comment: comment)
            
            
            
            
            //Mark: save data in firebase
            
            let mealInfoDatabase: [String: AnyObject] = ["mealName": mealName ,"price": price, "tasteRating": tasteRating,"comment": comment]
            let mealReference = FIRDatabase.database().reference()
            
            mealReference.child("Restaurants_comment").childByAutoId().setValue(mealInfoDatabase)
            
        }
        
        
        
    }
    
    
    
    
    
    //Mark: UITextFieldDelegate
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
//        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }

    
    
    //    func textFieldDidEndEditing(textField: UITextField) {
    //        mealNameLabel.text = textField.text
    //    }
    //
//    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        //打字的時候不能按post button
//        PostButton.enabled = false
//    }
//    
//    
//
//    func checkValidMealName(){
//        let mealNametext = mealNameTextField.text ?? ""
//        PostButton.enabled = !mealNametext.isEmpty
//    }
//    
//    func textFieldDidEndEditing(textField: UITextField) {
//    }
    
    
    
    
    
    
     //Mark: Action
    
   
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        //當點擊時 keyboard會關閉
//        mealNameTextField.resignFirstResponder()
//        priceTextField.resignFirstResponder()
//        commentTextField.resignFirstResponder()
        //Mark: create a image picker controller
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    
        
    
}







//Mark: 點選任意處可隱藏keyboard
extension UIViewController{
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
