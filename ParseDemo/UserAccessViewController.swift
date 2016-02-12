//
//  UserAccessViewController.swift
//  Caregiving
//
//  Created by Camille on 2/8/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit

class UserAccessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var accessTableView: UITableView!
    @IBOutlet weak var navTitle: UINavigationItem!
    let categories = ["Personal","Legal","Financial","Medical"]
    var passedValue:AppUser = AppUser();
    
    @IBOutlet weak var deleteUser: UIButton!
    @IBAction func deleteUser(sender: UIButton) {
        AppUser.deleteUserFromTeam(passedValue.username!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.userNameLabel.text = self.passedValue
        self.navTitle.title = self.passedValue.username!
        // Show the current visitor's username
        //        if let user = PFUser.currentUser() as PFUser? {
        //            self.userNameLabel.text = "@" + user.username!;
        //        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
        
    }
    
    
    func passedValue(passed: AppUser) {
        self.passedValue = passed
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        let thisCategory:String = self.categories[indexPath.row]
        cell.textLabel?.text = thisCategory
        var access:Bool=false

        
        let userAccessLevel = passedValue.getCaregiverAccessLevel();

        if (thisCategory == "Personal") {
            access = userAccessLevel.getPersonalAccess();
        }
        if (thisCategory == "Legal") {
            access = userAccessLevel.getLegalAccess();
        }
        if (thisCategory == "Financial") {
            access = userAccessLevel.getFinancialAccess();
        }
        if (thisCategory == "Medical") {
            access = userAccessLevel.getMedicalAccess();
        }


        let enabledSwitch = UISwitch() as UISwitch
        enabledSwitch.on = access
        cell.accessoryView = enabledSwitch
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
