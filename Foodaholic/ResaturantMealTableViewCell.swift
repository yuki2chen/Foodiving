//
//  CommentTableViewCell.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/9/30.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit

class ResaturantMealTableViewCell: UITableViewCell {
    
    
    //Mark: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!

    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
