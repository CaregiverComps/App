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
    //how do we do team names? set by user? 
    var teamName:String;
    var accessLevel:Int;
    
    //we needed this to register the subclass for some reason
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    init(username:String, password:String,email:String, teamname:String, accessLevel:Int?) {
        self.teamName=teamname;
        if let a = accessLevel {
            self.accessLevel=a;
        }
        else {
            self.accessLevel=0;
        }

        super.init();
        self.username=username;
        self.password=password;
        self.email=email;
    }
    
    func setCaregiverAccessLevel(newLevel:Int) {
        self.accessLevel=newLevel;
    }
    func getCaregiverAccessLevel() -> Int {
        return self.accessLevel;
    }
    func getTeamName() ->String {
        return self.teamName;
    }
    
}