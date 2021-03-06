//
//  MoreViewController.swift
//  Caregiving
//
//  Created by Camille on 2/8/16.
//  Copyright © 2016 CaregiverNet. All rights reserved.
//

import UIKit

class MoreViewController: UITableViewController {
    @IBOutlet weak var userNameLabel: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the current visitor's username
        if let user = PFUser.currentUser() as PFUser? {
            self.userNameLabel.text = user.username!;
        }
        
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    
    @IBAction func unwindToMoreScreen(segue:UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() == nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    

    
    
    @IBAction func logOutAction(sender: AnyObject) {
        // Send a request to log out a user
        PFUser.logOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
        })
    }

    
    
    
}

