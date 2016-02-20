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
    var passedValue:String?
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionTableViewCell: UITableViewCell!
    var resourceDescription = "This is where the resource description goes. This is where the resource description goes. This is where the resource description goes. This is where the resource description goes. This is where the resource description goes. This is where the resource description goes. This is where the resource description goes. This is where the resource description goes. This is where the resource description goes. "
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailTitle.title = self.passedValue
//        self.descriptionTextView.text = self.resourceDescription
        
    }
    
    func passedValue(passed: String) {
        self.passedValue = passed
    }
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 6
//        
//    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


