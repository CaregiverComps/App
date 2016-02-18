//
//  NewsFeedTableViewCell.swift
//  Caregiving
//
//  Created by Julia Bindler on 1/24/16.
//  Copyright © 2016 Caregivernet. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: PFTableViewCell {
    
    
    @IBOutlet weak var cellText: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var sideColorView: UIView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var userName: UILabel!

    
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
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //        self.backgroundColor = UIColor.redColor();
        
        //        if let image = UIImage(named: "Grandma.jpg") {
        //            self.picView!.image = image
        //        }
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}