//
//  NewsFeedTableViewCell.swift
//  Caregiving
//
//  Created by Stephen Grinich on 1/24/16.
//  Copyright © 2016 Caregivernet. All rights reserved.
//

import UIKit

class NewsFeedTableViewImageCell: PFTableViewCell {
    
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var picView: UIImageView!
//    @IBOutlet weak var cellText: UILabel!
//    
    override func layoutSubviews() {
        self.cardSetup()
    }
    
    func cardSetup(){
        self.cardView.alpha = 1
        self.cardView.layer.masksToBounds = false
        self.cardView.layer.cornerRadius = 1
        self.cardView.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        self.cardView.layer.shadowRadius = 1
        //        let path = UIBezierPath(rect: self.cardView.bounds)
        //        self.cardView.layer.shadowPath = path.CGPath
        //        self.cardView.layer.shadowOpacity = 0.2
        
        self.backgroundColor = UIColor(colorLiteralRed: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        
    }
//    
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }
    
}