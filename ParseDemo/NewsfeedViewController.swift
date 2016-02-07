//
//  NewsFeedViewController.swift
//  Caregiving
//
//  Created by Stephen Grinich on 1/24/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit

class NewsFeedViewController: PFQueryTableViewController {
    
    var popupController:CNPPopupController = CNPPopupController()
    
    let cellIdentifier:String = "NewsCell"
    var limit = 10;
    var entryFilterSet = false

    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.parseClassName = "NFObject"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        let query:PFQuery
        if let user=AppUser.currentUser() as AppUser? {
            query=NFObject.getNewsfeedFor(user, category: "all");
        }
        else {
            let nouser=AppUser();
            let noaccess=AccessLevel();
            nouser.setInitialValues("", password: "", email: "", teamname: "", accessLevel: noaccess)
            query=NFObject.getNewsfeedFor(nouser, category: "all")
        }
        query.limit = self.limit
        query.orderByDescending("createdAt")


        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell:NewsFeedTableViewCell? = tableView.dequeueReusableCellWithIdentifier("newsCell") as? NewsFeedTableViewCell

        
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        if let pfObject = object {
            //use the KEY_USERNAME field to access the username of the user
            cell?.cellText?.text = pfObject["TEXT"] as? String
            cell?.textLabel?.numberOfLines = 0
            
            
//             cell?.cardView.frame = CGRectMake(10, 5, 300, [((NSNumber*)[cardSizeArray objectAtIndex:indexPath.row])intValue]-10);
        }
        
        return cell;
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
        
        
        
//        let medicalFilterButton = CNPPopupButton.init(frame: CGRectMake(0, 0, 100, 60))
//        medicalFilterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        medicalFilterButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
//        medicalFilterButton.setTitle("Medical", forState: UIControlState.Normal)
//        medicalFilterButton.backgroundColor = UIColor( red: CGFloat(39/255.0), green: CGFloat(174/255.0), blue: CGFloat(96/255.0), alpha: CGFloat(1.0) )
//        medicalFilterButton.layer.cornerRadius = 4;
//        
//        let financialFilterButton = CNPPopupButton.init(frame: CGRectMake(150, 0, 100, 60))
//        financialFilterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        financialFilterButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
//        financialFilterButton.setTitle("Financial", forState: UIControlState.Normal)
//        financialFilterButton.layer.cornerRadius = 4;
//        financialFilterButton.backgroundColor = UIColor( red: CGFloat(231/255.0), green: CGFloat(76/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0) )
//        
//        let legalFilterButton = CNPPopupButton.init(frame: CGRectMake(150, 0, 100, 60))
//        legalFilterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        legalFilterButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
//        legalFilterButton.setTitle("Legal", forState: UIControlState.Normal)
//        legalFilterButton.layer.cornerRadius = 4;
//        legalFilterButton.backgroundColor = UIColor( red: CGFloat(231/255.0), green: CGFloat(76/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0) )
//        
//        let personalFilterButton = CNPPopupButton.init(frame: CGRectMake(150, 0, 100, 60))
//        personalFilterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        personalFilterButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
//        personalFilterButton.setTitle("Personal", forState: UIControlState.Normal)
//        personalFilterButton.layer.cornerRadius = 4;
//        personalFilterButton.backgroundColor = UIColor( red: CGFloat(231/255.0), green: CGFloat(76/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0) )

        
        let medicalFilterButton = UIButton.init(frame: CGRectMake(0, 0, 60, 60))
        let medicalImage = UIImage(named: "Medical_Button_Icon.png") as UIImage?
        medicalFilterButton.setBackgroundImage(medicalImage, forState: UIControlState.Normal)
        
        let financialFilterButton = UIButton.init(frame: CGRectMake(70, 0, 60, 60))
        let financialImage = UIImage(named: "Financial_Button_Icon.png") as UIImage?
        financialFilterButton.setBackgroundImage(financialImage, forState: UIControlState.Normal)
        
        let legalFilterButton = UIButton.init(frame: CGRectMake(140, 0, 60, 60))
        let legalImage = UIImage(named: "Legal_Button_Icon.png") as UIImage?
        legalFilterButton.setBackgroundImage(legalImage, forState: UIControlState.Normal)
        
        let personalFilterButton = UIButton.init(frame: CGRectMake(210, 0, 60, 60))
        let personalImage = UIImage(named: "Personal_Button_Icon.png") as UIImage?
        personalFilterButton.setBackgroundImage(personalImage, forState: UIControlState.Normal)
        
        
        
        let buttonView = UIView.init(frame: CGRectMake(0, 0, 250, 100))
        buttonView.backgroundColor = UIColor.whiteColor()
        
        
        let customView = UIView.init(frame: CGRectMake(0, 0, 250, 100))
        customView.backgroundColor = UIColor.whiteColor()
        
        
        if let user=AppUser.currentUser() as AppUser? {
            let level = user.getCaregiverAccessLevel()
            print(level.getMedicalAccess())
            
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
        
        let title = NSAttributedString(string: "New Entry", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(24), NSParagraphStyleAttributeName: paragraphStyle])
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
            
            
            if let user=AppUser.currentUser() as AppUser? {
                let object=NFObject();
                //right now object inherits user access level, front end needs to add accesslevel configurations
                object.setInitialValues(textView.text!, username: user.username! , teamName: user.getTeamName(),level:user.getCaregiverAccessLevel(),imageData: nil)
                object.update();
            }
            
            
            self.popupController.dismissPopupControllerAnimated(true)
        }
        
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title
        
        let lineOneLabel = UILabel()
        lineOneLabel.numberOfLines = 0;
        lineOneLabel.attributedText = lineOne;
        
        let imageView = UIImageView.init(image: UIImage.init(named: "icon"))
       
        self.popupController = CNPPopupController(contents:[titleLabel, lineOneLabel, imageView, textView, filterView, buttonView])
        self.popupController.theme = CNPPopupTheme.defaultTheme()
        self.popupController.theme.popupStyle = popupStyle
        self.popupController.delegate = self
        self.popupController.presentPopupControllerAnimated(true)
    }
    
    
    
    func medicalButtonPostTouched(sender: UIButton!){
        
        entryFilterSet = true
    }
    
    func financialButtonPostTouched(sender: UIButton!){
        entryFilterSet = true
    }
    
    func legalButtonPostTouched(sender: UIButton!){
        entryFilterSet = true
    }
    
    func personalButtonPostTouched(sender: UIButton!){
        entryFilterSet = true
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
