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
    @IBOutlet weak var resourceImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var phoneTableViewCell: UITableViewCell!
    @IBOutlet weak var websiteTableViewCell: UITableViewCell!
    @IBOutlet weak var addressTableViewCell: UITableViewCell!
    
    var passedValue:LocalResources?
    
    var tempDescription = "Replace the description. Replace the description. Replace the description. Replace the description. Replace the description. Replace the description. Replace the description. Replace the description. Replace the description. Replace the description. "
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the cells with appropriate information
        self.detailTitle.title = self.passedValue?.resourceName;
        self.resourceImageView.image = UIImage(named: (self.passedValue?.imageName)!);//"actonalzheimers.png"
        self.descriptionTextView.text = self.passedValue?.body;
        self.phoneTableViewCell.textLabel?.text=self.passedValue?.phoneNumber
        self.websiteTableViewCell.textLabel?.text=self.passedValue?.website
        self.addressTableViewCell.textLabel?.text=self.passedValue?.address
        
        if(self.passedValue?.phoneNumber == "") {
            self.phoneTableViewCell.hidden = true
        }
        
        
    }
    
    /**
        Passing string from last view controller
     
     */
    func passedValue(passed: LocalResources) {
        self.passedValue = passed;
    }
    
    /**
     Collapsing contact row if N/A
     */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Set description size
        if(indexPath.section == 0) {
            return 146
        }
        // Hide phone number cell
        if(indexPath.section == 1 && indexPath.item == 0) {
            if(self.passedValue?.phoneNumber == "") {
                return 0
            } else {
                return 44
            }
        }
        // Hide website cell
        if(indexPath.section == 1 && indexPath.item == 1) {
            if(self.passedValue?.website == "") {
                return 0
            } else {
                return 44
            }
        }
        // Hide address cell
        if(indexPath.section == 1 && indexPath.item == 2) {
            if(self.passedValue?.address == "") {
                return 0
            } else {
                return 44
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Set cell selected as currentCell
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        if(currentCell == phoneTableViewCell){
            print("selected phone number")
            
            // get resource phone number
            var phoneNumber = phoneTableViewCell.textLabel!.text!
            
            // action to call number with phone
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://"+"\(phoneNumber)")!)
            
            
        } else if (currentCell == websiteTableViewCell){
            print("selected website URL")
            
            // get resource phone number
            var websiteURL = websiteTableViewCell.textLabel!.text!
            // action to go use safari with this url
            UIApplication.sharedApplication().openURL(NSURL(string: "http://"+"\(websiteURL)")!)
            
            
        } else if (currentCell == addressTableViewCell) {
            print("selected address")
            
            var latitude = "40.7127837"
            var longitude = "-74.00594130000002"
            //action to go to maps
            let targetURL = NSURL(string: "http://maps.apple.com/?ll=\(latitude),\(longitude)")!
            let isAvailable = UIApplication.sharedApplication().canOpenURL(targetURL)
            UIApplication.sharedApplication().openURL(targetURL)
        }
        
        
    }
    
    
    
    @IBAction func shareResourceAction(sender: AnyObject) {
        //Press 'action' button to share (as a contact?)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
}


