//
//  Utilities.swift
//  mob-app-project
//
//  Created by Fraser Murray on 09/12/2015.
//  Copyright © 2015 HarryFraser. All rights reserved.
//

import Foundation

// given a function f which transforms something to an optional, and a list of those
//   somethings, map the list of those somethings to a list of optionals, and then,
//   if every optional in the list is Some, return an Some optional of the list.
func traverse<A,B>(f: (A -> B?), over: [A]) -> [B]? {
    var array: [B]? = Optional.Some([])
    over.map(f).forEach { x in
        if let val = x {
            array?.append(val)
        } else {
            array = Optional.None
        }
    }
    return array
}

// dispatch a closure onto the main thread (UI actions need to be run on main
//   so they take effect promptly). this function is only used for convenience,
//   we can just use dispatch_async every time but this is much neater
func onMainThread(action: (Void -> Void)) {
    dispatch_async(dispatch_get_main_queue(), action)
}

// fetches the API key from Keys.plist, and panics if there isnt one
func getAPIKey() -> APIKey {
    if
        let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist"),
        let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
            return dict["api key"] as! String
    } else {
        print("No API key configured in Keys.plist!")
        exit(0)
    }
}

// if we have an int, we need to check if it's a valid accountID. valve's api includes
//   nonsense data that wont parse to represent a user whose profile is private
func intToAccID(intID: Int?) -> AccountID32? {
    return intID.flatMap({$0 == -1 ? Optional.None : UInt32($0)})
}

// return a nice human-readable string from a date interval
func timeAgo(date: NSDate) -> String {
    let seconds = Int(NSDate().timeIntervalSinceDate(date))
    let minutes = seconds / 60
    let hours = minutes / 60
    let days = hours / 24
    let weeks = days / 7
    if weeks > 1 { return "\(weeks) weeks ago" }
    if weeks > 0 { return "\(weeks) week ago" }
    if days > 1 { return "\(days) days ago" }
    if days > 0 { return "\(days) day ago" }
    if hours > 1 { return "\(hours) hours ago" }
    if hours > 0 { return "\(hours) hour ago" }
    if minutes > 1 { return "\(minutes) minutes ago" }
    if minutes > 0 { return "\(minutes) minute ago" }
    return "less than a minute ago"
}

// partition an array into two arrays, one whose values evaluate to
//   true through the predicate, and one whose values evaluate to
//   false through the predicate
func partition<A>(array: [A], fn: (A -> Bool)) -> ([A], [A]) {
    var trues: [A] = []
    var falses: [A] = []
    
    array.forEach { x in
        if fn(x) {
            trues.append(x)
        } else {
            falses.append(x)
        }
    }
    
    return (trues, falses)
}
