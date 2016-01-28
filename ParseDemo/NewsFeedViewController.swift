//
//  NewsFeedViewController.swift
//  Caregiving
//
//  Created by Stephen Grinich on 1/24/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit
import Parse
class NewsFeedViewController: UIViewController {
    
    var popupController:CNPPopupController = CNPPopupController()
    


    override func viewDidLoad() {
        let query=PFQuery(className: "NFObject");
        let curuser=AppUser.currentUser()
        query.whereKey("TEAMNAME", matchesRegex: curuser.getTeamName());
        //obtain the access level of each NFObject as well, need to uncomment
        query.includeKey("ACCESSLEVEL");
        //following lines won't work if current user's access level has changed
        var newsfeed:[NFObject]=[];
        query.findObjectsInBackgroundWithBlock {
            (results,error) -> Void in
            if (error == nil) {
                for result in results! {
                    let nfobj:NFObject = result as! NFObject;
                    let level=nfobj.objectForKey("ACCESSLEVEL") as! AccessLevel;
                    if (curuser.getCaregiverAccessLevel().hasAccessTo(level)) {
                        newsfeed+=[nfobj];
                    }
                }
            }
        }
       

        super.viewDidLoad()
        while (true) {
            print(newsfeed);
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFiltertouch(sender: AnyObject) {
        print("filter test")
    }

    @IBAction func onAddEntryTouch(sender: AnyObject) {
        print("entry test")
        self.showPopupWithStyle(CNPPopupStyle.Centered)

        
    }
    
    
    func showPopupWithStyle(popupStyle: CNPPopupStyle) {
        
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
        postButton.setTitle("Post Item", forState: UIControlState.Normal)
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
        let textField = UITextField.init(frame: CGRectMake(0, 0, 280, 100))
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.placeholder = "Add Text here"
        customView.addSubview(textField)
        
        doneButton.selectionHandler = { (CNPPopupButton button) -> Void in
            self.popupController.dismissPopupControllerAnimated(true)
            print("Block for button: \(button.titleLabel?.text)")
        }
        
        postButton.selectionHandler = { (CNPPopupButton button) -> Void in
            
            // YO BACKEND: TEXT TO POST IS IN HERE. YOU GET IT FROM textField.text
            // HANDLE GETTING THAT STRING FROM HERE. ONCE THIS BUTTON IS CLICKED THE VIEW WILL CLOSE
            print("About to create NF Object");
            self.createNFObject(textField.text!, currentUser: AppUser.currentUser(), imageData: nil);
            self.popupController.dismissPopupControllerAnimated(true)
        }
        
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title
        
        let lineOneLabel = UILabel()
        lineOneLabel.numberOfLines = 0;
        lineOneLabel.attributedText = lineOne;
        
        let imageView = UIImageView.init(image: UIImage.init(named: "icon"))
       
        self.popupController = CNPPopupController(contents:[titleLabel, lineOneLabel, imageView, textField, buttonView])
        self.popupController.theme = CNPPopupTheme.defaultTheme()
        self.popupController.theme.popupStyle = popupStyle
        self.popupController.delegate = self
        self.popupController.presentPopupControllerAnimated(true)
    }
    
    func createNFObject(starterText: String, currentUser: AppUser?, imageData: NSData?) {
        print("Creating NFObject");
        let newNF = NFObject();
        let currentUser = AppUser.currentUser();
        newNF.setInitialValues(starterText, teamName: currentUser.getTeamName(),level: currentUser.getCaregiverAccessLevel(), imageData: imageData);
        //newNF.setInitialValues(starterText, teamName: currentUser.getTeamName(),level: currentUser.getCaregiverAccessLevel(), imageData: imageData);
        print("Initialized values");
        newNF.update();
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
