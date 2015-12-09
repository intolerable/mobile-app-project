//
//  HTTPStuff.swift
//  mob-app-project
//
//  Created by Fraser Murray on 08/12/2015.
//  Copyright © 2015 HarryFraser. All rights reserved.
//

import Foundation

func getMatchHistory(key: String) -> NSURL {
    return NSURL(string: "https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v1/?key=\(key)&language=en")!
}

func getMatchHistory(key: String, accountID: AccountID32) -> NSURL {
    return NSURL(string: "https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v1/?key=\(key)&language=en&account_id=\(accountID)")!
}

func getMatchHistory(key: String, accountID: AccountID32?) -> NSURL {
    if let id = accountID {
        return getMatchHistory(key, accountID: id)
    } else {
        return getMatchHistory(key)
    }
}

func resolveVanityURL(key: String, vanityURL: String) -> NSURL {
    return NSURL(string: "https://api.steampowered.com/ISteamUser/ResolveVanityURL/v0001/?key=\(key)&vanityurl=\(vanityURL)")!
}

struct MatchHistoryRequest {
    let forAccount: AccountID32
}

struct MatchDetailsRequest {
    let forMatchID: MatchID
}

enum Either<a, b> { case Left(a), Right(b) }

func retrieveJSON(url: NSURL, handler: (Either<NSError, AnyObject> -> Void)) -> Void {
    
    let session = NSURLSession.sharedSession()
    
    let task = session.dataTaskWithURL(url) { (data, response, error) in
        if let data = data {
            do {
                let parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                
                handler(Either.Right(parsedObject))
            } catch let err as NSError {
                handler(Either.Left(err))
            }
        } else {
            handler(Either.Left(error!))
        }
    }
    
    task.resume()
    
}
