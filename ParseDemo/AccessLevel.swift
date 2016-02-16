//
//  AccessLevel.swift
//  ParseDemo
//
//  Created by Jonathan Brodie on 1/14/16.
//  Copyright (c) 2016 abearablecode. All rights reserved.
//


class AccessLevel : PFObject,PFSubclassing{
    //these should probably be static
    let KEY_MEDICAL:String="medical";
    let KEY_LEGAL:String="legal";
    let KEY_FINANCIAL:String="financial";
    let KEY_PERSONAL:String="personal";
    let KEY_ADMIN:String="admin";

    static let KEY_ARRAY=["medical","legal","financial","personal"];
    
    var bFinancial:Bool = false;
    var bLegal:Bool = false;
    var bMedical:Bool = false;
    var bPersonal:Bool = false;
    var bAdmin:Bool = false;

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
    
    func setInitialValues(financial:Bool, legal:Bool, medical:Bool, personal:Bool, admin:Bool) {
        self.bFinancial=financial;
        self.bLegal=legal;
        self.bMedical=medical;
        self.bPersonal=personal;
        self.bAdmin=admin;
        //super.init();
    }
    
    func update() {
        self.setValue(self.bFinancial, forKey: KEY_FINANCIAL);
        self.setValue(self.bLegal, forKey: KEY_LEGAL);
        self.setValue(self.bMedical, forKey: KEY_MEDICAL);
        self.setValue(self.bPersonal, forKey: KEY_PERSONAL);
        self.setValue(self.bAdmin, forKey: KEY_ADMIN)
        self.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
    func setMedicalAccess(new:Bool) {
        self.bMedical=new;
    }
    func setFinancialAccess(new:Bool) {
        self.bFinancial=new;
    }
    func setLegalAccess(new:Bool) {
        self.bLegal=new;
    }
    func setPersonalAccess(new:Bool) {
        self.bPersonal=new;
    }
    
    func createCopy() -> AccessLevel{
        let copyAccessLevel = AccessLevel();
        copyAccessLevel.setInitialValues(self.bFinancial, legal: self.bLegal, medical: self.bMedical, personal: self.bPersonal, admin: self.bAdmin);
        copyAccessLevel.update();
        return copyAccessLevel;
    }
    
    // Retrieve from database
    func getMedicalAccess() ->Bool {
        if let val=valueForKey(KEY_MEDICAL) as! Bool? {
            return val;
        }
        return false;
    }
    func getFinancialAccess() ->Bool {
        if let val=valueForKey(KEY_FINANCIAL) as! Bool? {
            return val;
        }
        return false;
    }
    func getLegalAccess() -> Bool {
        if let val=valueForKey(KEY_LEGAL) as! Bool? {
            return val;
        }
        return false;
    }
    func getPersonalAccess() ->Bool {
        if let val=valueForKey(KEY_PERSONAL) as! Bool? {
            return val;
        }
        return false;
    }
    
    // Retrieve locally
    func getLocalMedicalAccess() ->Bool {return self.bMedical;}
    func getLocalFinancialAccess() ->Bool {return self.bFinancial;}
    func getLocalLegalAccess() -> Bool {return self.bLegal;}
    func getLocalPersonalAccess() ->Bool {return self.bPersonal;}
    
    func getAdminAccess() ->Bool {
        if let val=valueForKey(KEY_ADMIN) as! Bool? {
            return val;
        }
        return false;
    }
    static func parseClassName() -> String {
        return "AccessLevel";
    }
    
}