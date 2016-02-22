//
//  SignUpViewController.swift
//  ParseDemo
//
//  Created by Caregivernet on 7/30/15.
//  Copyright (c) 2015 Caregivernet. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var teamNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailField.delegate = self;
        self.usernameField.delegate = self;
        self.passwordField.delegate = self;
        self.teamNameField.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func joinExistingTeam(sender: AnyObject){
        let username = self.usernameField.text
        let password = self.passwordField.text
        let email = self.emailField.text
        let teamName = self.teamNameField.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Validate the text fields
        if username!.characters.count < 5 {
            let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if password!.characters.count < 8 {
            let alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if email!.characters.count < 8 {
            let alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
            alert.show()

        } else if teamName!.characters.count < 1{
            let alert = UIAlertView(title: "Invalid", message: "Please enter a valid existing team code or a name for your new team", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
            
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let level = AccessLevel();
            let newUser = AppUser();
            
            do {
                let query = PFUser.query()
                if (teamName != "") {
                    query!.whereKey("TEAMNAME", equalTo:teamName!)
                    let result = try query!.findObjects()
                    // Check if given team name is still used (has team members)
                    if (result.count > 0) {
                        level.setInitialValues(false, legal: false, medical: false, personal: false, admin: false);
                        newUser.setInitialValues(username, password: password, email: finalEmail, teamname: teamName!, accessLevel: level);
                        
                    } else {
                        // Go back to original screen here
                        let alert = UIAlertView(title: "Error", message: "That team doesn't exist!", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                        return;
                    }
                    
                } else {
                    // Go back to original screen here
                    let alert = UIAlertView(title: "Error", message: "Enter a teamName please.", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    return;
                    
                }
                
                
            } catch {}
            
            level.update();
            newUser.update();
            
            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    let alert = UIAlertView(title: "Error", message: "Error\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                } else {
//                    let alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
//                    alert.show();
                    
                    // Create NFObject to notify admin
                    let justAdmin = AccessLevel();
                    justAdmin.setInitialValues(true, legal: true, medical: true, personal: true, admin: true);
                    justAdmin.update();
                    print("created justAdmin");
                    let newUserInTeam = NFObject();
                    newUserInTeam.setInitialValues(username! + "has joined your team! Please go to your manage team page to set their access level.", username: username!, teamName: teamName!, level: justAdmin, imageData: nil);
                    newUserInTeam.update();
                    print("createdNewUserInTeam");
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                }
            })
        }

        
    }

    @IBAction func createTeamAction(sender: AnyObject) {
        
        let username = self.usernameField.text
        let password = self.passwordField.text
        let email = self.emailField.text
        let teamName = self.teamNameField.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Validate the text fields
        if username!.characters.count < 5 {
            let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if password!.characters.count < 8 {
            let alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if email!.characters.count < 8 {
            let alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
            alert.show()

        } else if teamName!.characters.count < 1{
            let alert = UIAlertView(title: "Invalid", message: "Please enter a valid existing team code or a name for your new team", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        
            
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let level = AccessLevel();
            let newUser = AppUser();

            // Set admin level here
            do {
                let query = PFUser.query()
                if (teamName != "") {
                    query!.whereKey("TEAMNAME", equalTo:teamName!)
                    let result = try query!.findObjects()
                    // Make sure teamName doesn't return valid team
                    if (result.count == 0) {
                        // Creates admin here
                        level.setInitialValues(true, legal: true, medical: true, personal: true, admin: true);
                        newUser.setInitialValues(username, password: password, email: finalEmail, teamname: teamName!, accessLevel: level);

                        // Add hardcoded essentials
                        let query2=PFQuery(className: "Essentials");
                        query2.whereKey("DELETABLE", equalTo: false);
                        query2.whereKey("TEAMNAME",equalTo: "");
                        let results2 = try query2.findObjects()
                        for result in results2 {
                            let ess=result as! Essentials
                            ess.createCopy(teamName!)
                        }

                    } else {
                        // Go back to original screen here
                        let alert = UIAlertView(title: "Error", message: "That team already exists!", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                        return;

                    }
                } else {
                    // Go back to original screen here
                    let alert = UIAlertView(title: "Error", message: "Enter a teamName please.", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    return;

                }

                
            } catch {}
            
            level.update();
            newUser.update();

            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in

                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    let alert = UIAlertView(title: "Error", message: "Error\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                } else {
//                    let alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
//                    alert.show()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                }
            })
        }
    }
    
    // hide keyboard when you hit return or touch outside of the text field
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        teamNameField.resignFirstResponder()
        return true;
    }
}
