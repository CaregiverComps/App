//
//  NewsFeedViewController.swift
//  Caregiving
//
//  Created by Stephen Grinich on 1/24/16.
//  Copyright © 2016 CaregiverNet. All rights reserved.
//

import UIKit

class NewsFeedViewController: PFQueryTableViewController {
    
    var popupController:CNPPopupController = CNPPopupController()
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    let cellIdentifier:String = "NewsCell"
    var limit = 10;
    var entryFilterSet = false
    var updateAfterPosting = false
    var isFilteredView = false
    var filterAccessLevel = AccessLevel();
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.parseClassName = "NFObject"
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadObjects()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user=AppUser.currentUser() as AppUser? {
            let userLevel = user.getCaregiverAccessLevel()
            self.filterAccessLevel = userLevel.createCopy()
            navigationBar.title = user.getTeamName() + " Feed";
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

    
    override func queryForTable() -> PFQuery {
        if AppUser.currentUser() == nil {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        }
        var displayAccessLevel = AccessLevel();
        var query:PFQuery
        if (isFilteredView == false){
            if let user=AppUser.currentUser() as AppUser? {
                // Why are these all false?
                let userLevel = user.getCaregiverAccessLevel()
                displayAccessLevel.setInitialValues(userLevel.getFinancialAccess(), legal: userLevel.getLegalAccess(), medical: userLevel.getMedicalAccess(), personal: userLevel.getPersonalAccess(), admin: userLevel.getAdminAccess())
            }
            
            else{
                displayAccessLevel.setInitialValues(false, legal: false, medical: false, personal: false, admin: false);

            }
        }
        else{
            displayAccessLevel = self.filterAccessLevel
        }
        
        
        
        if let user=AppUser.currentUser() as AppUser? {
            if (isFilteredView) {
                query=NFObject.getNewsfeedFor(user, categories: displayAccessLevel);
                // Do we want filter view to reset every time user goes to another page?
                //isFilteredView = !isFilteredView
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
        
            cell?.cellText?.text = object!["TEXT"] as? String
            cell?.userName?.text = object!["USERNAME"] as? String
        
        let feedType = object!["ACCESSLEVEL"] as! PFObject;
        let id=feedType.objectId;
        let query=PFQuery(className: "AccessLevel");
        
        query.getObjectInBackgroundWithId(id!, block: {
            (result, error) -> Void in
            if (error == nil) {
                if let level=result as? AccessLevel {
                if level.getMedicalAccess() == true{
                    cell?.sideColorView.backgroundColor = UIColor.ht_grapeFruitColor()
                }
                
                if level.getFinancialAccess() == true{
                    cell?.sideColorView.backgroundColor = UIColor.ht_mintColor()
                }
                
                if level.getLegalAccess() == true{
                    cell?.sideColorView.backgroundColor = UIColor.ht_aquaColor()
                }
                
                if level.getPersonalAccess() == true{
                    cell?.sideColorView.backgroundColor = UIColor.ht_lemonColor()
                }
                }
            }
        
        })

        let date = object?.createdAt
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d 'at' h:mm a" // superset of OP's format
        let str = dateFormatter.stringFromDate(date!)
                            
        cell?.timeStamp?.text = str
            
        cell?.textLabel?.numberOfLines = 0
        return cell;
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    @IBAction func onFiltertouch(sender: AnyObject) {
        filterAccessLevel.setFinancialAccess(false);
        filterAccessLevel.setLegalAccess(false);
        filterAccessLevel.setMedicalAccess(false);
        filterAccessLevel.setPersonalAccess(false);
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
            self.isFilteredView=true
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


extension NewsFeedViewController : CNPPopupControllerDelegate {
    
    func popupController(controller: CNPPopupController, dismissWithButtonTitle title: NSString) {
        print("Dismissed with button title \(title)")
    }
    
    func popupControllerDidPresent(controller: CNPPopupController) {
        print("Popup controller presented")
    }
    
}
