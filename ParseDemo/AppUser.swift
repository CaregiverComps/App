//
//  AppUser.swift
//  ParseDemo
//
//  Created by Jonathan Brodie on 1/11/16.
//  Copyright (c) 2016 abearablecode. All rights reserved.
// http://stackoverflow.com/questions/24036393/fatal-error-use-of-unimplemented-initializer-initcoder-for-class
//

import Foundation

import Parse

class AppUser : PFUser{
    //weak or strong?
    //how do we do team names? set by user? User can select team to display in options?
    //maybe map team name to int to prevent collisions
    //also how should we do actually permit access
    //make access level from booleans
    static let ACCESSLEVEL_ADMIN=0;
    let KEY_ACCESSLEVEL:String = "ACCESSLEVEL";
    let KEY_TEAMNAME:String = "TEAMNAME";
    var teamName:String = "";
    var accessLevel:AccessLevel = AccessLevel();
    
    //we needed this to register the subclass for some reason
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    override init()
    {
        super.init()
    }
    
    func setInitialValues(username:String, password:String,email:String, teamname:String, accessLevel:AccessLevel?) {
        self.teamName=teamname;
        if let a = accessLevel {
            self.accessLevel=a;
        }
        else {
            self.accessLevel=AccessLevel();
        }
        self.username=username;
        self.password=password;
        self.email=email;
    }
    
    func update() {
        self.setObject(self.accessLevel, forKey: KEY_ACCESSLEVEL);
        self.setValue(self.teamName, forKey: KEY_TEAMNAME);
        self.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("OBJECT SUCCESSFULLY SAVED");
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
    
    func getCaregiverAccessLevel() -> AccessLevel {
        self.accessLevel.update();
        return self.accessLevel;
    }
    func getTeamName() ->String {
        return self.teamName;
    }
    static func login(username:String, password:String, block:PFUserResultBlock) {
        PFUser.logInWithUsernameInBackground(username, password: password, block: block);
    }
    //TO-DO: FIX THIS
    override static func currentUser() -> AppUser {
        //use name, password to query database and return the user object associated with it
        let current=super.currentUser();
        let query:PFQuery=PFQuery(className: "PFUser");
        print(current!.username!);
        query.whereKey("username", equalTo: current!.username!);

        var currentObject:AppUser=AppUser();
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count).")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        currentObject=object as! AppUser;
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        return currentObject;
    }
    
    
}