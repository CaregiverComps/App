//
//  AccessLevel.swift
//  ParseDemo
//
//  Created by Jonathan Brodie on 1/14/16.
//  Copyright (c) 2016 abearablecode. All rights reserved.
//

import Foundation
import Parse
class AccessLevel : PFObject {
    //these should probably be static
     let KEY_MEDICAL:String="medical";
     let KEY_LEGAL:String="legal";
    let KEY_FINANCIAL:String="financial";
     let KEY_PERSONAL:String="personal";
    
    var bFinancial:Bool;
    var bLegal:Bool;
    var bMedical:Bool;
    var bPersonal:Bool;

    init(financial:Bool, legal:Bool, medical:Bool, personal:Bool) {
        self.bFinancial=financial;
        self.bLegal=legal;
        self.bMedical=medical;
        self.bPersonal=personal;
        super.init();

    }
    func update() {
        self.setValue(self.bFinancial, forKey: KEY_FINANCIAL);
        self.setValue(self.bLegal, forKey: KEY_LEGAL);
        self.setValue(self.bMedical, forKey: KEY_MEDICAL);
        self.setValue(self.bPersonal, forKey: KEY_PERSONAL);
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
    func getMedicalAccess() ->Bool {return self.bMedical;}
    func getFinancialAccess() ->Bool {return self.bFinancial;}
    func getLegalAccess() -> Bool {return self.bLegal;}
    func getPersonalAccess() ->Bool {
        return self.bPersonal;
    }
    
}