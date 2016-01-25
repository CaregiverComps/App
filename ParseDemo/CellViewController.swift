//
//  CellViewController.swift
//  Caregiving
//
//  Created by Julia Bindler on 1/24/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit

class CellViewController: PFTableViewCell {
    

    @IBOutlet weak var picView: UIImageView!

    

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
