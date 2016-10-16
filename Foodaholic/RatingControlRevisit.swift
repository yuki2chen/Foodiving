//
//  RatingControlRevisit.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/10/15.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit

class RatingControlRevisit: UIView {
    
    //Mark: Properties
    
    var rating = 0{
        didSet{
            setNeedsLayout()
        }
    }
    var ratingButtons = [UIButton]()
    
    
    
    //Mark: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let filledRatePicture = UIImage(named: "loveface")
        let emptyRatePicture = UIImage(named: "blackface")
        
        for _ in 0..<5{
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            
            button.setImage(filledRatePicture, forState: .Selected)
            button.setImage(emptyRatePicture, forState: .Normal)
            button.setImage(filledRatePicture, forState: [.Highlighted, .Selected])
            
            
            // ???
            button.reversesTitleShadowWhenHighlighted = false
            button.highlighted = false
            //            button.showsTouchWhenHighlighted = false
            //            button.adjustsImageWhenHighlighted = false
            
            button.addTarget(self, action: #selector(RatingControlRevisit.ratingButtonTapped(_:)), forControlEvents: .TouchDown)
            ratingButtons += [button]
            addSubview(button)
        }
        return
    }
    
    override func layoutSubviews() {
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        for (index,button) in ratingButtons.enumerate(){
            buttonFrame.origin.x = CGFloat(index * (buttonSize + 5))
            button.frame = buttonFrame
        }
        updateButtonSelectionStates()
    }
    
    
    
    
    
    
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 25, height: 25)
    }
    
    func ratingButtonTapped(button: UIButton){
        rating = ratingButtons.indexOf(button)! + 1
        
        updateButtonSelectionStates()
        
        print("Button pressed")
    }
    
    
    
    
    
    func updateButtonSelectionStates(){
        for (index,button) in ratingButtons.enumerate(){
            button.selected = index < rating
        }
    }
    
    
    
}

