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
    
    let team1 = ["Player 1", "Player 2", "Player 3", "Player 4", "Player 5"]
    let team2 = ["Player 1", "Player 2", "Player 3", "Player 9", "Player 10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        team1Table.delegate = self
        team2Table.delegate = self
        team1Table.dataSource = self
        team2Table.dataSource = self
        
        scrollView.contentSize.height = 1000
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(team1Table) {
            return team1.count
        }
        else {
            return team2.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.isEqual(team1Table){
            
            let cell = tableView.dequeueReusableCellWithIdentifier("team1Cell")! as UITableViewCell
            
            cell.textLabel?.text = team1[indexPath.row]
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("team2Cell")! as UITableViewCell
            
            cell.textLabel?.text = team2[indexPath.row]
            
            return cell
        }
    }
}