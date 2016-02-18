//
//  EssentialsViewController.swift
//  Caregiving
//
//  Created by Julia Bindler on 2/11/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit

class EssentialsViewController: PFQueryTableViewController {
    
    var popupController:CNPPopupController = CNPPopupController()
    var postAccessLevel = AccessLevel()
    var limit = 10;
    var entryFilterSet = false
    var updateAfterPosting = false
    var isFilteredView = false
    var filterAccessLevel = AccessLevel()
    
    @IBAction func addEntryTouch(sender: AnyObject) {
        self.showEntryPopupWithStyle(CNPPopupStyle.Centered)
        print("entry test")
    }
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.parseClassName = "Essentials"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery {
        var displayAccessLevel=AccessLevel()
        let query:PFQuery
        if let user=AppUser.currentUser() as AppUser? {
            
            // Why are these all false?
            let userLevel = user.getCaregiverAccessLevel()
            
            displayAccessLevel.setInitialValues(userLevel.getFinancialAccess(), legal: userLevel.getLegalAccess(),
                medical: userLevel.getMedicalAccess(),personal:userLevel.getPersonalAccess(), admin: userLevel.getAdminAccess())
            if (isFilteredView) {
                displayAccessLevel=self.filterAccessLevel
            }
             query = Essentials.getEssentialsFor(user, categories: displayAccessLevel)

        }
            
        else{
            let noUser=AppUser()
            displayAccessLevel.setInitialValues(false, legal: false, medical: false, personal: false, admin: true);
            query = Essentials.getEssentialsFor(noUser, categories: displayAccessLevel)

            
        }
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell:EssentialsTableViewCell? = tableView.dequeueReusableCellWithIdentifier("essentialsCell") as? EssentialsTableViewCell
        print(object!["MARKED"])
        
        let marked = object!["MARKED"] as! Bool
        let toggleCheck = cell!.toggleCheck
        toggleCheck.tag = indexPath.row
        
        toggleCheck.addTarget(self, action: "checkToggled:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        var image : UIImage = UIImage(named: "unchecked")!
        if marked == true {
            image = UIImage(named: "checked")!
        }
        cell!.checkbox.image = image
        cell!.cellText.text = object!["TEXT"] as? String
        
        return cell
    }
    
    func checkToggled(sender: UIButton) {
        print("button pressed")
        let object = objects![sender.tag] as? Essentials
        object?.text=object?.valueForKey("TEXT") as! String
        object?.name=object?.valueForKey("TEAMNAME") as! String
        if object!.marked == true {
            object!.marked = false
            //object!["MARKED"] = false
            
        }
        else {
            object!.marked = true
            //object!["MARKED"] = true
            
        }
        object!.update()
        self.loadObjects()
    }
    
    
    
    func showEntryPopupWithStyle(popupStyle: CNPPopupStyle) {
        print("eehh")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let title = NSAttributedString(string: "New Post", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(24), NSParagraphStyleAttributeName: paragraphStyle])
        let lineOne = NSAttributedString(string: "You can add text ", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18), NSParagraphStyleAttributeName: paragraphStyle])
        
        let postButton = CNPPopupButton.init(frame: CGRectMake(35, 0, 80, 80))
        postButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        postButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        postButton.setTitle("Post", forState: UIControlState.Normal)
        postButton.backgroundColor = UIColor( red: CGFloat(39/255.0), green: CGFloat(174/255.0), blue: CGFloat(96/255.0), alpha: CGFloat(1.0) )
        postButton.layer.cornerRadius = 5
        
        
        let doneButton = CNPPopupButton.init(frame: CGRectMake(135, 0, 80, 80))
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        doneButton.setTitle("Cancel", forState: UIControlState.Normal)
        doneButton.layer.cornerRadius = 5
        doneButton.backgroundColor = UIColor( red: CGFloat(231/255.0), green: CGFloat(76/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0) )
        
        
        let buttonView = UIView.init(frame: CGRectMake(0, 0, 250, 100))
        buttonView.backgroundColor = UIColor.whiteColor()
        buttonView.addSubview(postButton)
        buttonView.addSubview(doneButton)
        
        let filterView = UIView.init(frame: CGRectMake(0, 0, 250, 80))
        filterView.backgroundColor = UIColor.whiteColor()
        
        
        
        // ##POST BUTTON AREA //
        let medicalFilterButton = UIButton.init(frame: CGRectMake(0, 0, 60, 60))
        let medicalImage = UIImage(named: "Medical_Button_Icon.png") as UIImage?
        medicalFilterButton.setBackgroundImage(medicalImage, forState: UIControlState.Normal)
        medicalFilterButton.addTarget(self, action: "medicalButtonPostTouched:", forControlEvents: .TouchUpInside)
        
        let financialFilterButton = UIButton.init(frame: CGRectMake(70, 0, 60, 60))
        let financialImage = UIImage(named: "Financial_Button_Icon.png") as UIImage?
        financialFilterButton.setBackgroundImage(financialImage, forState: UIControlState.Normal)
        financialFilterButton.addTarget(self, action: "financialButtonPostTouched:", forControlEvents: .TouchUpInside)
        
        
        let legalFilterButton = UIButton.init(frame: CGRectMake(140, 0, 60, 60))
        let legalImage = UIImage(named: "Legal_Button_Icon.png") as UIImage?
        legalFilterButton.setBackgroundImage(legalImage, forState: UIControlState.Normal)
        legalFilterButton.addTarget(self, action: "legalButtonPostTouched:", forControlEvents: .TouchUpInside)
        
        
        let personalFilterButton = UIButton.init(frame: CGRectMake(210, 0, 60, 60))
        let personalImage = UIImage(named: "Personal_Button_Icon.png") as UIImage?
        personalFilterButton.setBackgroundImage(personalImage, forState: UIControlState.Normal)
        personalFilterButton.addTarget(self, action: "personalButtonPostTouched:", forControlEvents: .TouchUpInside)
        
        
        filterView.addSubview(medicalFilterButton)
        filterView.addSubview(financialFilterButton)
        filterView.addSubview(legalFilterButton)
        filterView.addSubview(personalFilterButton)
        
        let customView = UIView.init(frame: CGRectMake(0, 0, 250, 100))
        customView.backgroundColor = UIColor.whiteColor()
        let textView = UITextView.init(frame: CGRectMake(0, 0, 280, 100))
        textView.backgroundColor = UIColor.whiteColor()
        textView.layer.borderColor = UIColor.grayColor().CGColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5
        textView.clipsToBounds = true
        textView.font = UIFont(name: "Helvetica", size: 18)
        
        customView.addSubview(textView)
        
        
        
        doneButton.selectionHandler = { (CNPPopupButton button) -> Void in
            self.popupController.dismissPopupControllerAnimated(true)
            print("Block for button: \(button.titleLabel?.text)")
        }
        
        
        
        postButton.selectionHandler = { (CNPPopupButton button) -> Void in
            
            
            if textView.text.isEmpty == false{
                
                
                if let user=AppUser.currentUser() as AppUser? {
                    let object=Essentials()
                    
                    let newAccessLevel = AccessLevel()
                    newAccessLevel.setInitialValues(self.postAccessLevel.bFinancial, legal: self.postAccessLevel.bLegal, medical: self.postAccessLevel.bMedical, personal: self.postAccessLevel.bPersonal, admin: self.postAccessLevel.bAdmin)
                    
                    newAccessLevel.update()
                    
                    
                    //TEST CODE
                    let personalImage = UIImage(named: "Personal_Button_Icon.png") as UIImage?;
                    //let data:NSData?=UIImagePNGRepresentation(personalImage!)
                    //let testObject = NFObject();
                    //testObject.setInitialValues("TESTING", username: user.username!, teamName: user.getTeamName(), level: user.getCaregiverAccessLevel().createCopy(), imageData: data)
                    //testObject.update()
                    
                    
                    
                    //right now object inherits user access level, front end needs to add accesslevel configurations
                    object.setInitialValues(textView.text!, teamName: user.getTeamName(),level: newAccessLevel, Deletable: false)
                    object.update();
                }
                
                
                self.popupController.dismissPopupControllerAnimated(true)
                
                
                
                
            }
            
        }
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title
        
        let lineOneLabel = UILabel()
        lineOneLabel.numberOfLines = 0;
        lineOneLabel.attributedText = lineOne;
        
        let imageView = UIImageView.init(image: UIImage.init(named: "icon"))
        
        self.popupController = CNPPopupController(contents:[titleLabel, imageView, textView, filterView, buttonView])
        self.popupController.theme = CNPPopupTheme.defaultTheme()
        self.popupController.theme.popupStyle = popupStyle
        self.popupController.delegate = self
        self.popupController.presentPopupControllerAnimated(true)
    }
    
    @IBAction func onFiltertouch(sender: AnyObject) {
        //query=NFObject.getNewsfeedFor(user, category: "INSERT CATEGORY NAME HERE IN LOWERCASE");
        print("filter test")
        self.showFilterPopupWithStyle(CNPPopupStyle.ActionSheet)
    }
    
    func showFilterPopupWithStyle(popupStyle: CNPPopupStyle) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let title = NSAttributedString(string: "Filter Team Feed", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(24), NSParagraphStyleAttributeName: paragraphStyle])
        
        let doneButton = CNPPopupButton.init(frame: CGRectMake(0, 0, 100, 60))
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.layer.cornerRadius = 4;
        doneButton.backgroundColor = UIColor( red: CGFloat(231/255.0), green: CGFloat(76/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0) )
        
        
        
        let medicalFilterButton = HTPressableButton.init(frame: CGRectMake(20, 10, 80, 70), buttonStyle: HTPressableButtonStyle.Rounded)
        medicalFilterButton.setTitle("Medical", forState: UIControlState.Normal)
        
        if(filterAccessLevel.getLocalMedicalAccess() == false){
            medicalFilterButton.buttonColor = UIColor.ht_grapeFruitColor()
            medicalFilterButton.shadowColor = UIColor.ht_grapeFruitDarkColor()
        }
            
        else{
            medicalFilterButton.buttonColor  = UIColor.ht_pomegranateColor()
            medicalFilterButton.shadowColor = UIColor.ht_pomegranateColor()
        }
        
        medicalFilterButton.addTarget(self, action: "medicalButtonFilterTouched:", forControlEvents: .TouchUpInside)
        
        
        
        let financialFilterButton = HTPressableButton.init(frame: CGRectMake(110, 10, 80, 70), buttonStyle: HTPressableButtonStyle.Rounded)
        financialFilterButton.setTitle("Financial", forState: UIControlState.Normal)
        
        
        if(filterAccessLevel.getLocalFinancialAccess() == false){
            financialFilterButton.buttonColor = UIColor.ht_mintColor()
            financialFilterButton.shadowColor = UIColor.ht_mintDarkColor()
            
        }
            
        else{
            financialFilterButton.buttonColor = UIColor.ht_nephritisColor()
            financialFilterButton.shadowColor = UIColor.ht_nephritisColor()
        }
        
        financialFilterButton.addTarget(self, action: "financialButtonFilterTouched:", forControlEvents: .TouchUpInside)
        
        
        
        
        let legalFilterButton = HTPressableButton.init(frame: CGRectMake(200, 10, 80, 70), buttonStyle: HTPressableButtonStyle.Rounded)
        legalFilterButton.setTitle("Legal", forState: UIControlState.Normal)
        
        
        
        
        if(filterAccessLevel.getLocalLegalAccess() == false){
            legalFilterButton.buttonColor = UIColor.ht_aquaColor()
            legalFilterButton.shadowColor = UIColor.ht_aquaDarkColor()
        }
            
        else{
            legalFilterButton.buttonColor = UIColor.ht_belizeHoleColor()
            legalFilterButton.shadowColor = UIColor.ht_belizeHoleColor()
            
        }
        
        legalFilterButton.addTarget(self, action: "legalButtonFilterTouched:", forControlEvents: .TouchUpInside)
        
        
        
        let personalFilterButton = HTPressableButton.init(frame: CGRectMake(290, 10, 80, 70), buttonStyle: HTPressableButtonStyle.Rounded)
        personalFilterButton.setTitle("Personal", forState: UIControlState.Normal)
        
        
        
        if(filterAccessLevel.getLocalPersonalAccess() == false){
            personalFilterButton.buttonColor = UIColor.ht_lemonColor()
            personalFilterButton.shadowColor = UIColor.ht_lemonDarkColor()
        }
            
        else{
            personalFilterButton.buttonColor = UIColor.ht_citrusColor()
            personalFilterButton.shadowColor = UIColor.ht_citrusColor()
            
        }
        
        personalFilterButton.addTarget(self, action: "personalButtonFilterTouched:", forControlEvents: .TouchUpInside)
        
        
        let buttonView = UIView.init(frame: CGRectMake(0, 0, 365, 100))
        buttonView.backgroundColor = UIColor.whiteColor()
        
        
        let customView = UIView.init(frame: CGRectMake(0, 0, 250, 100))
        customView.backgroundColor = UIColor.whiteColor()
        
        
        if let user=AppUser.currentUser() as AppUser? {
            let level = user.getCaregiverAccessLevel()
            
            if (level.getMedicalAccess()){
                buttonView.addSubview(medicalFilterButton)
            }
            
            
            if level.getFinancialAccess() {
                buttonView.addSubview(financialFilterButton)
            }
            
            if level.getLegalAccess() {
                buttonView.addSubview(legalFilterButton)
            }
            
            if level.getPersonalAccess() {
                buttonView.addSubview(personalFilterButton)
            }
            
        }
        
        doneButton.selectionHandler = { (CNPPopupButton button) -> Void in
            self.popupController.dismissPopupControllerAnimated(true)
            
            
            self.loadObjects()
            
            
            print("Block for button: \(button.titleLabel?.text)")
            
            
        }
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title
        
        
        self.popupController = CNPPopupController(contents:[titleLabel, buttonView, doneButton])
        self.popupController.theme = CNPPopupTheme.defaultTheme()
        self.popupController.theme.popupStyle = popupStyle
        self.popupController.delegate = self
        self.popupController.presentPopupControllerAnimated(true)
    }
    
    
    func medicalButtonFilterTouched(sender: HTPressableButton!){
        isFilteredView=true
        
        // Turn on Medical Filter
        if(filterAccessLevel.getLocalMedicalAccess() == false){
            filterAccessLevel.setMedicalAccess(true)
            sender.buttonColor = UIColor.ht_pomegranateColor()
            sender.shadowColor = UIColor.ht_pomegranateColor()
            
            
        }
            
            // Turn off Medical Filter
        else{
            filterAccessLevel.setMedicalAccess(false)
            sender.buttonColor = UIColor.ht_grapeFruitColor()
            sender.shadowColor = UIColor.ht_grapeFruitDarkColor()
            
        }
        
    }
    
    func financialButtonFilterTouched(sender: HTPressableButton!){
        isFilteredView=true
        
        // Turn on Financial filter
        if(filterAccessLevel.bFinancial == false){
            filterAccessLevel.setFinancialAccess(true)
            sender.buttonColor = UIColor.ht_nephritisColor()
            sender.shadowColor = UIColor.ht_nephritisColor()
        }
            
            // Turn off financial filter
        else{
            filterAccessLevel.setFinancialAccess(false)
            sender.buttonColor = UIColor.ht_mintColor()
            sender.shadowColor = UIColor.ht_mintDarkColor()
        }
    }
    
    func legalButtonFilterTouched(sender: HTPressableButton!){
        isFilteredView=true
        
        // Turn on legal filter
        if(filterAccessLevel.bLegal == false){
            filterAccessLevel.setLegalAccess(true)
            sender.buttonColor = UIColor.ht_belizeHoleColor()
            sender.shadowColor = UIColor.ht_belizeHoleColor()
        }
            
            // turn off legal filter
        else{
            filterAccessLevel.setLegalAccess(false)
            sender.buttonColor = UIColor.ht_aquaColor()
            sender.shadowColor = UIColor.ht_aquaDarkColor()
        }
    }
    
    func personalButtonFilterTouched(sender: HTPressableButton!){
        isFilteredView=true
        
        // Turn on personal filter
        if(filterAccessLevel.bPersonal == false){
            filterAccessLevel.setPersonalAccess(true)
            sender.buttonColor = UIColor.ht_citrusColor()
            sender.shadowColor = UIColor.ht_citrusColor()
        }
            
            // turn off peronal filter
        else{
            filterAccessLevel.setPersonalAccess(false)
            sender.buttonColor = UIColor.ht_lemonColor()
            sender.shadowColor = UIColor.ht_lemonDarkColor()
        }
    }
    
    
    
    
    
}


extension EssentialsViewController : CNPPopupControllerDelegate {
    
    func popupController(controller: CNPPopupController, dismissWithButtonTitle title: NSString) {
        print("Dismissed with button title \(title)")
    }
    
    func popupControllerDidPresent(controller: CNPPopupController) {
        print("Popup controller presented")
    }
    
}



