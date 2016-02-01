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
    func getAllowedAccess() -> [String]{
        var array:[String]=[];
        if (self.getMedicalAccess()) {
            array.append(KEY_MEDICAL);
        }
        if (self.getLegalAccess()) {
            array.append(KEY_LEGAL);
        }
        if (self.getFinancialAccess()) {
            array.append(KEY_FINANCIAL);
        }
        if (self.getPersonalAccess()) {
            array.append(KEY_PERSONAL);
        }
        if (self.getAdminAccess()) {
            array.append(KEY_ADMIN);
        }
        return array;
    }
    func getMedicalAccess() ->Bool {return self.bMedical;}
    func getFinancialAccess() ->Bool {return self.bFinancial;}
    func getLegalAccess() -> Bool {return self.bLegal;}
    func getPersonalAccess() ->Bool {
        return self.bPersonal;
    }
    func getAdminAccess() ->Bool {
        return self.bAdmin;
    }
    static func parseClassName() -> String {
        return "AccessLevel";
    }
    
    /*func hasAccessTo(other: AccessLevel) -> Bool {
        let financial:Bool = ((self.bFinancial == other.bFinancial) || (self.bFinancial == true));
        let legal:Bool = ((self.bLegal == other.bLegal) || (self.bLegal == true));
        let medical:Bool = ((self.bMedical == other.bMedical) || (self.bMedical == true));
        let personal:Bool = ((self.bPersonal == other.bPersonal) || (self.bPersonal == true));
        return (financial && legal && medical && personal);
    }*/
}