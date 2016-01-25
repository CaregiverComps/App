//
//  NewsfeedViewController.swift
//  Caregiving
//
//  Created by Julia Bindler on 1/24/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit



class NewsfeedViewController: PFQueryTableViewController {
    
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        // Do any additional setup after loading the view.
        
       
    }
    
    override func queryForTable() -> PFQuery {
        let query:PFQuery = PFQuery(className:self.parseClassName!)
        query.limit = self.limit
        //query.orderByAscending("objectId")
        
        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            self.limit += 10
            query.limit = self.limit
            
            
            //self.items = [Int](count: self.items.count+20, repeatedValue: 0)
            //
            // fetch your data here, can be async operation,
            // just make sure to call finishInfiniteScroll in the end
            //
            
            // make sure you reload tableView before calling -finishInfiniteScroll
            //tableView.reloadData()
            self.loadObjects()
            
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
        return query
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell:CellViewController? = tableView.dequeueReusableCellWithIdentifier("newsCell") as? CellViewController
        
        if let pfObject = object {
            cell?.textLabel?.text = pfObject["TEXT"] as? String
            cell?.textLabel?.numberOfLines = 0
        }
        return cell;
    }
}
