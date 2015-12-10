//
//  Utilities.swift
//  mob-app-project
//
//  Created by Fraser Murray on 09/12/2015.
//  Copyright © 2015 HarryFraser. All rights reserved.
//

import Foundation

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

func onMainThread(action: (Void -> Void)) {
    dispatch_async(dispatch_get_main_queue(), action)
}

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

func intToAccID(intID: Int?) -> AccountID32? {
    return intID.flatMap({$0 == -1 ? Optional.None : UInt32($0)})
}

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
