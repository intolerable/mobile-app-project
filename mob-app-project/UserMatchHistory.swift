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
        
        self.title = requestedAccountURL ?? "Recent Matches"
        
        let key = getAPIKey()
        func handleJSONHistory(resp: Either<NSError, AnyObject>) {
            switch resp {
            case let Either.Left(err):
                print(err) // actually handle the error...
            case let Either.Right(j):
                if let mh = parseMatchHistory(j as! [String: AnyObject]) {
                    self.setMatches(mh.matches)
                }
            }
        }
        if let account = requestedAccountURL {
            retrieveJSON(resolveVanityURL(key, vanityURL: account)) { x in
                switch x {
                case let Either.Right(j):
                    if let acc = parseAccount(j as! [String: AnyObject]) {
                        retrieveJSON(getMatchHistory(key, accountID: acc), handler: handleJSONHistory)
                    }
                case let Either.Left(y):
                    handleJSONHistory(Either.Left(y))
                }
            }
        } else {
            retrieveJSON(getMatchHistory(key), handler: handleJSONHistory)
        }
    }
    
    func setMatches(matches: [Match]) {
        self.matches = matches
        onMainThread {
            self.historyView.reloadData()
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