//
//  OtherUserViewController.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/10/18.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit
import Nuke

class OtherUserViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhotoImage: UIImageView!
    @IBOutlet weak var otherUserMealView: UICollectionView!
    var meal: Meal?
    var mealPhotoStringArray: [String] = []
    private let reuseIdentifier = "OtherCollectionCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otherUserMealView.delegate = self
        otherUserMealView.dataSource = self
        
        userNameLabel.text = meal?.userName
        let userphotoURL = NSURL(string: (meal?.userPhotoString)!)
        let userphotoData = NSData(contentsOfURL: userphotoURL!)
        userPhotoImage.image = UIImage(data: userphotoData!)

        mealPhotoStringArray.append((meal?.photoString)!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        if let mealPhotoURL = NSURL(string:mealPhotoString){
            
            cellsquare.photoImage.nk_setImageWith(mealPhotoURL)
            
        }
      return cellsquare
    }

    
    
}
