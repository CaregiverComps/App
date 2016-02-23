//
//  LocalResources.swift
//  Caregiving
//
//  Created by care2 on 2/8/16.
//  Copyright © 2016 CaregiverNet. All rights reserved.
//

import Foundation
class LocalResources : PFObject,PFSubclassing {
    let KEY_RESOURCEDESCRIPTION:String = "RESOURCEDESCRIPTION";
    let KEY_IMAGE:String = "IMAGE";
    let KEY_PHONENUMBER:String = "PHONENUMBER";
    let KEY_EMAIL:String = "EMAIL";
    let KEY_WEBSITE:String = "WEBSITE";
    let KEY_CONTACTNAME:String = "CONTACTNAME";
    let KEY_LATITUDE:String = "LATITUDE";
    let KEY_LONGITUDE:String = "LONGITUDE";
    let KEY_RESOURCENAME:String = "RESOURCENAME";
    let KEY_ADDRESS:String = "ADDRESS";
    let KEY_IMAGENAME:String = "IMAGENAME"
    
    
    var body:String=""
    var phoneNumber:String = ""
    var email:String = "";
    var website:String = "";
    var resourceName:String=""
    var contactName:String = ""
    var latitude:Double = 0.0;
    var longitude:Double = 0.0;
    var address:String = "";
    var imageName:String = "";
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
    
    func setInitialValues(starterBody:AnyObject?, resourceName: AnyObject?, contactName: AnyObject?, phoneNumber: AnyObject?, email: AnyObject?, website: AnyObject?, latitude:AnyObject?, longitude:AnyObject?, address:AnyObject?, imageName:AnyObject?, image:AnyObject?) {
        if let text=starterBody as? String {
            self.body=text;
        }
        if let name=resourceName as? String {
            self.resourceName=name
        }
        if let cname=contactName as? String {
            self.contactName=cname
        }
        if let phone=phoneNumber as? String {
            self.phoneNumber=phone
        }
        if let em=email as? String {
            self.email=em
        }
        if let web=website as? String {
            self.website=web
        }
        if let lat=latitude as? Double {
            self.latitude=lat
        }
        if let lon=longitude as? Double {
            self.longitude=lon
        }
        if let addr=address as? String {
            self.address=addr
        }
        if let imgnm=imageName as? String {
            self.imageName=imgnm
        }
        if let img=image as? NSData {
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
        self.setValue(self.website, forKey: KEY_WEBSITE);
        self.setValue(self.latitude, forKey: KEY_LATITUDE);
        self.setValue(self.longitude, forKey: KEY_LONGITUDE);
        self.setValue(self.address, forKey: KEY_ADDRESS);
        self.setValue(self.imageName, forKey: KEY_IMAGENAME);
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
        return "LocalResources";
    }
    static func getLocalResources() -> [LocalResources] {
        var resourceArray:[LocalResources]=[LocalResources]()
        let query:PFQuery=PFQuery(className: parseClassName())
        do {
            let objects:[PFObject]?=try query.findObjects()
            if let resources:[PFObject]=objects {
                
                for resource in resources {
                    let newResource=LocalResources()
                    let description=resource.valueForKey(newResource.KEY_RESOURCEDESCRIPTION)
                    let name=resource.valueForKey(newResource.KEY_RESOURCENAME)
                    let contactName=resource.valueForKey(newResource.KEY_CONTACTNAME)
                    let num=resource.valueForKey(newResource.KEY_PHONENUMBER)
                    let email=resource.valueForKey(newResource.KEY_EMAIL)
                    let website=resource.valueForKey(newResource.KEY_WEBSITE)
                    let lat=resource.valueForKey(newResource.KEY_LATITUDE)
                    let lon=resource.valueForKey(newResource.KEY_LONGITUDE)
                    let imgnm=resource.valueForKey(newResource.KEY_IMAGENAME)
                    let addr=resource.valueForKey(newResource.KEY_ADDRESS)
                    //let image=resource.valueForKey(newResource.KEY_IMAGE) as? NSData
                    newResource.setInitialValues(description, resourceName: name, contactName: contactName, phoneNumber: num, email: email, website: website, latitude: lat, longitude: lon, address: addr, imageName: imgnm, image: nil)
                    resourceArray.append(newResource)
                }
            }
        }
        catch {
            print("Error in getResources()")
        }
        return resourceArray;
        
    }
    
    
    
    
}