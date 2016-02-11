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
    var userSelected:AppUser=AppUser()
    var team:[AppUser?]=[AppUser?]()
    var teamList = ["Amy","DLN","Jadrian"]
//    let teamList = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if (teamList.count>0) {
            noTeamMemberLabel.hidden = true
        }
        //pseudocode
        if let user=AppUser.currentUser() as AppUser? {
            teamList.removeAll()
            team = user.getTeamMembers();
            print("here in vc")

            for member in team {
                var unwrappedUser:AppUser=member!
                teamList.append(unwrappedUser.username!)
            }
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
        let name = currentCell.textLabel!.text!
        
        for user in team {
            if (user?.username! == name) {
                self.userSelected=user!
            }
        }
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

