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
