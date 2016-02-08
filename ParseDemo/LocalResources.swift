//
//  LocalResources.swift
//  Caregiving
//
//  Created by care2 on 2/8/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import Foundation
class LocalResources : PFObject,PFSubclassing {
    let KEY_RESOURCE_DESCRIPTION:String = "RESOURCEDESCRIPTION";
    let KEY_IMAGE:String = "IMAGE";
    let KEY_RESOURCE_NAME:String = "RESOURCENAME";
    var body:String=""
    var name:String=""
    var imageData:NSData=NSData();
    
    
    
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
    
    func setInitialValues(starterText:String, starterName: String, image:NSData?) {
        self.body=starterText;
        self.name=starterName;
        if let img=image as NSData? {
            self.imageData=img;
        }
    }
    
    func update() {
        //might need to update accesslevel
        self.setValue(self.body, forKey: KEY_RESOURCE_DESCRIPTION);
        self.setValue(self.name, forKey: KEY_RESOURCE_NAME);
        
        self.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
    func setDescription(newText:String) {
        self.body=newText;
    }
    static func parseClassName() -> String {
        return "Local Resources";
    }
    
    
    
    
}