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
        var query : PFQuery = PFQuery(className: self.parseClassName!)
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell:EssentialsTableViewCell? = tableView.dequeueReusableCellWithIdentifier("essentialsCell") as? EssentialsTableViewCell
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        var image : UIImage = UIImage(named: "blankbox")!
        cell!.checkbox.image = image
        cell!.cellText.text = object!["TEXT"] as? String
        
        return cell
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
                    object.setInitialValues(textView.text!, teamName: user.getTeamName(),level: newAccessLevel)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EssentialsViewController : CNPPopupControllerDelegate {
    
    func popupController(controller: CNPPopupController, dismissWithButtonTitle title: NSString) {
        print("Dismissed with button title \(title)")
    }
    
    func popupControllerDidPresent(controller: CNPPopupController) {
        print("Popup controller presented")
    }
    
}
