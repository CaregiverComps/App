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
    var passedValue = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.userNameLabel.text = self.passedValue
        self.navTitle.title = self.passedValue
        // Show the current visitor's username
        //        if let user = PFUser.currentUser() as PFUser? {
        //            self.userNameLabel.text = "@" + user.username!;
        //        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
        
    }
    
    
    func passedValue(passed: String) {
        self.passedValue = passed
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        if (categories.count > 0) {
            cell.textLabel?.text = self.categories[indexPath.row] as String
        }

        let enabledSwitch = UISwitch() as UISwitch
//        enabledSwitch.on = false
        cell.accessoryView = enabledSwitch
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
