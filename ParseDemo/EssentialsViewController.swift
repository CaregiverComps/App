//
//  EssentialsViewController.swift
//  Caregiving
//
//  Created by Julia Bindler on 2/11/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit

class EssentialsViewController: PFQueryTableViewController {
    
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
        cell!.imageView!.image = image
        
        return cell
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
