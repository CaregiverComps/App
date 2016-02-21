//
//  LocalResourcesViewController.swift
//  Caregiving
//
//  Created by Camille on 2/14/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

//
//  LocalResourcesViewController.swift
//  Caregiving
//
//  Created by Camille on 2/12/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit

class LocalResourcesViewController: UITableViewController {
    var resourceList:[LocalResources] = []
    var resourceNames:[String] = []
    var resource=LocalResources()
    //var resource2=LocalResources()
    
//    @IBOutlet var resoucesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Change text in Navigation to white
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        if let user=AppUser.currentUser() as AppUser? {
            resourceList.removeAll()
            resourceList=LocalResources.getLocalResources()

            
            for resource in resourceList {
                resourceNames.append(resource.resourceName)
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourceList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        print(resourceList.count)
        if (resourceList.count > 0) {
            cell.textLabel?.text = self.resourceNames[indexPath.row]
            print(cell.textLabel?.text)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
    }

   /*
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        print(currentCell.textLabel!.text)
        var text=currentCell.textLabel!.text
        
        for resource in resourceList {
            if (text == resource.resourceName) {
                self.resource=resource
                print("=============")
                print(resource.resourceName)
                print(resource.body)
                print("=============")
            }
        }
        
        //        for user in team {
        //            if (user?.username! == name) {
        //                self.userSelected=user!
        //                print(self.userSelected.username!)
        //                print("*:", self.userSelected.getCaregiverAccessLevel())
        //            }
        //        }
        performSegueWithIdentifier("ShowDetailResourceSegue", sender: self)
        
    }*/
//
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "ShowDetailResourceSegue") {
            let indexPath=self.tableView.indexPathForSelectedRow!
            let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
            print(currentCell.textLabel!.text)
            var text=currentCell.textLabel!.text
            
            for resource in resourceList {
                if (text == resource.resourceName) {
                    self.resource=resource
                    print("=============")
                    print(resource.resourceName)
                    print(resource.body)
                    print("=============")
                }
            }
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! DetailLocalResourcesViewController
            // your new view controller should have property that will store passed value
            viewController.passedValue(self.resource)
        }
        
    }
    
    
    //    override func viewWillAppear(animated: Bool) {
    //        if (PFUser.currentUser() == nil) {
    //            dispatch_async(dispatch_get_main_queue(), { () -> Void in
    //
    //                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
    //                self.presentViewController(viewController, animated: true, completion: nil)
    //            })
    //        }
    //    }
    
    
    
    
    
    
    
}
