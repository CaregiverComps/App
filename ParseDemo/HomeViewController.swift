//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Show the current visitor's username
        if let user = PFUser.currentUser() as PFUser? {
            self.userNameLabel.text = "@" + user.username!;
            //level.setInitialValues(false, legal: false, medical: true, personal: false);
            //level.update();
            //let level: PFObject=user.objectForKey("ACCESSLEVEL") as! PFObject;
            //let object=NFObject( "Hello world!", teamName: "random", level: level,imageData: nil);
            //object.update();
            
            /*
            var query:PFQuery=PFQuery(className: "NFObject");
            query.whereKey(object.KEY_NAME, equalTo: AppUser.currentUser()!.getTeamName());
            for key in level.getAllowedAccess() {
            query.whereKey(key, equalTo: true);
            }
            query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if error == nil {
            // The find succeeded.
            print("Successfully retrieved \(objects!.count).")
            // Do something with the found objects
            if let objects = objects {
            for object in objects {
            print(object.objectId)
            }
            }
            } else {
            // Log details of the failure
            print("Error: \(error!) \(error!.userInfo)")
            }
            }
            */
        }
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
    
    @IBAction func logOutAction(sender: AnyObject){
        
        // Send a request to log out a user
        PFUser.logOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login") 
            self.presentViewController(viewController, animated: true, completion: nil)
        })
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
