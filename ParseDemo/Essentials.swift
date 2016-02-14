//
//  Essentials.swift
//  Caregiving
//
//  Created by care2 on 2/2/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import Foundation

class Essentials : PFObject,PFSubclassing {
    let KEY_TEXT:String = "TEXT";
    let KEY_NAME:String = "TEAMNAME";
    let KEY_MARKED: String = "MARKED";
    let KEY_DELETABLE: String = "DELETABLE";
    let KEY_LEVEL:String = "ACCESSLEVEL";
    var LEVEL:AccessLevel = AccessLevel();
    
    var text:String = "";
    var name:String = "";
    var marked:Bool = false;
    var deletable:Bool = false;
    
    
    
    
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
    
    func setInitialValues(starterText:String, teamName:String, level:AccessLevel, Deletable:Bool) {
        self.text=starterText;
        self.name=teamName;
        self.marked = false;
        self.LEVEL=level;
        self.deletable=Deletable
    }
    
    func update() {
        //might need to update accesslevel
        self.setValue(self.text, forKey: KEY_TEXT);
        self.setValue(self.name, forKey: KEY_NAME);
        self.setValue(self.marked, forKey: KEY_MARKED);
        self.setValue(self.deletable, forKey:  "HARDCODED");
        print("updated deletable")
        self.setObject(self.LEVEL,forKey: KEY_LEVEL);
        
        self.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
    func changeStatus(){
        //call update after this method
        self.marked = !self.marked;
    }
    
    
    func getStatus() -> Bool{
        return self.marked;
    }
    
    func setMessage(newText:String) {
        self.text=newText;
    }
    static func parseClassName() -> String {
        return "Essentials";
    }
    
    static func getEssentialsFor(user:AppUser, categories:AccessLevel) -> PFQuery {
        var query=PFQuery(className: parseClassName());
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
        
        // Get hardcoded essentials
        let hardcoded=PFQuery(className: parseClassName());
        hardcoded.whereKey("deletable", equalTo: false);
        query = PFQuery.orQueryWithSubqueries([query, hardcoded]);
        query.whereKey("TEAMNAME", equalTo: teamName);
        query.whereKey("ACCESSLEVEL", matchesQuery: query2);
        
        return query;
    }
    
    // Helps copy hardcoded essentials into team's essentials list
    func createCopy(teamname:String) -> Essentials{
        let copyEssentials = Essentials();
        copyEssentials.setInitialValues(self.valueForKey(KEY_TEXT) as! String,teamName: teamname, level: self.LEVEL, Deletable: false)
        copyEssentials.update();
        return copyEssentials;
    }
    
    
    
}