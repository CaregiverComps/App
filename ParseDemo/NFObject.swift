//
//  NFObject.swift
//  ParseDemo
//
//  Created by Jonathan Brodie on 1/15/16.
//  Copyright (c) 2016 abearablecode. All rights reserved.
//

import Foundation
import Parse
class NFObject : PFObject {
    
    var text:String;
    
    init(starterText:String) {
        self.text=starterText;
        super.init();
    }
    
    func setText(newText:String) {
        self.text=newText;
    }
}