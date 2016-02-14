//
//  DetailLocalResourcesViewController.swift
//  Caregiving
//
//  Created by Camille on 2/14/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit

class DetailLocalResourcesViewController: UIViewController {
    @IBOutlet weak var detailTitle: UINavigationItem!
    var passedValue = "";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailTitle.title = self.passedValue
        
        
    }
    
    func passedValue(passed: String) {
        self.passedValue = passed
    }
    
    
    
    
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


