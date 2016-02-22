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
    @IBOutlet weak var contactNameTableViewCell: UITableViewCell!
    @IBOutlet weak var emailTableViewCell: UITableViewCell!
    @IBOutlet weak var phoneTableViewCell: UITableViewCell!
    @IBOutlet weak var websiteTableViewCell: UITableViewCell!
    @IBOutlet weak var addressTableViewCell: UITableViewCell!
    
    // Assigned from previous View Controller
    var passedValue:LocalResources?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the cells with appropriate information
        self.detailTitle.title = self.passedValue?.resourceName;
        self.resourceImageView.image = UIImage(named: (self.passedValue?.imageName)!);
        self.descriptionTextView.text = self.passedValue?.body;
        self.contactNameTableViewCell.textLabel?.text = self.passedValue?.contactName
        self.phoneTableViewCell.textLabel?.text=self.passedValue?.phoneNumber
        self.emailTableViewCell.textLabel?.text = self.passedValue?.email
        self.websiteTableViewCell.textLabel?.text=self.passedValue?.website
        self.addressTableViewCell.textLabel?.text=self.passedValue?.address
        
    }
    
    
    /**
        Collapsing contact row if information is N/A
     */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Set description size
        if(indexPath.section == 0) { return 146 }
        
        // Hide contact name cell if needed
        if(indexPath.section == 1 && indexPath.item == 0) {
            if(self.passedValue?.contactName == "") {
                return 0
            }
        }
        
        // Hide phone number cell if needed
        if(indexPath.section == 1 && indexPath.item == 1) {
            if(self.passedValue?.phoneNumber == "") {
                return 0
            }
        }
        // Hide email cell if needed
        if(indexPath.section == 1 && indexPath.item == 2) {
            if(self.passedValue?.email == "") {
                return 0
            }
        }
        // Hide website cell if needed
        if(indexPath.section == 1 && indexPath.item == 3) {
            if(self.passedValue?.website == "") {
                return 0
            }
        }
        // Hide address cell if needed
        if(indexPath.section == 1 && indexPath.item == 4) {
            if(self.passedValue?.address == "") {
                return 0
            }
        }
        
        return 50
    }
    
    
    /**
        Handle row selection
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Set cell selected as currentCell
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        if(currentCell == phoneTableViewCell){

            let phoneNumber = phoneTableViewCell.textLabel!.text!
            // action to call number with phone
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://"+"\(phoneNumber)")!)
            
        } else if (currentCell == emailTableViewCell){
            
            let email = emailTableViewCell.textLabel!.text!
            // action to go email contact
            UIApplication.sharedApplication().openURL(NSURL(string: "mailto:\(email)")!)
            
        } else if (currentCell == websiteTableViewCell){
            
            let websiteURL = websiteTableViewCell.textLabel!.text!
            // action to go use safari with this url
            UIApplication.sharedApplication().openURL(NSURL(string: "http://"+"\(websiteURL)")!)
            
        } else if (currentCell == addressTableViewCell) {
            
            let latitude = self.passedValue?.latitude
            let longitude = self.passedValue?.longitude
            // action to go to maps with coordinates
            let targetURL = NSURL(string: "http://maps.apple.com/?q=\(latitude!),\(longitude!)")!
            UIApplication.sharedApplication().openURL(targetURL)
        }
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}


