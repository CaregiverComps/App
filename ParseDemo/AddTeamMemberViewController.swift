//
//  AddTeamMemberViewController.swift
//  Caregiving
//
//  Created by Camille on 2/16/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit

class AddTeamMemberViewController: UIViewController {
    
    @IBOutlet weak var addedTeamMemberTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func addUserAction(sender: UIButton) {
        
        // Animate to previous view controller
        navigationController?.popViewControllerAnimated(true)
        
        print(addedTeamMemberTextField!.text)
        
        
    }

    
}
