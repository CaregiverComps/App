//
//  ManageTeamViewController.swift
//  Caregiving
//
//  Created by Camille on 2/8/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit

class ManageTeamViewController: UITableViewController {
    @IBOutlet weak var noTeamMemberLabel: UILabel!
//    @IBOutlet weak var teamMemberCell: UITableViewCell!
    var userSelected = ""
    let teamList = ["Amy","DLN","Jadrian"]
//    let teamList = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if (teamList.count>0) {
            noTeamMemberLabel.hidden = true
        }
        
        
        
        // Show the current visitor's username
//        if let user = PFUser.currentUser() as PFUser? {
//            self.userNameLabel.text = "@" + user.username!;
//        }
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamList.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        if (teamList.count > 0) {
            cell.textLabel?.text = self.teamList[indexPath.row] 
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        print(currentCell.textLabel!.text)
        self.userSelected = currentCell.textLabel!.text!
        performSegueWithIdentifier("ShowUserSegue", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "ShowUserSegue") {
            
            // initialize new view controller and cast it as your view controller
            var viewController = segue.destinationViewController as! UserAccessViewController
            // your new view controller should have property that will store passed value
            viewController.passedValue(self.userSelected)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    
}

