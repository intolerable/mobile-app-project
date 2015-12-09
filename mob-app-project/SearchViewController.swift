//
//  SearchViewController.wift.swift
//  mob-app-project
//
//  Created by Harry Duce on 08/12/2015.
//  Copyright © 2015 HarryFraser. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Dota 2 Match Finder"
        
        searchTextField.delegate = self
        
        let key = getAPIKey()
        
        retrieveJSON(getMatchHistory(key)) { x in
            switch x {
            case let Either.Left(err):
                print(err)
            case let Either.Right(j):
                print(parseMatchHistory(j as! [String: AnyObject]))
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Properties
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: Actions
    
    func textFieldShouldReturn(searchTextField: UITextField) -> Bool {
        // Hides the keyboard when return is pressed
        searchTextField.resignFirstResponder()
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "usernameSearchSegue" {
            if let svc = segue.destinationViewController as? UserMatchHistory {
                svc.requestedAccountURL = searchTextField.text
            }
        }
    }
}
