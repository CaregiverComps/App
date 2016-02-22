//
//  TextEntryViewController.swift
//  Caregiving
//
//  Created by Stephen Grinich on 2/12/16.
//  Copyright © 2016 CaregiverNet. All rights reserved.
//

import UIKit

class TextEntryViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var butttonView: UIView!
    
    var postAccessLevel = AccessLevel();
    var postFilterSet = false
    
    let medicalButton = HTPressableButton.init(frame: CGRectMake(20, 10, 80, 70), buttonStyle: HTPressableButtonStyle.Rounded)
    
    let financialButton = HTPressableButton.init(frame: CGRectMake(110, 10, 80, 70), buttonStyle: HTPressableButtonStyle.Rounded)
    let legalButton = HTPressableButton.init(frame: CGRectMake(200, 10, 80, 70), buttonStyle: HTPressableButtonStyle.Rounded)

    let personalButton = HTPressableButton.init(frame: CGRectMake(290, 10, 80, 70), buttonStyle: HTPressableButtonStyle.Rounded)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.becomeFirstResponder()
        
        self.postAccessLevel.setInitialValues(false, legal: false, medical: false, personal: false, admin: false)

        
        
        if let user=AppUser.currentUser() as AppUser? {
            self.textView.placeholder = "Any updates for team " + user.teamName + "?"
        }
        else{
            self.textView.placeholder = "Any updates?"
        }
        
        if let user=AppUser.currentUser() {
            if (user.getCaregiverAccessLevel().getFinancialAccess()) {
                financialButton.buttonColor  = UIColor.ht_mintColor()
                financialButton.shadowColor = UIColor.ht_mintDarkColor()
                financialButton.setTitle("Financial", forState: UIControlState.Normal)
                financialButton.addTarget(self, action: "financialButtonPostTouched:", forControlEvents: .TouchUpInside)
                
                self.butttonView.addSubview(financialButton)
            }
            if (user.getCaregiverAccessLevel().getMedicalAccess()) {
                medicalButton.buttonColor  = UIColor.ht_grapeFruitColor()
                medicalButton.shadowColor = UIColor.ht_grapeFruitDarkColor()
                medicalButton.setTitle("Medical", forState: UIControlState.Normal)
                medicalButton.addTarget(self, action: "medicalButtonPostTouched:", forControlEvents: .TouchUpInside)
                
                
                self.butttonView.addSubview(medicalButton)
            }
            if (user.getCaregiverAccessLevel().getLegalAccess()) {
                legalButton.buttonColor  = UIColor.ht_aquaColor()
                legalButton.shadowColor = UIColor.ht_aquaDarkColor()
                legalButton.setTitle("Legal", forState: UIControlState.Normal)
                legalButton.addTarget(self, action: "legalButtonPostTouched:", forControlEvents: .TouchUpInside)
                
                self.butttonView.addSubview(legalButton)
            }
            if (user.getCaregiverAccessLevel().getPersonalAccess()) {
                personalButton.buttonColor  = UIColor.ht_lemonColor()
                personalButton.shadowColor = UIColor.ht_lemonDarkColor()
                personalButton.setTitle("Personal", forState: UIControlState.Normal)
                personalButton.addTarget(self, action: "personalButtonPostTouched:", forControlEvents: .TouchUpInside)
                
                self.butttonView.addSubview(personalButton)
            }
        }

        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func medicalButtonPostTouched(sender: HTPressableButton!){
        
        if(self.postAccessLevel.getLocalMedicalAccess() == false){
            self.postAccessLevel.setMedicalAccess(true)
            self.postAccessLevel.setFinancialAccess(false)
            self.postAccessLevel.setLegalAccess(false)
            self.postAccessLevel.setPersonalAccess(false)
            sender.buttonColor  = UIColor.ht_pomegranateColor()
            sender.shadowColor = UIColor.ht_pomegranateColor()
            financialButton.buttonColor = UIColor.ht_mintColor()
            financialButton.shadowColor = UIColor.ht_mintDarkColor()
            legalButton.buttonColor = UIColor.ht_aquaColor()
            legalButton.shadowColor = UIColor.ht_aquaDarkColor()
            personalButton.buttonColor = UIColor.ht_lemonColor()
            personalButton.shadowColor = UIColor.ht_lemonDarkColor()
            
            
        }
        
        else{
            self.postAccessLevel.setMedicalAccess(false)
            sender.buttonColor  = UIColor.ht_grapeFruitColor()
            sender.shadowColor = UIColor.ht_grapeFruitDarkColor()
        }
        
        postFilterSet = true
    }
    
    func financialButtonPostTouched(sender: HTPressableButton!){
        if(self.postAccessLevel.getLocalFinancialAccess() == false){
            postAccessLevel.setMedicalAccess(false)
            postAccessLevel.setFinancialAccess(true)
            postAccessLevel.setLegalAccess(false)
            postAccessLevel.setPersonalAccess(false)
            
            sender.buttonColor = UIColor.ht_nephritisColor()
            sender.shadowColor = UIColor.ht_nephritisColor()
            medicalButton.buttonColor = UIColor.ht_grapeFruitColor()
            medicalButton.shadowColor = UIColor.ht_grapeFruitDarkColor()
            legalButton.buttonColor = UIColor.ht_aquaColor()
            legalButton.shadowColor = UIColor.ht_aquaDarkColor()
            personalButton.buttonColor = UIColor.ht_lemonColor()
            personalButton.shadowColor = UIColor.ht_lemonDarkColor()
        }
        
        else{
            self.postAccessLevel.setFinancialAccess(false)
            sender.buttonColor = UIColor.ht_mintColor()
            sender.shadowColor = UIColor.ht_mintDarkColor()
        }
        
        
        postFilterSet = true
    }
    
    func legalButtonPostTouched(sender: HTPressableButton!){
        
        if(self.postAccessLevel.getLocalLegalAccess() == false){
            postAccessLevel.setMedicalAccess(false)
            postAccessLevel.setFinancialAccess(false)
            postAccessLevel.setLegalAccess(true)
            postAccessLevel.setPersonalAccess(false)
            
            sender.buttonColor = UIColor.ht_belizeHoleColor()
            sender.shadowColor = UIColor.ht_belizeHoleColor()
            medicalButton.buttonColor = UIColor.ht_grapeFruitColor()
            medicalButton.shadowColor = UIColor.ht_grapeFruitDarkColor()
            financialButton.buttonColor = UIColor.ht_mintColor()
            financialButton.shadowColor = UIColor.ht_mintDarkColor()
            personalButton.buttonColor = UIColor.ht_lemonColor()
            personalButton.shadowColor = UIColor.ht_lemonDarkColor()
            
            
        }
        
        else{
            self.postAccessLevel.setLegalAccess(false)
            sender.buttonColor = UIColor.ht_aquaColor()
            sender.shadowColor = UIColor.ht_aquaDarkColor()
        }
        
        
        postFilterSet = true
    }
    
    func personalButtonPostTouched(sender: HTPressableButton!){
        
        if(self.postAccessLevel.getLocalPersonalAccess() == false){
            postAccessLevel.setMedicalAccess(false)
            postAccessLevel.setFinancialAccess(false)
            postAccessLevel.setLegalAccess(false)
            postAccessLevel.setPersonalAccess(true)
            
            sender.buttonColor = UIColor.ht_citrusColor()
            sender.shadowColor = UIColor.ht_citrusColor()
            medicalButton.buttonColor = UIColor.ht_grapeFruitColor()
            medicalButton.shadowColor = UIColor.ht_grapeFruitDarkColor()
            financialButton.buttonColor = UIColor.ht_mintColor()
            financialButton.shadowColor = UIColor.ht_mintDarkColor()
            legalButton.buttonColor = UIColor.ht_aquaColor()
            legalButton.shadowColor = UIColor.ht_aquaDarkColor()
            
        }
        
        else{
            self.postAccessLevel.setPersonalAccess(false)
            sender.buttonColor = UIColor.ht_lemonColor()
            sender.shadowColor = UIColor.ht_lemonDarkColor()
        }
        
        
        
        postFilterSet = true
    }
    
    
    
    @IBAction func postButton(sender: AnyObject) {
        
        let filterSet = self.postAccessLevel.getLocalMedicalAccess() || self.postAccessLevel.getLocalLegalAccess() || self.postAccessLevel.getLocalFinancialAccess() || self.postAccessLevel.getLocalPersonalAccess()
        
        if postFilterSet == true && filterSet == true{
            
            if textView.text.isEmpty{
                let alert = UIAlertController(title: "Wait", message: "Be sure to add text before posting", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
        
        
            else{
                
            if let user=AppUser.currentUser() as AppUser? {
            let object=NFObject();
            
            let newAccessLevel = AccessLevel()
            newAccessLevel.setInitialValues(self.postAccessLevel.bFinancial, legal: self.postAccessLevel.bLegal, medical: self.postAccessLevel.bMedical, personal: self.postAccessLevel.bPersonal, admin: self.postAccessLevel.bAdmin)
            
            newAccessLevel.update()
            
            
            object.setInitialValues(textView.text!, username: user.username! , teamName: user.getTeamName(),level: newAccessLevel,imageData: nil)
            object.update();
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
                }
            
        }
            
        }
        
            
        else{
            
            let alert = UIAlertController(title: "Wait", message: "Be sure to add a category before posting", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITextView {
    
    // Placeholder text
    var placeholder: String? {
        
        get {
            // Get the placeholder text from the label
            var placeholderText: String?
            
            if let placeHolderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeHolderLabel.text
            }
            return placeholderText
        }
        
        set {
            // Store the placeholder text in the label
            let placeHolderLabel = self.viewWithTag(100) as! UILabel?
            if placeHolderLabel == nil {
                // Add placeholder label to text view
                self.addPlaceholderLabel(newValue!)
            }
            else {
                placeHolderLabel?.text = newValue
                placeHolderLabel?.sizeToFit()
            }
        }
    }
    
}
