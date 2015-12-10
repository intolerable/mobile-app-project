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
    var accountID: AccountID32?

    @IBOutlet var historyView: UITableView!
    
    override func viewDidLoad() {
        
        self.title = requestedAccountURL
        
        self.refreshControl?.beginRefreshing()
        
        self.reloadContent()
    }
    
    // when the view initially loads or the refresh pull is activated, we
    //   pull all the content from the remote server again and then update
    //   the views
    func reloadContent() {
        let key = getAPIKey()
        func handleJSONHistory(resp: Either<NSError, AnyObject>) {
            switch resp {
            case let Either.Left(err):
                self.showErrorPopup()
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
                        self.accountID = Optional.Some(acc)
                        retrieveJSON(getMatchHistory(key, accountID: acc), handler: handleJSONHistory)
                    } else {
                        self.showErrorPopup("That user doesn't exist")
                    }
                case let Either.Left(y):
                    handleJSONHistory(Either.Left(y))
                }
            }
        } else {
            retrieveJSON(getMatchHistory(key), handler: handleJSONHistory)
        }
        
        self.refreshControl?.endRefreshing()
        
    }
    
    // handle the refresh pull and reload everything
    @IBAction func refreshView(sender: UIRefreshControl) {
        
        self.reloadContent()
    }
    
    func setMatches(matches: [Match]) {
        self.matches = matches
        self.refreshControl?.endRefreshing()
        onMainThread {
            self.historyView.reloadData()
        }
    }
    
    func showErrorPopup() {
        self.showErrorPopup(Optional.None)
    }
    
    // do a neat popup for when there's an error
    func showErrorPopup(err: String?) {
        let alert = UIAlertController(
            title: "Error",
            message: err ?? "Couldn't load match history information",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.Default,
                handler: {_ in alert.dismissViewControllerAnimated(true, completion: Optional.None)})
            )
        
        onMainThread {
            self.presentViewController(alert, animated: true, completion: Optional.None)
        }
    }
    
    // try to find the active user (by ID) in the players list
    func getUserAccount(accID: AccountID32, players: [Player]) -> Player? {
        if let p = players.filter({ $0.accountID == accID }).first {
            return Optional.Some(p)
        } else {
            return Optional.None
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    // handle the list cells for the history. if we know who the requested user is (i.e. we're not just
    //   looking for *any* games), then we show an icon to distinguish which hero they were playing
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let match = matches[indexPath.row]
        
        if
            let accID = self.accountID,
            let userAccount = getUserAccount(accID, players: matches[indexPath.row].players) {
            let cell = tableView.dequeueReusableCellWithIdentifier("knownPlayer")! as UITableViewCell
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.text = "#\(match.matchID) (\(timeAgo(match.startTime)))"
            if let heroName = heroIDMapping[userAccount.heroID] {
                cell.imageView?.image = UIImage(named: "HeroIcons/\(heroName).jpg")
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("knownPlayer")! as UITableViewCell
            cell.textLabel?.text = "#\(match.matchID) (\(timeAgo(match.startTime)))"
            return cell
        }
    }
    
    // set up the segue transition by passing along the match and player IDs
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMatchDetails" {
            if
                let mdc = segue.destinationViewController as? MatchDetailController,
                let tvc = sender as? UITableViewCell,
                let selectedRow = self.tableView.indexPathForCell(tvc)
                {
                mdc.player = accountID
                mdc.matchID = matches[selectedRow.indexAtPosition(1)].matchID
            }
        }
    }
}