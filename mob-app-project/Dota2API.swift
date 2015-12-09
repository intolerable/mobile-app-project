//
//  Dota2API.swift
//  mob-app-project
//
//  Created by Fraser Murray on 08/12/2015.
//  Copyright © 2015 HarryFraser. All rights reserved.
//

import Foundation

typealias APIKey = String
typealias AccountID64 = UInt64
typealias AccountID32 = UInt32
typealias MatchID = Int

struct MatchHistory {
    let numResults: Int
    let totalResults: Int
    let remainingResults: Int
    let matches: [Match]
}

struct Match {
    let matchID: MatchID
    let startTime: NSDate
    let players: [Player]
}

struct Player {
    let heroID: Int
    let accountID: AccountID32?
    let position: Int
}

struct MatchDetails {
    let matchID: MatchID
}

func accountID32to64(account: AccountID32) -> AccountID64 {
    let universeID: UInt64 = 1
    let accountType: UInt64 = 1
    let instance: UInt64 = 1
    return ((universeID << 56) | (accountType << 52) | (instance << 32) | UInt64(account))
}

func accountID64to32(account: AccountID64) -> AccountID32 {
    return UInt32(truncatingBitPattern: account)
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
        let parsedPlayers = traverse(parsePlayer, over: players)
        {
            let m = Match(
                matchID: mid,
                startTime: NSDate(timeIntervalSince1970: Double(startTimestamp)),
                players: parsedPlayers
            )
            return Optional.Some(m)
    } else {
        return Optional.None
    }
}

func parseMatchDetails(dict: NSDictionary) -> MatchDetails? {
    if
        let mid = dict["match_id"] as? Int
    {
        let md = MatchDetails(
            matchID: mid)
        return Optional.Some(md)
    } else {
        return Optional.None
    }
}

func parsePlayer(dict: NSDictionary) -> Player? {
    if
        let heroID = dict["hero_id"] as? Int,
        let position = dict["player_slot"] as? Int {
            let p = Player(
                heroID: heroID,
                accountID: (dict["account_id"] as? Int).flatMap({UInt32($0)}),
                position: position)
            return Optional.Some(p)
    } else {
        return Optional.None
    }
}

func parseAccount(dict: NSDictionary) -> AccountID32? {
    if
        let response = dict["response"] as? [String: AnyObject],
        let idString = response["steamid"] as? String,
        let steamID = UInt64(idString) {
            return accountID64to32(steamID)
    } else {
        return Optional.None
    }
}
