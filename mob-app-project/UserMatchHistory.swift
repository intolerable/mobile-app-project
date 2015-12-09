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
                        self.accountID = Optional.Some(acc)
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
    
    func getUserAccount(accID: AccountID32, players: [Player]) -> Player? {
        print("players: \(players.map({$0.accountID}))")
        if let p = players.filter({ $0.accountID == accID }).first {
            return Optional.Some(p)
        } else {
            return Optional.None
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("prototypeCell1")! as UITableViewCell
        
        if
            let accID = self.accountID,
            let userAccount = getUserAccount(accID, players: matches[indexPath.row].players) {
            cell.textLabel?.text = String("Hero: \(userAccount.heroID)")
        } else {
            cell.textLabel?.text = String(matches[indexPath.row])
        }
        
        return cell
    }
}