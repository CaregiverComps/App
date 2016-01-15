//
//  AppUser.swift
//  ParseDemo
//
//  Created by Jonathan Brodie on 1/11/16.
//  Copyright (c) 2016 abearablecode. All rights reserved.
//

import Foundation

import Parse

class AppUser : PFUser {
    //weak or strong?
    //how do we do team names? set by user? User can select team to display in options?
    //maybe map team name to int to prevent collisions
    //also how should we do actually permit access
    //make access level from booleans
    static let ACCESSLEVEL_ADMIN=0;
    //static let ACCESSLEVEL_
    var teamName:String;
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
    
    init(username:String, password:String,email:String, teamname:String, accessLevel:AccessLevel?) {
        self.teamName=teamname;
        if let a = accessLevel {
            self.accessLevel=a;
        }
        else {
            self.accessLevel=AccessLevel(financial: false,legal: false,medical: false,personal: false);
        }

        super.init();
        self.username=username;
        self.password=password;
        self.email=email;
    }
    
    func getCaregiverAccessLevel() -> AccessLevel {
        return self.accessLevel;
    }
    func getTeamName() ->String {
        return self.teamName;
    }
    static func login(username:String, password:String, teamname:String, block:PFUserResultBlock) {
    PFUser.logInWithUsernameInBackground(username, password: password, block: block);
    }
    
}