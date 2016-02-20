//
//  DetailLocalResourcesViewController.swift
//  Caregiving
//
//  Created by Camille on 2/14/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit

class DetailLocalResourcesViewController: UITableViewController {
    @IBOutlet weak var detailTitle: UINavigationItem!
    var passedValue:String?
    
    @IBOutlet weak var descriptionTextView: UITextView!
//    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionTableViewCell: UITableViewCell!
    @IBOutlet weak var phoneTableViewCell: UITableViewCell!
    @IBOutlet weak var websiteTableViewCell: UITableViewCell!
    @IBOutlet weak var addressTableViewCell: UITableViewCell!
    
    var tempDescription = "Replace the description. Replace the description. Replace the description. Replace the description. Replace the description. Replace the description. Replace the description. Replace the description. Replace the description. Replace the description. "
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailTitle.title = self.passedValue
        self.descriptionTextView.text = self.tempDescription
        
    }
    
    func passedValue(passed: String) {
        self.passedValue = passed
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Set cell selected as currentCell
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        if(currentCell == phoneTableViewCell){
            print("selected phone number")
            // action to call number with phone
        } else if (currentCell == websiteTableViewCell){
            print("selected website URL")
            // action to go use safari with this url
        } else if (currentCell == addressTableViewCell) {
            print("selected address")
            //action to go to maps
        }
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
}


