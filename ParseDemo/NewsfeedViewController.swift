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
            print("Querying2... "+user.getTeamName());
            query=NFObject.getNewsfeedFor(user);

            }
        else {
            print("App User was nil?")
            let nouser=AppUser();
            let noaccess=AccessLevel();
            nouser.setInitialValues("", password: "", email: "", teamname: "", accessLevel: noaccess)
            query=NFObject.getNewsfeedFor(nouser)
        }
        query.limit = self.limit
        query.orderByDescending("createdAt")
        print("Querying...");
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell:NewsFeedTableViewCell? = tableView.dequeueReusableCellWithIdentifier("newsCell") as? NewsFeedTableViewCell
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        if let pfObject = object {
            
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
        print("filter test")
        self.showFilterPopupWithStyle(CNPPopupStyle.ActionSheet)
    }

    @IBAction func addEntryTouch(sender: AnyObject) {
        print("entry test")
        self.showEntryPopupWithStyle(CNPPopupStyle.Centered)
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
        
        
        
        let medicalFilterButton = CNPPopupButton.init(frame: CGRectMake(0, 0, 100, 60))
        medicalFilterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        medicalFilterButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        medicalFilterButton.setTitle("Medical", forState: UIControlState.Normal)
        medicalFilterButton.backgroundColor = UIColor( red: CGFloat(39/255.0), green: CGFloat(174/255.0), blue: CGFloat(96/255.0), alpha: CGFloat(1.0) )
        medicalFilterButton.layer.cornerRadius = 4;
        
        let financialFilterButton = CNPPopupButton.init(frame: CGRectMake(150, 0, 100, 60))
        financialFilterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        financialFilterButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        financialFilterButton.setTitle("Financial", forState: UIControlState.Normal)
        financialFilterButton.layer.cornerRadius = 4;
        financialFilterButton.backgroundColor = UIColor( red: CGFloat(231/255.0), green: CGFloat(76/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0) )
        
        let legalFilterButton = CNPPopupButton.init(frame: CGRectMake(150, 0, 100, 60))
        legalFilterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        legalFilterButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        legalFilterButton.setTitle("Legal", forState: UIControlState.Normal)
        legalFilterButton.layer.cornerRadius = 4;
        legalFilterButton.backgroundColor = UIColor( red: CGFloat(231/255.0), green: CGFloat(76/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0) )
        
        let personalFilterButton = CNPPopupButton.init(frame: CGRectMake(150, 0, 100, 60))
        personalFilterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        personalFilterButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        personalFilterButton.setTitle("Personal", forState: UIControlState.Normal)
        personalFilterButton.layer.cornerRadius = 4;
        personalFilterButton.backgroundColor = UIColor( red: CGFloat(231/255.0), green: CGFloat(76/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0) )
        
        
        let buttonView = UIView.init(frame: CGRectMake(0, 0, 250, 100))
        buttonView.backgroundColor = UIColor.whiteColor()
        
        
        let customView = UIView.init(frame: CGRectMake(0, 0, 250, 100))
        customView.backgroundColor = UIColor.whiteColor()
        
        
        doneButton.selectionHandler = { (CNPPopupButton button) -> Void in
            self.popupController.dismissPopupControllerAnimated(true)
            print("Block for button: \(button.titleLabel?.text)")
            
            
            if let user=AppUser.currentUser() as AppUser? {
                let level = user.getCaregiverAccessLevel()
                print("medical level: ")
                print(level.getMedicalAccess())
                
                
                
                if (level.getMedicalAccess()){
                    buttonView.addSubview(medicalFilterButton)
                    print("medical test")
                }
                
                else{
                    print("its false")
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
//        let lineTwo = NSAttributedString(string: "With style, using NSAttributedString", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 0.46, green: 0.8, blue: 1.0, alpha: 1.0), NSParagraphStyleAttributeName: paragraphStyle])
//        
        let postButton = CNPPopupButton.init(frame: CGRectMake(0, 0, 100, 60))
        postButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        postButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        postButton.setTitle("Post Entry", forState: UIControlState.Normal)
        postButton.backgroundColor = UIColor( red: CGFloat(39/255.0), green: CGFloat(174/255.0), blue: CGFloat(96/255.0), alpha: CGFloat(1.0) )
        postButton.layer.cornerRadius = 4;
        
        let doneButton = CNPPopupButton.init(frame: CGRectMake(150, 0, 100, 60))
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        doneButton.setTitle("Cancel", forState: UIControlState.Normal)
        doneButton.layer.cornerRadius = 4;
        doneButton.backgroundColor = UIColor( red: CGFloat(231/255.0), green: CGFloat(76/255.0), blue: CGFloat(60/255.0), alpha: CGFloat(1.0) )

        
        let buttonView = UIView.init(frame: CGRectMake(0, 0, 250, 100))
        buttonView.backgroundColor = UIColor.whiteColor()
        buttonView.addSubview(postButton)
        buttonView.addSubview(doneButton)
    
        
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
            
            // YO BACKEND: TEXT TO POST IS IN HERE. YOU GET IT FROM textField.text
            // HANDLE GETTING THAT STRING FROM HERE. ONCE THIS BUTTON IS CLICKED THE VIEW WILL CLOSE
            
            if let user=AppUser.currentUser() as AppUser? {
                let object=NFObject();
                //right now object inherits user access level, front end needs to add accesslevel configurations
                object.setInitialValues(textView.text!, teamName: user.getTeamName(),level:user.getCaregiverAccessLevel(),imageData: nil)
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
       
        self.popupController = CNPPopupController(contents:[titleLabel, lineOneLabel, imageView, textView, buttonView])
        self.popupController.theme = CNPPopupTheme.defaultTheme()
        self.popupController.theme.popupStyle = popupStyle
        self.popupController.delegate = self
        self.popupController.presentPopupControllerAnimated(true)
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
