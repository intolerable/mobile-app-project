//
//  UserMatchHistory.swift
//  mob-app-project
//
//  Created by Harry Duce on 08/12/2015.
//  Copyright © 2015 HarryFraser. All rights reserved.
//

import Foundation
import UIKit

class UserMatchHistory: UITableViewController {
    
    var matches: [Match] = []
    
    var requestedAccountURL: String?

    @IBOutlet var historyView: UITableView!
    
    override func viewDidLoad() {
        if
            let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                retrieveJSON(getMatchHistory(dict["api key"] as! String)) { x in
                    switch x {
                    case let Either.Left(err):
                        print(err)
                    case let Either.Right(j):
                        if let mh = parseMatchHistory(j as! [String: AnyObject]) {
                            self.matches = mh.matches
                            dispatch_async(dispatch_get_main_queue()) {
                                self.historyView.reloadData()
                            }
                        }
                    }
                }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("prototypeCell1")! as UITableViewCell
        
        cell.textLabel?.text = String(matches[indexPath.row])
        
        return cell
    }
}