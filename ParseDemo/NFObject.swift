//
//  NFObject.swift
//  ParseDemo
//
//  Created by Jonathan Brodie on 1/15/16.
//  Copyright (c) 2016 abearablecode. All rights reserved.
//

import Foundation
class NFObject : PFObject,PFSubclassing {
    let KEY_TEXT:String = "TEXT";
    let KEY_TEAMNAME:String = "TEAMNAME";
    let KEY_IMAGE:String = "IMAGE";
    let KEY_USERNAME: String = "USERNAME";
    
    let KEY_LEVEL:String = "ACCESSLEVEL";
    var LEVEL:AccessLevel = AccessLevel();
    var text:String = "";
    var username:String = "";
    var teamName:String = "";
    var imageData:NSData?;
    
    //we needed this to register the subclass for some reason
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    override init() {
        super.init();
    }
    
    func setInitialValues(starterText:String, username:String, teamName:String, level:AccessLevel, imageData: NSData?) {
        self.text=starterText;
        self.username=username;
        self.teamName=teamName;
        if let image = imageData {
            self.imageData = image;
        }
        self.LEVEL=level;
    }
    
    func update() {
        
        if let image = imageData {
            self.setObject(image, forKey: KEY_IMAGE);
        }
        //might need to update accesslevel
        self.setValue(self.text, forKey: KEY_TEXT);
        self.setValue(self.username, forKey: KEY_USERNAME);
        self.setValue(self.teamName, forKey: KEY_TEAMNAME);
        
        //need to alter this if we need to update access level dynamically, alter to:
        self.setObject(self.LEVEL,forKey: KEY_LEVEL);
        //for str in AccessLevel.KEY_ARRAY {
        //    self.setValue(LEVEL.valueForKey(str), forKey: str);
        //}
        self.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
    func setMessage(newText:String) {
        self.text=newText;
    }
    static func parseClassName() -> String {
        return "NFObject";
    }
    
    static func getNewsfeedFor(user:AppUser, categories:AccessLevel) -> PFQuery {
        let query=PFQuery(className: parseClassName());
        let teamName:String=user.getTeamName();
        let access:AccessLevel=user.getCaregiverAccessLevel();
        
        let query2=PFQuery(className: "AccessLevel");
        let medicalBool:Bool=access.getMedicalAccess();
        let legalBool:Bool=access.getLegalAccess();
        let persBool:Bool=access.getPersonalAccess();
        let finanBool:Bool=access.getFinancialAccess();
        
        // Check user's access level and teamname
        if (teamName == "" || !medicalBool || !categories.getLocalMedicalAccess()) {
            query2.whereKey("medical", equalTo: false);
        }
        
        if (teamName == "" || !legalBool || !categories.getLocalLegalAccess()) {
            query2.whereKey("legal", equalTo: false);
        }
        if (teamName == "" || !finanBool || !categories.getLocalFinancialAccess()) {
            query2.whereKey("financial", equalTo: false);
        }
        if (teamName == "" || !persBool || !categories.getLocalPersonalAccess()) {
            query2.whereKey("personal", equalTo: false);
        }


        query2.whereKey("admin", equalTo: access.getAdminAccess());
        query.whereKey("TEAMNAME", equalTo: teamName);
        query.whereKey("ACCESSLEVEL", matchesQuery: query2);

        return query;
    }
}