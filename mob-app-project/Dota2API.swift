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
}
