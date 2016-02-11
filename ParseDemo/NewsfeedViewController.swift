//
//  NewsFeedViewController.swift
//  Caregiving
//
//  Created by Stephen Grinich on 1/24/16.
//  Copyright © 2016 Caregivernet. All rights reserved.
//

import UIKit

class NewsFeedViewController: PFQueryTableViewController {
    
    var popupController:CNPPopupController = CNPPopupController()
    
    let cellIdentifier:String = "NewsCell"
    var limit = 10;
    var entryFilterSet = false
    var updateAfterPosting = false
    var isFilteredView = false
    var postAccessLevel = AccessLevel();
    var filterAccessLevel = AccessLevel();
    

    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.parseClassName = "NFObject"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // we use this to check for new posts posted by other people. this is so they can show up without needing to pull to refresh. so 
        // I suppose we don't need pulling to refresh
        // Fires every 5 seconds.
        var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "checkForUpdates", userInfo: nil, repeats: true)
        
        self.postAccessLevel.setInitialValues(false, legal: false, medical: false, personal: false, admin: false)
        
        
        if let user=AppUser.currentUser() as AppUser? {
            var userLevel = user.getCaregiverAccessLevel()
            filterAccessLevel = userLevel.createCopy()
        }
        
        
        tableView.separatorColor = UIColor.clearColor()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        
        
        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            self.limit += 10
            self.loadObjects()
            
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
    }
    
    func checkForUpdates() {
        
        
        
        if(updateAfterPosting == true){
            self.loadObjects()
            updateAfterPosting = false
            print("Updating for the post you just did")

        }
        
        else{
//            print("not checking because you didn't just post")
        }
    }
    
    override func queryForTable() -> PFQuery {
        var displayAccessLevel = AccessLevel();
        
        
            var query:PFQuery

        if (isFilteredView == false){
            
            print("isFilteredView is false")
            
            if let user=AppUser.currentUser() as AppUser? {
                
                // Why are these all false?
                var userLevel = user.getCaregiverAccessLevel()
               // print(userLevel.getMedicalAccess())
                //print(userLevel.getFinancialAccess())
                //print(userLevel.getLegalAccess())
                //print(userLevel.getPersonalAccess())


                displayAccessLevel.setInitialValues(userLevel.getFinancialAccess(), legal: userLevel.getLegalAccess(), medical: userLevel.getMedicalAccess(), personal: userLevel.getPersonalAccess(), admin: userLevel.getAdminAccess())
            }
            
            else{
                displayAccessLevel.setInitialValues(false, legal: false, medical: false, personal: false, admin: true);

            }
        }
        
        else{
            displayAccessLevel = self.filterAccessLevel
        }
        
        
        
        if let user=AppUser.currentUser() as AppUser? {
            if (isFilteredView) {
                query=NFObject.getNewsfeedFor(user, categories: displayAccessLevel);
//                isFilteredView = !isFilteredView
            }
            else {
                query=NFObject.getNewsfeedFor(user, categories: displayAccessLevel);
                
            }
        }
        else {
            let nouser=AppUser();
            let noaccess=AccessLevel();
            nouser.setInitialValues("", password: "", email: "", teamname: "", accessLevel: noaccess)
            query=NFObject.getNewsfeedFor(nouser, categories: displayAccessLevel)
        }
        query.limit = self.limit
        query.orderByDescending("createdAt")


        return query
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        
        let cell : NewsFeedTableViewCell?
        
        //        if let pfObject = object {
        
        //var image:NSData?=object!["IMAGE"] as? NSData;
        // there is an image
        //if let imgData=image as NSData?{
           // cell = tableView.dequeueReusableCellWithIdentifier("newsImageCell") as? NewsFeedTableViewImageCell
            
        //}
            
            // there is no image
        //else{
            
            cell = tableView.dequeueReusableCellWithIdentifier("newsCell") as? NewsFeedTableViewCell
            
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            
            //use the KEY_USERNAME field to access the username of the user
            
            
            cell?.cellText?.text = object!["TEXT"] as? String
            cell?.userName?.text = object!["USERNAME"] as? String
                
            var date = object?.createdAt
            //                var date = object!["createdAt"] as? NSDate
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM d 'at' h:mm a" // superset of OP's format
            let str = dateFormatter.stringFromDate(date!)
                            
            cell?.timeStamp?.text = str
            
            cell?.textLabel?.numberOfLines = 0
            return cell;

       // }
            return nil
        
        
        
        
        
        
        
        //             cell?.cardView.frame = CGRectMake(10, 5, 300, [((NSNumber*)[cardSizeArray objectAtIndex:indexPath.row])intValue]-10);
        //        }
        
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//       
//        let cell:NewsFeedTableViewCell? = tableView.dequeueReusableCellWithIdentifier("newsCell") as? NewsFeedTableViewCell
//        
//        
//        
////        if let pfObject = object {
////            
////            var numOfLines = cell?.textLabel?.numberOfLines
//////            var test = cell?.textLabel?.text
////            
////            
////            //             cell?.cardView.frame = CGRectMake(10, 5, 300, [((NSNumber*)[cardSizeArray objectAtIndex:indexPath.row])intValue]-10);
////        }
//        
//        //TODO: Make this depend on what's in the cell.
//        
//        return 250
//    }

//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
//    
//    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
//        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    @IBAction func onFiltertouch(sender: AnyObject) {
        //query=NFObject.getNewsfeedFor(user, category: "INSERT CATEGORY NAME HERE IN LOWERCASE");
        print("filter test")
        self.showFilterPopupWithStyle(CNPPopupStyle.ActionSheet)
    }

    @IBAction func addEntryTouch(sender: AnyObject) {
        print("entry test")
        self.showEntryPopupWithStyle(CNPPopupStyle.Centered)
        entryFilterSet = false
    }
    
    func showFilterPopupWithStyle(popupStyle: CNPPopupStyle) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let title = NSAttributedString(string: "Filter News Feed", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(24), NSParagraphStyleAttributeName: paragraphStyle])
        let lineOne = NSAttributedString(string: "Select a filter below", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18), NSParagraphStyleAttributeName: paragraphStyle])
        //        let lineTwo = NSAttributedString(string: "With style, using NSAttributedString", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 0.46, green: 0.8, blue: 1.0, alpha: 1.0), NSParagraphStyleAttributeName: paragraphStyle])
        //
        
        let doneButton = CNPPopupButton.init(frame: CGRectMake(0, 0, 100, 60))
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.layer.cornerRadius = 4;
        doneButton.backgroundColor = UIColor( red: CGFloat(231/255.0), green: CGFloat(76/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0) )
        
        let medicalFilterButton = UIButton.init(frame: CGRectMake(0, 0, 60, 60))
        
        if(filterAccessLevel.bMedical == false){
            let medicalImage = UIImage(named: "Medical_Button_Icon_Weak.png") as UIImage?
            medicalFilterButton.setBackgroundImage(medicalImage, forState: UIControlState.Normal)
        }
            
        else{
            let medicalImage = UIImage(named: "Medical_Button_Icon.png") as UIImage?
            medicalFilterButton.setBackgroundImage(medicalImage, forState: UIControlState.Normal)
        }
        
        medicalFilterButton.addTarget(self, action: "medicalButtonFilterTouched:", forControlEvents: .TouchUpInside)
        
        let financialFilterButton = UIButton.init(frame: CGRectMake(70, 0, 60, 60))
        
        if(filterAccessLevel.bFinancial == false){
            let financialImage = UIImage(named: "Financial_Button_Icon_Weak.png") as UIImage?
            financialFilterButton.setBackgroundImage(financialImage, forState: UIControlState.Normal)
        }
            
        else{
            let financialImage = UIImage(named: "Financial_Button_Icon.png") as UIImage?
            financialFilterButton.setBackgroundImage(financialImage, forState: UIControlState.Normal)
        }
        
        financialFilterButton.addTarget(self, action: "financialButtonFilterTouched:", forControlEvents: .TouchUpInside)
        
        
        let legalFilterButton = UIButton.init(frame: CGRectMake(140, 0, 60, 60))
        
        if(filterAccessLevel.bLegal == false){
            let legalImage = UIImage(named: "Legal_Button_Icon_Weak.png") as UIImage?
            legalFilterButton.setBackgroundImage(legalImage, forState: UIControlState.Normal)
        }
            
        else{
            let legalImage = UIImage(named: "Legal_Button_Icon.png") as UIImage?
            legalFilterButton.setBackgroundImage(legalImage, forState: UIControlState.Normal)
            
        }
        
        legalFilterButton.addTarget(self, action: "legalButtonFilterTouched:", forControlEvents: .TouchUpInside)
        
        
        let personalFilterButton = UIButton.init(frame: CGRectMake(210, 0, 60, 60))
        
        
        if(filterAccessLevel.bPersonal == false){
            let personalImage = UIImage(named: "Personal_Button_Icon_Weak.png") as UIImage?
            personalFilterButton.setBackgroundImage(personalImage, forState: UIControlState.Normal)
        }
            
        else{
            let personalImage = UIImage(named: "Personal_Button_Icon.png") as UIImage?
            personalFilterButton.setBackgroundImage(personalImage, forState: UIControlState.Normal)
            
        }
        
        personalFilterButton.addTarget(self, action: "personalButtonFilterTouched:", forControlEvents: .TouchUpInside)

        
        let buttonView = UIView.init(frame: CGRectMake(0, 0, 250, 100))
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
        
        let lineOneLabel = UILabel()
        lineOneLabel.numberOfLines = 0;
        lineOneLabel.attributedText = lineOne;
        
        
        self.popupController = CNPPopupController(contents:[titleLabel, lineOneLabel, buttonView, doneButton])
        self.popupController.theme = CNPPopupTheme.defaultTheme()
        self.popupController.theme.popupStyle = popupStyle
        self.popupController.delegate = self
        self.popupController.presentPopupControllerAnimated(true)
    }
 
    
    func showEntryPopupWithStyle(popupStyle: CNPPopupStyle) {
        
        
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
                    let object=NFObject();
                    
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
                    object.setInitialValues(textView.text!, username: user.username! , teamName: user.getTeamName(),level: newAccessLevel,imageData: nil)
                    object.update();
                }
                
                
                self.popupController.dismissPopupControllerAnimated(true)
                
                self.updateAfterPosting = true
                
                
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
    
    func medicalButtonPostTouched(sender: UIButton!){
        self.postAccessLevel.setMedicalAccess(true)
        self.postAccessLevel.setFinancialAccess(false)
        self.postAccessLevel.setLegalAccess(false)
        self.postAccessLevel.setPersonalAccess(false)
        
        entryFilterSet = true
    }
    
    func financialButtonPostTouched(sender: UIButton!){
        postAccessLevel.setMedicalAccess(false)
        postAccessLevel.setFinancialAccess(true)
        postAccessLevel.setLegalAccess(false)
        postAccessLevel.setPersonalAccess(false)
        
        entryFilterSet = true
    }
    
    func legalButtonPostTouched(sender: UIButton!){
        postAccessLevel.setMedicalAccess(false)
        postAccessLevel.setFinancialAccess(false)
        postAccessLevel.setLegalAccess(true)
        postAccessLevel.setPersonalAccess(false)
        
        entryFilterSet = true
    }
    
    func personalButtonPostTouched(sender: UIButton!){

        postAccessLevel.setMedicalAccess(false)
        postAccessLevel.setFinancialAccess(false)
        postAccessLevel.setLegalAccess(false)
        postAccessLevel.setPersonalAccess(true)
        
        entryFilterSet = true
    }

    
    func medicalButtonFilterTouched(sender: UIButton!){
        isFilteredView=true
        
        // Turn on Medical Filter
        if(filterAccessLevel.bMedical == false){
            
            filterAccessLevel.setMedicalAccess(true)
//            
            let personalImage = UIImage(named: "Medical_Button_Icon.png") as UIImage?
            sender.setBackgroundImage(personalImage, forState: UIControlState.Normal)
                }
        
        // Turn off Medical Filter
        else{
            filterAccessLevel.setMedicalAccess(false)
            
            let personalImage = UIImage(named: "Medical_Button_Icon_Weak.png") as UIImage?
            sender.setBackgroundImage(personalImage, forState: UIControlState.Normal)
        }
        
    }
    
    func financialButtonFilterTouched(sender: UIButton!){
        isFilteredView=true
        if(filterAccessLevel.bFinancial == false){
            
            filterAccessLevel.setFinancialAccess(true)
            
            let personalImage = UIImage(named: "Financial_Button_Icon.png") as UIImage?
            sender.setBackgroundImage(personalImage, forState: UIControlState.Normal)
        }
            
        else{
            filterAccessLevel.setFinancialAccess(false)
            
            let personalImage = UIImage(named: "Financial_Button_Icon_Weak.png") as UIImage?
            sender.setBackgroundImage(personalImage, forState: UIControlState.Normal)
        }
    }
    
    func legalButtonFilterTouched(sender: UIButton!){
                isFilteredView=true
        if(filterAccessLevel.bLegal == false){
            filterAccessLevel.setLegalAccess(true)
            
            let personalImage = UIImage(named: "Legal_Button_Icon.png") as UIImage?
            sender.setBackgroundImage(personalImage, forState: UIControlState.Normal)
        }
            
        else{
            filterAccessLevel.setLegalAccess(false)
            
            let personalImage = UIImage(named: "Legal_Button_Icon_Weak.png") as UIImage?
            sender.setBackgroundImage(personalImage, forState: UIControlState.Normal)
        }
    }
    
    func personalButtonFilterTouched(sender: UIButton!){
                isFilteredView=true
        
        if(filterAccessLevel.bPersonal == false){
            filterAccessLevel.setPersonalAccess(true)
            
            let personalImage = UIImage(named: "Personal_Button_Icon.png") as UIImage?
            sender.setBackgroundImage(personalImage, forState: UIControlState.Normal)
        }
            
        else{
            filterAccessLevel.setPersonalAccess(false)
            
            let personalImage = UIImage(named: "Personal_Button_Icon_Weak.png") as UIImage?
            sender.setBackgroundImage(personalImage, forState: UIControlState.Normal)
        }
    }
    
    


}


extension NewsFeedViewController : CNPPopupControllerDelegate {
    
    func popupController(controller: CNPPopupController, dismissWithButtonTitle title: NSString) {
        print("Dismissed with button title \(title)")
    }
    
    func popupControllerDidPresent(controller: CNPPopupController) {
        print("Popup controller presented")
    }
    
}
