//
//  LocalResources.swift
//  Caregiving
//
//  Created by care2 on 2/8/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import Foundation
class LocalResources : PFObject,PFSubclassing {
    let KEY_RESOURCEDESCRIPTION:String = "RESOURCEDESCRIPTION";
    let KEY_IMAGE:String = "IMAGE";
    let KEY_PHONENUMBER:String = "PHONENUMBER";
    let KEY_EMAIL:String = "EMAIL";
    let KEY_CONTACTNAME:String = "CONTACTNAME";
    let KEY_LATITUDE:String = "LATITUDE";
    let KEY_LONGITUDE:String = "LONGITUDE";
    let KEY_RESOURCENAME:String = "RESOURCENAME";
    
    
    var body:String=""
    var phoneNumber:String = ""
    var email:String = "";
    var resourceName:String=""
    var contactName:String = ""
    var latitude:Double = 0.0;
    var longitude:Double = 0.0;
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
    
    func setInitialValues(starterBody:String, resourceName: String, contactName: String, phoneNumber: String, email: String, latitude:Double, longitude:Double, image:NSData?) {
        self.body=starterBody;
        self.resourceName=resourceName;
        self.contactName = contactName;
        self.phoneNumber = phoneNumber;
        self.email = email;
        self.latitude = latitude;
        self.longitude = longitude;
        if let img=image as NSData? {
            self.imageData=img;
        }
    }
    
    func update() {
        //might need to update accesslevel
        self.setValue(self.body, forKey: KEY_RESOURCEDESCRIPTION);
        self.setValue(self.resourceName, forKey: KEY_RESOURCENAME);
        self.setValue(self.contactName, forKey: KEY_CONTACTNAME);
        self.setValue(self.phoneNumber, forKey: KEY_PHONENUMBER);
        self.setValue(self.email, forKey: KEY_EMAIL);
        self.setValue(self.latitude, forKey: KEY_LATITUDE);
        self.setValue(self.longitude, forKey: KEY_LONGITUDE);
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