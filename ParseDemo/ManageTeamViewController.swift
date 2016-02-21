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
    
    
    
    @IBOutlet weak var addMemberButton: UIBarButtonItem!
    
    
    
    var userSelected:AppUser=AppUser()
    var team:[AppUser?]=[AppUser?]()
    var teamList = ["Amy","DLN","Jadrian"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if let user=AppUser.currentUser() as AppUser? {
            teamList.removeAll()
            team = user.getTeamMembers();
            if (!user.getCaregiverAccessLevel().getAdminAccess()) {
                noTeamMemberLabel.text="You are not authorized to view this page."
                addMemberButton.enabled=false
                addMemberButton.tintColor=UIColor.clearColor()
            }
                
            else {
                if (team.count>1) {
                    noTeamMemberLabel.hidden = true
                }
                    for member in team {
                        let unwrappedUser:AppUser=member!
                        if (unwrappedUser.username != user.username) {
                            teamList.append(unwrappedUser.username!)
                    }
                }
            }
        }
        
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
            let viewController = segue.destinationViewController as! UserAccessViewController
            // your new view controller should have property that will store passed value
            viewController.passedValue(self.userSelected)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

