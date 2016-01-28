//
//  NFObject.swift
//  ParseDemo
//
//  Created by Jonathan Brodie on 1/15/16.
//  Copyright (c) 2016 abearablecode. All rights reserved.
//

import Foundation
import Parse
class NFObject : PFObject,PFSubclassing {
    let KEY_TEXT:String = "TEXT";
    let KEY_NAME:String = "TEAMNAME";
    let KEY_IMAGE:String = "IMAGE"
    
    let KEY_LEVEL:String = "ACCESSLEVEL";
    var LEVEL:AccessLevel = AccessLevel();
    var text:String = "";
    var name:String = "";
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
    
    func setInitialValues(starterText:String, teamName:String, level:AccessLevel, imageData: NSData?) {
        self.text=starterText;
        self.name=teamName;
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
        self.setValue(self.name, forKey: KEY_NAME);
        
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
}