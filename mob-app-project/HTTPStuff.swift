//
//  HTTPStuff.swift
//  mob-app-project
//
//  Created by Fraser Murray on 08/12/2015.
//  Copyright © 2015 HarryFraser. All rights reserved.
//

import Foundation

typealias APIKey = String
typealias AccountID = String
typealias MatchID = Int


func apiURL(key: String) -> String {
    return "https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v1/?key=\(key)&language=en"
}

struct MatchHistoryRequest {
    let forAccount: AccountID
}

struct MatchDetailsRequest {
    let forMatchID: MatchID
}

enum Either<a, b> { case Left(a), Right(b) }

func retrieveJSON(url: NSURL, handler: (Either<NSError, AnyObject> -> Void)) -> Void {
    
    let session = NSURLSession.sharedSession()
    
    let task = session.dataTaskWithURL(url) { (data, response, error) in
        do {
            let parsedObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            
            handler(Either.Right(parsedObject))
        } catch let err as NSError {
            handler(Either.Left(err))
        }
    }
    
    task.resume()
    
}
