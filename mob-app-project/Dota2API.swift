//
//  Dota2API.swift
//  mob-app-project
//
//  Created by Fraser Murray on 08/12/2015.
//  Copyright © 2015 HarryFraser. All rights reserved.
//

import Foundation

struct MatchHistory {
    let numResults: Int
    let totalResults: Int
    let remainingResults: Int
    let matches: [Match]
}

struct Match {
    let matchID: MatchID
    let startTime: NSDate
    let heroes: [Int]
}

func parseMatchHistory(dict: NSDictionary) -> MatchHistory? {
    if
        let res = dict["result"] as? [String: AnyObject],
        let numResults = res["num_results"] as? Int,
        let totalResults = res["total_results"] as? Int,
        let remainingResults = res["results_remaining"] as? Int,
        let matches = res["matches"] as? [[String: AnyObject]],
        let parsedMatches = traverse(parseMatch, over: matches) {
            let mh = MatchHistory(
                numResults: numResults,
                totalResults: totalResults,
                remainingResults: remainingResults,
                matches: parsedMatches)
            return Optional.Some(mh)
    } else {
        return Optional.None
    }
}

func parseMatch(dict: NSDictionary) -> Match? {
    if
        let mid = dict["match_id"] as? Int,
        let startTimestamp = dict["start_time"] as? Int,
        let players = dict["players"] as? [[String: AnyObject]],
        let heroIDs = traverse(parseHero, over: players)
        {
            let m = Match(
                matchID: mid,
                startTime: NSDate(timeIntervalSince1970: Double(startTimestamp)),
                heroes: heroIDs)
            return Optional.Some(m)
    } else {
        return Optional.None
    }
}

func parseHero(dict: NSDictionary) -> Int? {
    return dict["hero_id"] as? Int
}

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
