//
//  MatchDetailController.swift
//  mob-app-project
//
//  Created by Harry Duce on 08/12/2015.
//  Copyright © 2015 HarryFraser. All rights reserved.
//

import Foundation
import UIKit

class MatchDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Outlet
    @IBOutlet weak var team1Table: UITableView!
    @IBOutlet weak var team2Table: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var victoryLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Properties
    
    var player: AccountID32?
    var matchID: MatchID?
    var matchDetails: MatchDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let matchID = matchID {
            team1Table.delegate = self
            team2Table.delegate = self
            team1Table.dataSource = self
            team2Table.dataSource = self
            
            team1Table.tableFooterView = UIView()
            team2Table.tableFooterView = UIView()
            
            scrollView.contentSize.height = 1000
            
            self.title = "#\(matchID)"
            
            let key = getAPIKey()
            retrieveJSON(getMatchDetails(key, matchID: matchID)) { x in
                switch x {
                case let Either.Left(err):
                    print(err)
                case let Either.Right(response):
                    if let parsedMatchDetails = parseMatchDetails(response as! [String: AnyObject]){
                        self.matchDetails = parsedMatchDetails
                        let (radiants, dires) = self.teamPartition(parsedMatchDetails.matchPlayers)
                        onMainThread {
                            self.setVictoryLabelText(parsedMatchDetails.radiantWin)
                            self.setScoreLabelText(radiants, dires: dires)
                            self.team1Table.reloadData()
                            self.team2Table.reloadData()
                            self.team1Table.sizeToFit()
                            self.team2Table.sizeToFit()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let matchDetails = self.matchDetails {

            let (radiants, dires) = teamPartition(matchDetails.matchPlayers)
            
            if tableView.isEqual(team1Table) {
                return radiants.count
            } else {
                return dires.count
            }
        } else {
            return 0
        }
    }

    func setVictoryLabelText(radiantWin: Bool) -> Void {
        if radiantWin {
            victoryLabel.text = "Radiant Victory"
        } else {
            victoryLabel.text = "Dire Victory"
        }
    }
    
    func setScoreLabelText(radiants: [MatchPlayer], dires: [MatchPlayer]) -> Void {
        let radiantScore = radiants.map({$0.kills}).reduce(0, combine: {$0 + $1})
        let direScore = dires.map({$0.kills}).reduce(0, combine: {$0 + $1})
        
        scoreLabel.text = "Score: \(radiantScore) - \(direScore)"
        
    }
    
    // partition an array of players into two teams, those on the radiant and
    //   those on the dire. the way we check for which team they're on is by 
    //   doing a bitwise and with 128, as that's the bit checked to determine teams
    func teamPartition(players: [MatchPlayer]) -> ([MatchPlayer], [MatchPlayer]) {
        return partition(players) { player in
            !Bool(128 & player.position)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let matchDetails = self.matchDetails {
            let (radiants, dires) = teamPartition(matchDetails.matchPlayers)
            
            if tableView.isEqual(team1Table){
                
                let cell = tableView.dequeueReusableCellWithIdentifier("team1Cell")! as UITableViewCell
                
                cell.textLabel?.text = "KDA: \(radiants[indexPath.row].kills)/\(radiants[indexPath.row].deaths)/\(radiants[indexPath.row].assists)  Level: \(radiants[indexPath.row].level)"
                
                if let heroName = heroIDMapping[radiants[indexPath.row].heroID] {
                    cell.imageView?.image = UIImage(named: "HeroIcons/\(heroName).jpg")
                }
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("team2Cell")! as UITableViewCell
                
                cell.textLabel?.text = "KDA: \(dires[indexPath.row].kills)/\(dires[indexPath.row].deaths)/\(dires[indexPath.row].assists)    Level: \(dires[indexPath.row].level)"
                
                if let heroName = heroIDMapping[dires[indexPath.row].heroID] {
                    cell.imageView?.image = UIImage(named: "HeroIcons/\(heroName).jpg")
                }
                
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
}