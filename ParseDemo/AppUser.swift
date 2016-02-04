//
//  AppUser.swift
//  ParseDemo
//
//  Created by Jonathan Brodie on 1/11/16.
//  Copyright (c) 2016 abearablecode. All rights reserved.
// http://stackoverflow.com/questions/24036393/fatal-error-use-of-unimplemented-initializer-initcoder-for-class
//

import Foundation


class AppUser : PFUser {
    //weak or strong?
    //how do we do team names? set by user? User can select team to display in options?
    //maybe map team name to int to prevent collisions
    //also how should we do actually permit access
    //make access level from booleans
    static let ACCESSLEVEL_ADMIN=0;
    static let KEY_ACCESSLEVEL:String = "ACCESSLEVEL";
    static let KEY_TEAMNAME:String = "TEAMNAME";
    let KEY_ACCESSLEVEL:String = "ACCESSLEVEL";
    let KEY_TEAMNAME:String = "TEAMNAME";
    var teamName:String = "";
    var accessLevel:AccessLevel;
    
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
        accessLevel=AccessLevel();
        super.init()
    }
    
    func setInitialValues(username:String, password:String,email:String, teamname:String, accessLevel:AccessLevel?) {
        self.teamName=teamname;
        if let a = accessLevel {
            self.accessLevel=a;
//            print(self.accessLevel.getFinancialAccess())
//            print(self.accessLevel)
        }
        else {
            self.accessLevel=AccessLevel();
            self.accessLevel.setInitialValues(true, legal: false, medical: false, personal: true, admin: true)

        }
        self.username=username;
        self.password=password;
        self.email=email;
    }
    
    func update() {
        print("UPDATING ACCESS LEVEL ", self.accessLevel);
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
        //self.accessLevel.update();
        return self.accessLevel;
    }
    func getTeamName() ->String {
        return self.teamName;
    }
    static func login(username:String, password:String, block:PFUserResultBlock) {
        PFUser.logInWithUsernameInBackground(username, password: password, block: block);
    }
    
    //TO-DO: FIX THIS
    override static func currentUser() -> AppUser? {
        //use name, password to query database and return the user object associated with it
        if let currentuser = super.currentUser() as PFUser? {
            let accessID=currentuser.objectForKey("ACCESSLEVEL") as! PFObject;
            print(accessID)
            let id=accessID.objectId;
            let query=PFQuery(className: "AccessLevel");

            /*
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                query.getObjectInBackgroundWithId(id!, block: {
                    (result,error) -> Void in
                    print("here???")
                    ready=true;
                    if (error == nil) {
                        let usrname=currentuser.username;
                        let level:AccessLevel=result as! AccessLevel;
                        let teamname=currentuser.valueForKey(KEY_TEAMNAME) as! String;
                        print("Teamname: "+teamname);
                        let pass=currentuser.password;
                        print(usrname);
                        let email=currentuser.email;
                        print(email);
                        realCurrentuser.setInitialValues(currentuser.username!, password: "", email: email!, teamname: teamname, accessLevel: level);
                        ready=true;
                    }
                });
                
                dispatch_async(dispatch_get_main_queue()) {
                          return realCurrentuser;
                }
            }
        }
*/
        
            do {
                let result=try query.getObjectWithId(id!);
                let usrname=currentuser.username;
                let level:AccessLevel=result as! AccessLevel;
                print(level)
                let teamname=currentuser.valueForKey(KEY_TEAMNAME) as! String;
                print(teamname);
                let pass=currentuser.password;
                print(usrname);
                print(pass);
                let email=currentuser.email;
                print(email);
                let realCurrentuser=AppUser();
                realCurrentuser.setInitialValues(currentuser.username!, password: "", email: email!, teamname: teamname, accessLevel: level);
                
                return realCurrentuser;
            }
            catch {
                print("ERROR");
            }
        }
        return nil;
    }
    
    /*
    ** If current user is admin and is of the same team,
    ** change specified user's teamName to "" and set access level to all false.
    */
    static func deleteUserFromTeam(username:String) {
        let currentUser = AppUser.currentUser()!;
        if (currentUser.getCaregiverAccessLevel().getAdminAccess()) {
            let query=PFQuery(className: parseClassName());
            query.whereKey("username", equalTo: username);
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    let userToDelete = objects![0] as! AppUser;
                    if (userToDelete.getTeamName() == currentUser.getTeamName()) {
                        // Teamcode required to have length of at least one
                        userToDelete.setValue("", forKey: KEY_TEAMNAME);
                        userToDelete.getCaregiverAccessLevel().setInitialValues(false, legal: false, medical: false,        personal: false, admin: false);
                        userToDelete.update();
                    }
                    else {
                        print("Could not find user with that name.");
                    }
                }
            }
        } else {
            print("Current user is not authorized to remove members.");
        }
    }
    
    static func addUserToTeam(username:String) {
        let currentUser = AppUser.currentUser()!;
        if (currentUser.getCaregiverAccessLevel().getAdminAccess()) {
            let query=PFQuery(className: parseClassName());
            query.whereKey("username", equalTo: username);
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    let userToAdd = objects![0] as! AppUser;
                    
                    // In V2, see if we can have some kind of confirmation system
                    if (userToAdd.getTeamName() == "") {
                        // Teamcode required to have length of at least one
                        userToAdd.setValue(currentUser.getTeamName(), forKey: KEY_TEAMNAME);
                        userToAdd.getCaregiverAccessLevel().setInitialValues(false, legal: false, medical: false,        personal: false, admin: false);
                        userToAdd.update();
                    }
                }
            }
        } else {
            print("Current user is not authorized to add members.");
        }
    }
    
}